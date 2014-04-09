//
//  VLOctaveMDataFileHybridCFLModelStrategy.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 3/25/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLOctaveMDataFileHybridCFLModelStrategy.h"

#define NEW_LINE [buffer appendString:@"\n"]

@implementation VLOctaveMDataFileHybridCFLModelStrategy

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
        [buffer appendFormat:@"function DF = %@(START,STOP)\n",tmpFunctionName];
        NEW_LINE;
        
        [buffer appendString:@"\t% Load the network - \n"];
        [buffer appendString:@"\tS = load('Network.dat');\n"];
        [buffer appendString:@"\t[NSTATES,NRATES] = size(S);\n"];
        NEW_LINE;
        
        // Get list of species -
        NSInteger species_counter = 1;
        NSMutableArray *species_array = [[NSMutableArray alloc] init];
        NSArray *species_node_array = [input_tree nodesForXPath:@".//speciesReference" error:nil];
        for (NSXMLElement *species_node in species_node_array)
        {
            // Get the species symbol -
            NSString *species_symbol = [[species_node attributeForName:@"species"] stringValue];
            
            if ([species_array containsObject:species_symbol] == NO &&
                [species_symbol isEqualToString:@"[]"] == NO)
            {
                [species_array addObject:species_symbol];
            }
        }
        
        // Alias the parameters -
        [buffer appendString:@"\tkV = [\n"];
        NSArray *rule_array = [input_tree nodesForXPath:@".//listOfRules/rule" error:nil];
        NSInteger rule_counter = 1;
        NSInteger parameter_counter = 1;
        for (NSXMLElement *rule_node in rule_array)
        {
            // comment?
            NSString *comment = [[rule_node attributeForName:@"symbol"] stringValue];
            
            [buffer appendFormat:@"\t\t%% %@ -- \n",comment];
            [buffer appendFormat:@"\t\t1.00\t\t;\t%% %lu ALPHA_R%lu\n",(parameter_counter++),rule_counter];
            
            // Get the species for this rule -
            NSArray *species_array = [rule_node nodesForXPath:@"./listOfReactants/speciesReference" error:nil];
            for (NSXMLElement *species_node in species_array)
            {
                // get the symbol -
                NSString *species_symbol = [[species_node attributeForName:@"species"] stringValue];
                
                // Write -
                [buffer appendFormat:@"\t\t10.0\t\t;\t%% %lu K_%@_R%lu\t%@\n",(parameter_counter++),species_symbol,rule_counter,comment];
                [buffer appendFormat:@"\t\t10.0\t\t;\t%% %lu N_%@_R%lu\t%@\n",(parameter_counter++),species_symbol,rule_counter,comment];
                NEW_LINE;
            }
            
            // update -
            rule_counter++;
        }
        [buffer appendString:@"\t];\n"];
        NEW_LINE;
        
        [buffer appendString:@"\tIC = [\n"];
        for (NSString *species_symbol in species_array)
        {
            // write the buffer line -
            [buffer appendFormat:@"\t\t0.0\t\t;\t%% %lu\t%@\n",(species_counter++),species_symbol];
        }
        [buffer appendString:@"\t];\n"];
        NEW_LINE;

        
        [buffer appendString:@"\t% package - \n"];
        [buffer appendString:@"\tDF.INITIAL_CONDITION_VECTOR = IC;\n"];
        [buffer appendString:@"\tDF.NUMBER_OF_RATES = NRATES;\n"];
        [buffer appendString:@"\tDF.STOICHIOMETRIC_MATRIX = S;\n"];
        [buffer appendString:@"\tDF.PARAMETER_VECTOR = kV;\n"];
        [buffer appendString:@"\tDF.NUMBER_OF_STATES = NSTATES;\n"];
        NEW_LINE;
        
        // close -
        [buffer appendString:@"return;\n"];
    }
 
    // return -
    return buffer;
}


@end
