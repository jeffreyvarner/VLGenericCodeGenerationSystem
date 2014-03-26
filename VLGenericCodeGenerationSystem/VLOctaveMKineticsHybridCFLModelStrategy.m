//
//  VLOctaveMKineticsHybridCFLModelStrategy.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 3/25/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLOctaveMKineticsHybridCFLModelStrategy.h"

#define NEW_LINE [buffer appendString:@"\n"]

@implementation VLOctaveMKineticsHybridCFLModelStrategy

-(id)executeStrategyWithOptions:(NSDictionary *)options
{
    if (options == nil)
    {
        return nil;
    }
    
    // Buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // Get our trees from the dictionary -
    __unused NSXMLDocument *transformation_tree = [options objectForKey:kXMLTransformationTree];
    NSXMLElement *transformation = [options objectForKey:kXMLTransformationElement];
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:kXMLModelInputTree];
    
    // What is my model type?
    NSString *model_source_encoding = [[[input_tree nodesForXPath:@".//model/@source_encoding" error:nil] lastObject] stringValue];
    
    // my function name?
    NSString *fname_xpath = @"./output_handler/transformation_property[@type=\"FUNCTION_NAME\"]/@value";
    NSString *tmpFunctionName = [[[transformation nodesForXPath:fname_xpath error:nil] lastObject] stringValue];
    
    // generate the kinetics -
    if ([model_source_encoding isEqualToString:kSourceEncodingCFLML] == YES)
    {
        // ok, we have the correct source encoding -
        [buffer appendFormat:@"function [rV] = %@(t,x,DF)\n",tmpFunctionName];
        NEW_LINE;
        
        [buffer appendString:@"\t% Correct for negatives - \n"];
        [buffer appendString:@"\tIDXN = find(x<0);\n"];
        [buffer appendString:@"\tx(IDXN,1) = 0;\n"];
        NEW_LINE;
        
        [buffer appendString:@"\t% Get the parameter vector - \n"];
        [buffer appendString:@"\tkV = DF.PARAMETER_VECTOR;\n"];
        NEW_LINE;
        [buffer appendString:@"\t% Alias zero - \n"];
        [buffer appendString:@"\tEPSILON = 1e-6;\n"];
        NEW_LINE;
        [buffer appendString:@"\t% Alias the species symbols - \n"];
        
        // Get list of species -
        NSInteger species_counter = 1;
        NSMutableArray *species_array = [[NSMutableArray alloc] init];
        NSArray *species_node_array = [input_tree nodesForXPath:@".//speciesReference" error:nil];
        for (NSXMLElement *species_node in species_node_array)
        {
            // Get the species symbol -
            NSString *species_symbol = [[species_node attributeForName:@"species"] stringValue];
            
            if ([species_array containsObject:species_symbol] == NO)
            {
                [species_array addObject:species_symbol];
            }
        }
        for (NSString *species_symbol in species_array)
        {
            // write the buffer line -
            [buffer appendFormat:@"\t%@ = x(%lu,1);\n",species_symbol,species_counter];
            species_counter++;
        }
        NEW_LINE;
        
        // Alias the parameters -
        [buffer appendString:@"\t% Alias the parameter symbols - \n"];
        NSArray *rule_array = [input_tree nodesForXPath:@".//listOfRules/rule" error:nil];
        NSInteger rule_counter = 1;
        NSInteger parameter_counter = 1;
        for (NSXMLElement *rule_node in rule_array)
        {
            // Get the species for this rule -
            NSArray *species_array = [rule_node nodesForXPath:@"./listOfReactants/speciesReference" error:nil];
            for (NSXMLElement *species_node in species_array)
            {
                // get the symbol -
                NSString *species_symbol = [[species_node attributeForName:@"species"] stringValue];
                
                // Write -
                [buffer appendFormat:@"\tK_%@_R%lu = kV(%lu,1);\n",species_symbol,rule_counter,(parameter_counter++)];
                [buffer appendFormat:@"\tN_%@_R%lu = kV(%lu,1);\n",species_symbol,rule_counter,(parameter_counter++)];
            }
            
            // update -
            rule_counter++;
        }
        NEW_LINE;
        
        // Write the rules -
        [buffer appendString:@"\t% Write the rules - \n"];
        rule_counter = 1;
        parameter_counter = 1;
        for (NSXMLElement *rule_node in rule_array)
        {
            // Get the species for this rule -
            NSArray *species_array = [rule_node nodesForXPath:@"./listOfReactants/speciesReference" error:nil];
            for (NSXMLElement *species_node in species_array)
            {
                // get the symbol -
                NSString *species_symbol = [[species_node attributeForName:@"species"] stringValue];
                
                // Write -
                [buffer appendFormat:@"\tP_%@_R%lu = ",species_symbol,rule_counter];
                [buffer appendFormat:@"(%@^N_%@_R%lu)/",species_symbol,species_symbol,rule_counter];
                [buffer appendFormat:@"(%@^N_%@_R%lu",species_symbol,species_symbol,rule_counter];
                [buffer appendFormat:@"+K_%@_R%lu^N_%@_R%lu);\n",species_symbol,rule_counter,species_symbol,rule_counter];
            }
            
            // what is this rule type -
            NSString *rule_type = [[rule_node attributeForName:@"type"] stringValue];
            if ([rule_type isEqualToString:@"AND"] == YES)
            {
                [buffer appendFormat:@"\trV(%lu,1) = 1.0",rule_counter];
                for (NSXMLElement *species_node in species_array)
                {
                    // get the symbol -
                    NSString *species_symbol = [[species_node attributeForName:@"species"] stringValue];
                    
                    // Write -
                    [buffer appendFormat:@"*(P_%@_R%lu)",species_symbol,rule_counter];
                }
                
                // buffer -
                [buffer appendString:@";\n"];
                NEW_LINE;
            }
            else if ([rule_type isEqualToString:@"OR"] == YES)
            {
                [buffer appendFormat:@"rV(%lu,1) = 0.0",rule_counter];
                for (NSXMLElement *species_node in species_array)
                {
                    // get the symbol -
                    NSString *species_symbol = [[species_node attributeForName:@"species"] stringValue];
                    
                    // Write -
                    [buffer appendFormat:@"+(P_%@_R%lu)",species_symbol,rule_counter];
                }
                
                [buffer appendString:@"-1.0"];
                for (NSXMLElement *species_node in species_array)
                {
                    // get the symbol -
                    NSString *species_symbol = [[species_node attributeForName:@"species"] stringValue];
                    
                    // Write -
                    [buffer appendFormat:@"*(P_%@_R%lu)",species_symbol,rule_counter];
                }

                // buffer -
                [buffer appendString:@";\n"];
            }
            
            // update -
            rule_counter++;
        }
        
        NEW_LINE;
        [buffer appendString:@"\t% Check for small reaction - \n"];
        [buffer appendString:@"\tIDX = find(rV<EPSILON);\n"];
        [buffer appendString:@"\trV(IDX,1) = EPSILON;\n"];
        NEW_LINE;
        
        // close -
        [buffer appendString:@"return;\n"];
    }
    
    // return -
    return buffer;
}

@end
