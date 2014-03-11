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
    NSString *model_source_encoding = [[[input_tree nodesForXPath:@".//model/@source_encoding" error:nil] lastObject] stringValue];
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
            
            // Which rates am I (outer species) involved in?
            NSMutableArray *local_reaction_array = [[NSMutableArray alloc] init];
            for (NSUInteger rate_index = 0;rate_index<NUMBER_OF_RATES;rate_index++)
            {
                // What is my stocoeff?
                NSString *stocoeff = [stm_row_array objectAtIndex:rate_index];
                if ([stocoeff isEqualToString:@"0.0"] == NO)
                {
                    [local_reaction_array addObject:[NSNumber numberWithInteger:rate_index]];
                }
            }

            for (NSInteger inner_index = 0;inner_index<NUMBER_OF_STATES;inner_index++)
            {
                // what is my linear index?
                NSInteger linear_index = outer_index*NUMBER_OF_STATES + inner_index;
                
                // build the string -
                NSString *entry = [self generateJacobianEntryForSpeciesWithStoichiometricRow:stm_row_array
                                                                            withSpeciesArray:species_array
                                                                           withReactionArray:reaction_array
                                                                      withLocalReactionArray:local_reaction_array
                                                                            withSpeciesIndex:inner_index
                                                                                 withOptions:options];
                if ([entry length] == 0)
                {
                    [buffer appendFormat:@"\tdfdy(%lu) = %@;\n",linear_index,@"0.0"];
                }
                else
                {
                    [buffer appendFormat:@"\tdfdy(%lu) = %@;\n",linear_index,entry];
                }
            }
        }
        
        [buffer appendString:@"\n"];
        [buffer appendString:@"\treturn(GSL_SUCCESS);\n"];
        [buffer appendString:@"}\n"];
    }

    
    // return -
    return buffer;
}

-(NSString *)generateJacobianEntryForSpeciesWithStoichiometricRow:(NSArray *)stoichiometricRow
                                                 withSpeciesArray:(NSArray *)speciesArray
                                                withReactionArray:(NSArray *)reactionArray
                                           withLocalReactionArray:(NSArray *)localReactionArray
                                                 withSpeciesIndex:(NSInteger)speciesIndex
                                                      withOptions:(NSDictionary *)options
{
    // Buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // From my list of reactions, do we have a reaction that involves *both* outer_index and inner_index?
    NSString *inner_species = [[[speciesArray objectAtIndex:speciesIndex] attributeForName:@"id"] stringValue];
    
    // Is the inner species involved in any of my rates?
    for (NSNumber *reaction_index in localReactionArray)
    {
        // get the reaction node
        NSXMLElement *reaction_node = [reactionArray objectAtIndex:[reaction_index integerValue]];
        
        // Is the inner species involved?
        NSString *xpath = [NSString stringWithFormat:@"./listOfReactants/speciesReference[@species='%@']",inner_species];
        NSArray *nodes = [reaction_node nodesForXPath:xpath error:nil];
        if ([nodes count] != 0)
        {
            // ok, we have a winner! The inner species is involved in this reaction -
            NSString *stocoeff = [stoichiometricRow objectAtIndex:[reaction_index integerValue]];
            [buffer appendFormat:@"%@*k_%lu",stocoeff,[reaction_index integerValue]];
            
            // what are the *other* species in this rate?
            NSArray *local_species_array = [reaction_node nodesForXPath:@"./listOfReactants/speciesReference/@species" error:nil];
            for (NSXMLElement *local_species_node in local_species_array)
            {
                NSString *local_species_symbol = [local_species_node stringValue];
                if ([local_species_symbol isEqualToString:inner_species] == NO)
                {
                    [buffer appendFormat:@"*%@",local_species_symbol];
                }
            }
        }
    }
    
    return buffer;
}

@end
