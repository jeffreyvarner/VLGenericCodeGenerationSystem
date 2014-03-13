//
//  VLGSLCBMatrixMassActionModelStrategy.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 3/13/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLGSLCBMatrixMassActionModelStrategy.h"

#define NEW_LINE [buffer appendString:@"\n"]

@implementation VLGSLCBMatrixMassActionModelStrategy

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
    
    // function name?
    NSString *fname_xpath = @"./output_handler/transformation_property[@type=\"FUNCTION_NAME\"]/@value";
    NSString *tmpFunctionName = [[[transformation nodesForXPath:fname_xpath error:nil] lastObject] stringValue];
    
    // What is my model type?
    NSString *model_source_encoding = [[[input_tree nodesForXPath:@".//model/@source_encoding" error:nil] lastObject] stringValue];
    if ([model_source_encoding isEqualToString:kSourceEncodingVFF] == YES)
    {
        // need to fill me in ...
    }
    else if ([model_source_encoding isEqualToString:kSourceEncodingSBML] == YES)
    {
        // system dimension?
        NSUInteger NUMBER_OF_RATES = [[input_tree nodesForXPath:@".//reaction" error:nil] count];
        NSUInteger NUMBER_OF_STATES = [[input_tree nodesForXPath:@".//species" error:nil] count];
        __unused NSUInteger NUMBER_OF_PARAMETERS = NUMBER_OF_RATES;
        __unused NSUInteger NUMBER_OF_COMPARTMENTS = 1;
        
        // headers -
        [buffer appendFormat:@"#include \"%@.h\"\n",tmpFunctionName];
        NEW_LINE;
        
        [buffer appendString:@"/* Problem specific define statements -- */\n"];
        [buffer appendFormat:@"#define NUMBER_OF_RATES %lu\n",NUMBER_OF_RATES];
        [buffer appendFormat:@"#define NUMBER_OF_STATES %lu\n",NUMBER_OF_STATES];
        [buffer appendString:@"#define EPSILON 1e-8\n"];
        NEW_LINE;
        
        [buffer appendFormat:@"int %@(double t, gsl_vector *pStateVector, gsl_matrix *pBMatrix, void* parameter_object)\n",tmpFunctionName];
        [buffer appendString:@"{\n"];
        
        // get parameters and setup computation -
        [buffer appendString:@"\t/* initialize -- */\n"];
        [buffer appendString:@"\tdouble rate_value = 0.0;\n"];
        [buffer appendString:@"\tdouble parameter_value = 0.0;\n"];
        [buffer appendString:@"\n"];
        [buffer appendString:@"\t/* Get the parameters from disk - */\n"];
        [buffer appendString:@"\tstruct VLParameters *parameter_struct = (struct VLParameters *)parameter_object;\n"];
        [buffer appendString:@"\tgsl_vector *pV = parameter_struct->pModelKineticsParameterVector;\n"];
        [buffer appendString:@"\n"];
        [buffer appendString:@"\t/* Alias elements of the state vector - */\n"];
        
        // ok, we have a SBML encoding, so build the species alias list -
        NSError *xpath_error;
        NSArray *state_vector = [input_tree nodesForXPath:@".//listOfSpecies/species" error:&xpath_error];
        NSMutableArray *local_state_vector = [[NSMutableArray alloc] init];
        NSInteger state_counter = 0;
        for (NSXMLElement *state in state_vector)
        {
            NSString *state_symbol = [[state attributeForName:@"id"] stringValue];
            [buffer appendFormat:@"\tdouble %@ = state[%lu];\n",state_symbol,state_counter++];
            
            // grab the state symbol -
            [local_state_vector addObject:state_symbol];
        }
        [buffer appendString:@"\n"];
        
        // build the parameter list -
        NSArray *reaction_array = [input_tree nodesForXPath:@".//reaction" error:nil];
        NSInteger rate_counter = 0;
        for (NSXMLElement *rate_node in reaction_array)
        {
            [buffer appendFormat:@"\tdouble k_%lu = gsl_vector_get(pV,%lu);\n",rate_counter,rate_counter];
            rate_counter++;
        }
        [buffer appendString:@"\n"];
        
        // build the stoichiometric matrix array -
        NSArray *stochiometric_array = [VLCoreUtilitiesLib generateStoichiometricMatrixArrayActionWithOptions:options];
        
        // Species and reaction arrays -
        NSArray *species_array = [input_tree nodesForXPath:@".//species" error:nil];
        
        // build the jacobian -
        for (NSInteger outer_index = 0;outer_index<NUMBER_OF_STATES;outer_index++)
        {
            // What is my outer index species?
            NSArray *stm_row_array = [stochiometric_array objectAtIndex:outer_index];
            
            // which rates are involved with this balance?
            NSMutableArray *local_reaction_array = [[NSMutableArray alloc] init];
            for (NSUInteger rate_index = 0;rate_index<NUMBER_OF_RATES;rate_index++)
            {
                // What is my stocoeff?
                NSString *stocoeff = [stm_row_array objectAtIndex:rate_index];
                if ([stocoeff isEqualToString:@"0.0"] == NO)
                {
                    NSXMLElement *rate_node = [reaction_array objectAtIndex:rate_index];
                    [local_reaction_array addObject:rate_node];
                    
                    // formulate the entry -
                    
                }
                else
                {
                    // ok, this rate *is *not* involved in this balance. We'll have a zero entry -
                    [buffer appendFormat:@"\tgsl_matrix_set(pBMatrix,%lu,%lu,0.0);\n",outer_index,rate_index];
                }
            }
        }
        
        [buffer appendString:@"\n"];
        [buffer appendString:@"\treturn(GSL_SUCCESS);\n"];
        [buffer appendString:@"}\n"];
    }
    
    
    // return the buffer to the caller -
    return buffer;
}


@end
