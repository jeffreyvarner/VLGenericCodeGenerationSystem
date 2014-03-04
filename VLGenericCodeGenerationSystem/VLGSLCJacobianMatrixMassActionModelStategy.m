//
//  VLGSLCJacobianMatrixMassActionModelStategy.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 3/1/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLGSLCJacobianMatrixMassActionModelStategy.h"

#define NEW_LINE [buffer appendString:@"\n"]

@implementation VLGSLCJacobianMatrixMassActionModelStategy

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
    NSString *model_source_encoding = [[[input_tree nodesForXPath:@"./model/@source_encoding" error:nil] lastObject] stringValue];
    if ([model_source_encoding isEqualToString:kSourceEncodingVFF] == YES)
    {
        // system dimension?
        NSUInteger NUMBER_OF_RATES = [[input_tree nodesForXPath:@".//interaction" error:nil] count];
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
        
        [buffer appendFormat:@"int %@(double t, const double state[], double *dfdy, double dfdt[],void *parameter_object);\n",tmpFunctionName];
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
        
        // ok, we have a VFF encoding, so build the species alias list -
        NSError *xpath_error;
        NSArray *state_vector = [input_tree nodesForXPath:@".//listOfSpecies/species" error:&xpath_error];
        NSMutableArray *local_state_vector = [[NSMutableArray alloc] init];
        NSInteger state_counter = 0;
        for (NSXMLElement *state in state_vector)
        {
            NSString *state_symbol = [[state attributeForName:@"symbol"] stringValue];
            [buffer appendFormat:@"\tdouble %@ = state[%lu];\n",state_symbol,state_counter++];
            
            // grab the state symbol -
            [local_state_vector addObject:state_symbol];
        }
        [buffer appendString:@"\n"];
        
        // build the jacobian -
        for (NSInteger outer_index = 0;outer_index<NUMBER_OF_STATES;outer_index++)
        {
            for (NSInteger inner_index = 0;inner_index<NUMBER_OF_STATES;inner_index++)
            {
                // what is my linear index?
                NSInteger linear_index = outer_index*NUMBER_OF_STATES + inner_index;
                
                //
            }
        }
        
        [buffer appendString:@"\treturn(GSL_SUCCESS);\n"];
        [buffer appendString:@"}\n"];
    }

    
    // return -
    return buffer;
}

@end
