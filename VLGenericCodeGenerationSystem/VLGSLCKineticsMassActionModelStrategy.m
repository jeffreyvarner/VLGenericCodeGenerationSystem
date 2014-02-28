//
//  VLGSLCKineticsMassActionModelStrategy.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/28/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLGSLCKineticsMassActionModelStrategy.h"

#define NEW_LINE [buffer appendString:@"\n"]

@implementation VLGSLCKineticsMassActionModelStrategy

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
    __unused NSXMLElement *transformation = [options objectForKey:kXMLTransformationElement];
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:kXMLModelInputTree];
    
    // What is my model type?
    NSString *model_source_encoding = [[[input_tree nodesForXPath:@"./Model/@source_encoding" error:nil] lastObject] stringValue];
    
    // headers -
    [buffer appendString:@"#include \"Kinetics.h\"\n"];
    [buffer appendString:@"\n"];
    [buffer appendString:@"void Kinetics(double t,double const state_vector[], gsl_vector *pRateVector, void* parameter_object)\n"];
    [buffer appendString:@"{\n"];
    [buffer appendString:@"\t/* initialize -- */\n"];
    [buffer appendString:@"\tdouble rate_value = 0.0;\n"];
    [buffer appendString:@"\tdouble parameter_value = 0.0;\n"];
    [buffer appendString:@"\n"];
    [buffer appendString:@"\t/* Get the parameters from disk - */\n"];
    [buffer appendString:@"\tstruct VLParameters *parameter_struct = (struct VLParameters *)parameter_object;\n"];
    [buffer appendString:@"\tgsl_vector *pV = parameter_struct->pModelKineticsParameterVector;\n"];
    [buffer appendString:@"\tgsl_vector *pVolume = parameter_struct->pModelVolumeVector;\n"];
    [buffer appendString:@"\n"];
    [buffer appendString:@"\t/* Alias elements of the state vector - */\n"];
    
    
    // what encoding do we have?
    if ([model_source_encoding isEqualToString:kSourceEncodingVFF] == YES)
    {
        // ok, we have a VFF encoding, so build the kinetics -
        NSError *xpath_error;
        NSArray *state_vector = [input_tree nodesForXPath:@".//listOfSpecies/species" error:&xpath_error];
        NSInteger state_counter = 0;
        for (NSXMLElement *state in state_vector)
        {
            NSString *state_symbol = [[state attributeForName:@"symbol"] stringValue];
            [buffer appendFormat:@"\tdouble %@ = state_vector[%lu];\n",state_symbol,state_counter++];
        }

        [buffer appendString:@"\n"];
        
        // rates -
        [buffer appendString:@"\t/* Next calculate the rates - */\n"];
        NSArray *reactionArray = [input_tree nodesForXPath:@".//interaction" error:nil];
        NSInteger rate_counter = 0;
        for (NSXMLElement *reaction_node in reactionArray)
        {
            NSString *raw_reactant_string = [[[reaction_node nodesForXPath:@"./interaction_input/@reaction_string" error:nil] lastObject] stringValue];
            
            // split the string around +
            NSMutableArray *local_species_array = [[NSMutableArray alloc] init];
            NSMutableArray *local_order_array = [[NSMutableArray alloc] init];
            [local_species_array addObjectsFromArray:[raw_reactant_string componentsSeparatedByString:@"+"]];
            
            // go through the array -
            for (NSString *species in local_species_array)
            {
                if ([species isEqualToString:@"[]"] == NO)
                {
                    // do we have a stoichiometric coefficient?
                    NSRange range = [species rangeOfString:@"*" options:NSCaseInsensitiveSearch];
                    if (range.location != NSNotFound)
                    {
                        // ok, so we have a stoichiometric coefficient -
                        NSArray *split_components = [species componentsSeparatedByString:@"*"];
                        
                        // the species symbol will be the *last* object in the array -
                        [local_order_array addObject:[split_components lastObject]];
                    }
                    else
                    {
                        // no stoichometric coefficients -
                        [local_order_array addObject:species];
                    }
                }
            }
            
            // ok, build the line -
            //  get string -
            NSString *reactant_string = [[[reaction_node nodesForXPath:@"./interaction_input/@reaction_string" error:nil] lastObject] stringValue];
            NSString *product_string = [[[reaction_node nodesForXPath:@"./interaction_output/@reaction_string" error:nil] lastObject] stringValue];
            
            // comment string -
            NSString *comment_string = [NSString stringWithFormat:@"%@ --> %@",reactant_string,product_string];
            
            [buffer appendFormat:@"\t/* %@ */\n",comment_string];
            [buffer appendFormat:@"\tparameter_value = gsl_vector_get(pV,%lu);\n",rate_counter];
            [buffer appendFormat:@"\trate_value = parameter_value"];
            
            // process the species -
            if ([local_order_array count] == 0)
            {
                // *no* species - zero order - we are done;
                [buffer appendString:@";\n"];
            }
            else
            {
                NSInteger MAX_LOCAL_SPECIES_COUNT = [local_order_array count];
                for (NSInteger local_species_index = 0;local_species_index<MAX_LOCAL_SPECIES_COUNT;local_species_index++)
                {
                    NSString *raw_species_symbol = [local_order_array objectAtIndex:local_species_index];
                    NSString *species_symbol = [raw_species_symbol stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
                    [buffer appendFormat:@"*%@",species_symbol];
                    
                    if (local_species_index == (MAX_LOCAL_SPECIES_COUNT - 1))
                    {
                        [buffer appendString:@";\n"];
                    }
                }
            }
            
            // add to the gsl rate vector -
            [buffer appendString:@"\tgsl_vector_set(pRateVector,"];
            [buffer appendFormat:@"%lu,rate_value);\n",rate_counter];
            NEW_LINE;
            
            // update counter -
            rate_counter++;
        }
        
        [buffer appendString:@"}\n"];
    }
    
    return buffer;
}

@end
