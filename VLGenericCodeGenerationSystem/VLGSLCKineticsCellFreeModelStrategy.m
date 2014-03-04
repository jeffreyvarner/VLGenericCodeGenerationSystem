//
//  VLGSLCKineticsCellFreeModelStrategy.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 3/3/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLGSLCKineticsCellFreeModelStrategy.h"

#define NEW_LINE [buffer appendString:@"\n"]

@implementation VLGSLCKineticsCellFreeModelStrategy

-(id)executeStrategyWithOptions:(NSDictionary *)options
{
    if (options == nil)
    {
        return nil;
    }
    
    // ok, so this is going to use the *standard* data file -
    // Buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // Get our trees from the dictionary -
    NSXMLDocument *transformation_tree = [options objectForKey:kXMLTransformationTree];
    NSXMLElement *transformation = [options objectForKey:kXMLTransformationElement];
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:kXMLModelInputTree];
    
    // What is my model type?
    NSString *model_source_encoding = [[[input_tree nodesForXPath:@".//model/@source_encoding" error:nil] lastObject] stringValue];
    
    // function name?
    NSString *fname_xpath = @"./output_handler/transformation_property[@type=\"FUNCTION_NAME\"]/@value";
    NSString *tmpFunctionName = [[[transformation nodesForXPath:fname_xpath error:nil] lastObject] stringValue];
    
    // headers -
    [buffer appendFormat:@"#include \"%@.h\"\n",tmpFunctionName];
    [buffer appendString:@"\n"];
    [buffer appendFormat:@"void %@(double t,gsl_vector *pStateVector, gsl_vector *pRateVector, void* parameter_object)\n",tmpFunctionName];
    [buffer appendString:@"{\n"];
    [buffer appendString:@"\t/* initialize -- */\n"];
    [buffer appendString:@"\tdouble rate_value = 0.0;\n"];
    [buffer appendString:@"\tdouble parameter_value = 0.0;\n"];
    [buffer appendString:@"\n"];
    [buffer appendString:@"\t/* Get the parameters from disk - */\n"];
    [buffer appendString:@"\tstruct VLParameters *parameter_struct = (struct VLParameters *)parameter_object;\n"];
    [buffer appendString:@"\tgsl_vector *pV = parameter_struct->pModelKineticsParameterVector;\n"];
    [buffer appendString:@"\n"];
    [buffer appendString:@"\t/* Alias elements of the state vector - */\n"];
    
    if ([model_source_encoding isEqualToString:kSourceEncodingVFF] == YES)
    {
        
    }
    else if ([model_source_encoding isEqualToString:kSourceEncodingSBML] == YES)
    {
        // construct a list of enzymes -
        NSArray *reaction_list = [input_tree nodesForXPath:@".//reaction" error:nil];
        NSMutableArray *enzyme_array = [[NSMutableArray alloc] init];
        NSInteger enzyme_counter = 0;
        for (NSXMLElement *reaction_node in reaction_list)
        {
            // what is the name of the reaction?
            NSString *reaction_id = [[reaction_node attributeForName:@"id"] stringValue];
            
            // if we have a foward rate - then update enzyme index
            NSString *enzyme_string;
            NSRange forward_range = [reaction_id rangeOfString:@"FORWARD"];
            NSRange reverse_range = [reaction_id rangeOfString:@"REVERSE"];
            if (forward_range.location != NSNotFound)
            {
                 enzyme_string = [NSString stringWithFormat:@"(ENZYME_%lu)",(enzyme_counter++)];
            }
            else if (reverse_range.location != NSNotFound)
            {
                enzyme_counter -- ;
                enzyme_string = [NSString stringWithFormat:@"(ENZYME_%lu)",(enzyme_counter++)];
            }
            else
            {
                enzyme_string = @"1.0";
            }
            
            [enzyme_array addObject:enzyme_string];
        }
        
        
        // get the list of species -
        NSArray *species_list = [input_tree nodesForXPath:@".//species" error:nil];
        NSInteger species_counter = 0;
        for (NSXMLElement *node in species_list)
        {
            NSString *species_id = [[node attributeForName:@"id"] stringValue];
            [buffer appendFormat:@"\tdouble %@ = gsl_vector_get(pStateVector,%lu);\n",species_id,species_counter++];
        }
        
        NEW_LINE;
        
        // build reaction kinetics -
        NSInteger parameter_counter = 0;
        NSInteger rate_counter = 0;
        for (NSXMLElement *reaction_node in reaction_list)
        {
            // rate constant -
            [buffer appendFormat:@"\tdouble k_%lu = gsl_vector_get(pV,%lu);\n",rate_counter,parameter_counter++];
            
            // for this reaction - what are the reactants?
            NSArray *reactant_species_array = [reaction_node nodesForXPath:@"./listOfReactants/speciesReference" error:nil];
            
            // saturation coefficients -
            for (NSXMLElement *species_node in reactant_species_array)
            {
                // What is the symbol?
                NSString *species_symbol = [[species_node attributeForName:@"species"] stringValue];
                
                // build the reaction line -
                NSRange enzyme_range = [species_symbol rangeOfString:@"ENZYME_"];
                if (enzyme_range.location == NSNotFound)
                {
                    NSString *inner_species_symbol = [[species_node attributeForName:@"species"] stringValue];
                    [buffer appendFormat:@"\tdouble K_%@_%lu = gsl_vector_get(pV,%lu);\n",inner_species_symbol,rate_counter,parameter_counter++];
                }
            }

            
            [buffer appendFormat:@"\trate_law = k_%lu",rate_counter];
            NSString *enzyme_term = [enzyme_array objectAtIndex:rate_counter];
            [buffer appendFormat:@"*%@",enzyme_term];
            
            for (NSXMLElement *species_node in reactant_species_array)
            {
                // What is the symbol?
                NSString *species_symbol = [[species_node attributeForName:@"species"] stringValue];
                
                // build the reaction line -
                NSRange enzyme_range = [species_symbol rangeOfString:@"ENZYME_"];
                if (enzyme_range.location != NSNotFound)
                {
                    
                }
                else
                {
                    // rate law -
                    [buffer appendFormat:@"*((%@)/(K_%@_%lu + %@))",species_symbol,species_symbol,rate_counter,species_symbol];
                }
            }
            
            [buffer appendString:@";\n"];
            [buffer appendFormat:@"\tgsl_vector_set(pRateVector,rate_law,%lu);\n",rate_counter];
            NEW_LINE;
            
            // update the counter -
            rate_counter++;
        }
    }
    
    [buffer appendString:@"}\n"];
    
    // return -
    return buffer;
}

@end
