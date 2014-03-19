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
        
        [buffer appendFormat:@"int %@(double t, const double state[], gsl_matrix *pBMatrix, void* parameter_object)\n",tmpFunctionName];
        [buffer appendString:@"{\n"];
        
        // get parameters and setup computation -
        [buffer appendString:@"\t/* initialize -- */\n"];
        [buffer appendString:@"\tdouble matrix_value = 0.0;\n"];
        [buffer appendString:@"\n"];
        [buffer appendString:@"\t/* Get the parameters from disk - */\n"];
        [buffer appendString:@"\tstruct VLParameters *parameter_struct = (struct VLParameters *)parameter_object;\n"];
        [buffer appendString:@"\tgsl_vector *pV = parameter_struct->pModelKineticsParameterVector;\n"];
        [buffer appendString:@"\n"];
        [buffer appendString:@"\t/* Initialize elements of the B-matrix - */\n"];
        [buffer appendString:@"\tgsl_matrix_set_zero(pBMatrix);\n"];
        NEW_LINE;
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
        [buffer appendString:@"\t/* Alias elements of the parameter vector - */\n"];
        for (NSUInteger rate_index = 0;rate_index<NUMBER_OF_RATES;rate_index++)
        {
            [buffer appendFormat:@"\tdouble k_%lu = gsl_vector_get(pV,%lu);\n",rate_index,rate_index];
        }
        [buffer appendString:@"\n"];
        
        // build the stoichiometric matrix array -
        NSArray *stochiometric_array = [VLCoreUtilitiesLib generateStoichiometricMatrixArrayActionWithOptions:options];
        
        // build the jacobian -
        for (NSInteger outer_index = 0;outer_index<NUMBER_OF_STATES;outer_index++)
        {
            // What is my outer index species?
            NSArray *stm_row_array = [stochiometric_array objectAtIndex:outer_index];
            for (NSUInteger reaction_index = 0;reaction_index<NUMBER_OF_RATES;reaction_index++)
            {
                // what is the entry?
                NSString *entry = [self generateBMatrixEntryForSpeciesWithStoichiometricRow:stm_row_array
                                                                          withReactionArray:reaction_array
                                                                          withReactionIndex:reaction_index
                                                                                withOptions:options];
                
                // ok, do we have anything in this entry?
                if ([entry length] != 0)
                {
                    // put a comment line -
                    NSXMLElement *species_node = [state_vector objectAtIndex:outer_index];
                    NSString *state_symbol = [[species_node attributeForName:@"id"] stringValue];
                    [buffer appendFormat:@"\t/* partial(%@)/partial(k_%lu) */\n",state_symbol,reaction_index];
                    [buffer appendFormat:@"\tmatrix_value = %@;\n",entry];
                    [buffer appendFormat:@"\tgsl_matrix_set(pBMatrix,%lu,%lu,matrix_value);\n",outer_index,reaction_index];
                    NEW_LINE;
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

-(NSString *)generateBMatrixEntryForSpeciesWithStoichiometricRow:(NSArray *)stoichiometricRow
                                               withReactionArray:(NSArray *)reactionArray
                                               withReactionIndex:(NSUInteger)reactionIndex
                                                     withOptions:(NSDictionary *)options
{
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // How many rates do we have?
    NSUInteger NUMBER_OF_RATES = [reactionArray count];
    
    // iterate through the rates, figure out which rates are involved in this balance -
    for (NSUInteger local_rate_index = 0;local_rate_index<NUMBER_OF_RATES;local_rate_index++)
    {
        // Is this rate involved in this balance?
        NSString *stcoeff = [stoichiometricRow objectAtIndex:local_rate_index];
        if ([stcoeff isEqualToString:@"0.0"] == NO)
        {
            // ok, this rate *is* involved in this balance
            // is it the reaction index that I'm on?
            if (reactionIndex == local_rate_index)
            {
                // ok, we are looking at this rate -
                [buffer appendFormat:@"%@",stcoeff];
                NSXMLElement *rateNode = [reactionArray objectAtIndex:local_rate_index];
                NSArray *reactantArray = [rateNode nodesForXPath:@"./listOfReactants/speciesReference/@species" error:nil];
                for (NSXMLElement *reactant_node in reactantArray)
                {
                    NSString *species_symbol = [reactant_node stringValue];
                    if ([species_symbol isEqualToString:@"[]"] == NO)
                    {
                        [buffer appendFormat:@"*%@",species_symbol];
                    }
                }
            }
        }
    }
    
    // return -
    return buffer;
}

@end
