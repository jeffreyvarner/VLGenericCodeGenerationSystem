//
//  VLOctaveMDataFileCellFreeModelStrategy.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/21/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLOctaveMDataFileCellFreeModelStrategy.h"

@implementation VLOctaveMDataFileCellFreeModelStrategy

-(id)executeStrategyWithOptions:(NSDictionary *)options
{
    if (options == nil)
    {
        return nil;
    }
    
    // Buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // Get our trees from the dictionary -
    NSXMLDocument *transformation_tree = [options objectForKey:@"TRANSFORMATION_TREE"];
    NSXMLElement *transformation = [options objectForKey:@"TRANSFORMATION_XML_ELEMENT"];
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:@"INPUT_DATA_TREE"];
    
    // What is my model type?
    NSString *model_type_xpath = @"./Model/@type";
    NSString *typeString = [[[input_tree nodesForXPath:model_type_xpath error:nil] lastObject] stringValue];
    
    // What is my function name?
    NSString *fname_xpath = @"./output_handler/transformation_property[@type=\"FUNCTION_NAME\"]/@value";
    NSString *tmpFunctionName = [[[transformation nodesForXPath:fname_xpath error:nil] lastObject] stringValue];
    
    // start -
    // Populate the buffer --
    [buffer appendFormat:@"function DF = %@(TSTART,TSTOP,Ts,INDEX)\n",tmpFunctionName];
    [buffer appendString:@"% ---------------------------------------------------------------------- %\n"];
    [buffer appendFormat:@"%% %@.m was generated using the UNIVERSAL code generation system.\n",tmpFunctionName];
    [buffer appendString:@"% Username: \n"];
    [buffer appendFormat:@"%% Type: %@ \n",typeString];
    [buffer appendString:@"% \n"];
    [buffer appendString:@"% Arguments: \n"];
    [buffer appendString:@"% TSTART  - Time start \n"];
    [buffer appendString:@"% TSTOP  - Time stop \n"];
    [buffer appendString:@"% Ts - Time step \n"];
    [buffer appendString:@"% INDEX - Parameter set index (for ensemble calculations) \n"];
    [buffer appendString:@"% DF  - Data file instance \n"];
    [buffer appendString:@"% ---------------------------------------------------------------------- %\n"];
    [buffer appendString:@"\n"];
    
    // formulate the parameters list -
    [buffer appendString:@"% Parameters list --\n"];
    [buffer appendString:@"kV = [\n"];
    NSString *parameters_list = [self formulateKineticsParameterListWithTree:input_tree];
    [buffer appendString:parameters_list];
    [buffer appendString:@"];\n"];
    [buffer appendString:@"\n"];
    
    // Formulate the IC list -
    [buffer appendString:@"% Initial conditions --\n"];
    [buffer appendString:@"IC = [\n"];
    NSString *icList = [self formulateInitialConditionListWithTree:input_tree];
    [buffer appendString:icList];
    [buffer appendString:@"];\n"];
    [buffer appendString:@"\n"];
    
    // footer -
    [buffer appendString:@"\n"];
    NSString *footer = [self formulateDataFileStructWithTree:input_tree];
    [buffer appendString:footer];
    [buffer appendString:@"\n"];
    [buffer appendString:@"return;\n"];
    
    // force the user to overide -
    return [NSString stringWithString:buffer];
}

#pragma mark - private helper methods
-(NSString *)formulateKineticsParameterListWithTree:(NSXMLDocument *)document
{
    // Initialize initial string -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // start -
    
    
    // What type of model is this?
    NSString *model_type = [[[document nodesForXPath:@"./Model/@type" error:nil] lastObject] stringValue];
    NSString *model_source_encoding = [[[document nodesForXPath:@"./Model/@source_encoding" error:nil] lastObject] stringValue];
    
    // depending upon the type of model *and* the source encoding, we execute different logic
    if ([model_type isEqualToString:@"CELL_FREE_MODEL"] == YES)
    {
        if ([model_source_encoding isEqualToString:@"VFF"] == YES)
        {
            // ok - we have a cell free model coming from a VFF file.
            // need multiple saturation kinetics
            NSArray *reaction_array = [document nodesForXPath:@".//interaction" error:nil];
            NSInteger reaction_counter = 1;
            NSInteger parameter_counter = 1;
            for (NSXMLElement *reaction_node in reaction_array)
            {
                // What is the reaction name?
                NSString *reaction_name_string = [[reaction_node attributeForName:@"id"] stringValue];
                
                // comment string -
                NSString *comment_string = [NSString stringWithFormat:@"\t \%% Reaction: %lu %@ -- \n",(long)reaction_counter,reaction_name_string];
                
                // add to the buffer -
                [buffer appendString:comment_string];
                
                // ok, so we have a k_cat for each reaction, *and* a variable number of K -
                [buffer appendFormat:@"\t 1.0\t;\t \%%  %lu k_%lu_cat\n",(long)parameter_counter++,reaction_counter];
                
                // What is my *reactant* string -
                NSString *raw_reactant_string = [[[reaction_node nodesForXPath:@"./interaction_input/@reaction_string" error:nil] lastObject] stringValue];
                NSMutableArray *local_species_array = [[NSMutableArray alloc] init];
                NSMutableArray *local_order_array = [[NSMutableArray alloc] init];
                [local_species_array addObjectsFromArray:[raw_reactant_string componentsSeparatedByString:@"+"]];
                
                // go through the array -
                for (NSString *species in local_species_array)
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
                
                // ok, so we have the local species order for this reaction
                for (NSString *species_symbol in local_order_array)
                {
                    [buffer appendFormat:@"\t 0.1\t;\t \%%  %lu K_%lu_%@\n",(long)parameter_counter++,reaction_counter,species_symbol];
                }
                
                [buffer appendString:@"\n"];
                
                // update the reaction counter (1 based becuase we in octave/,atlab)
                reaction_counter++;
            }
            
            // ok, so we need to process the *enzymes* -
            NSString *enzyme_comment_string = @"\t \%% Enzyme degradation constants -- \n";
            [buffer appendString:enzyme_comment_string];
            NSArray *enzyme_array = [document nodesForXPath:@".//species[starts-with(@symbol, 'E_')]" error:nil];
            NSInteger enzyme_counter = 1;
            for (NSXMLElement *enzyme_node in enzyme_array)
            {
                [buffer appendFormat:@"\t 0.01\t;\t \%%  %lu kd_E_%lu\n",(long)parameter_counter++,enzyme_counter];
                enzyme_counter++;
            }
        }
        else
        {
            
        }
    }
    
    // return -
    return buffer;
}

-(NSString *)formulateInitialConditionListWithTree:(NSXMLDocument *)document
{
    // Initialize initial string -
    __block NSMutableString *tmpBuffer = [NSMutableString string];
    
    // Ok, get the list of species -
    NSError *err = nil;
    NSString *xpathString = @"//species/@initial_amount";
    NSArray *listOfICValues = [document nodesForXPath:xpathString error:&err];
    
    // check -
    if (err!=nil)
    {
        // Ok, we have an error -
        NSLog(@"ERROR %@",[err description]);
    }
    else
    {
        // Ok, if we get here, we need to get the name list and then formulate IC list -
        NSString *tmpXPathSpeciesNames = @"//species/@symbol";
        NSArray *listOfNames= [document nodesForXPath:tmpXPathSpeciesNames error:&err];
        
        // Put the values -
        [listOfICValues enumerateObjectsUsingBlock:^(NSXMLElement *xmlElement,NSUInteger index,BOOL *stop){
            
            // Get the name -
            NSXMLElement *tmpNameElement = [listOfNames objectAtIndex:index];
            
            // Get the string -
            NSString *value = [xmlElement stringValue];
            NSString *name = [tmpNameElement stringValue];
            
            // Add the row -
            [tmpBuffer appendFormat:@"\t%@\t;\t%%\t%lu\t%@\n",value,(index+1),name];
        }];
        
    }
    
    // return -
    return tmpBuffer;
}

-(NSString *)formulateDataFileStructWithTree:(NSXMLDocument *)document
{
    // Initialize initial string -
    NSMutableString *tmpBuffer = [NSMutableString string];
    
    [tmpBuffer appendString:@"% Initialize the measurement selection matrix. Default is *all* the states -- \n"];
    [tmpBuffer appendString:@"MEASUREMENT_INDEX_VECTOR = [1:NSTATES];\n"];
    [tmpBuffer appendString:@"\n"];
    
    [tmpBuffer appendString:@"% =========== DO NOT EDIT BELOW THIS LINE ========================== %\n"];
    [tmpBuffer appendString:@"DF.INITIAL_CONDITION_VECTOR       =   IC;\n"];
    [tmpBuffer appendString:@"DF.PARAMETER_VECTOR               =   kV;\n"];
    [tmpBuffer appendString:@"DF.MEASUREMENT_SELECTION_VECTOR   = MEASUREMENT_INDEX_VECTOR;\n"];
    [tmpBuffer appendString:@"DF.NUMBER_PARAMETERS              =   NPARAMETERS;\n"];
    [tmpBuffer appendString:@"DF.NUMBER_OF_STATES               =   NSTATES;\n"];
    [tmpBuffer appendString:@"DF.NUMBER_OF_RATES                =   NRATES;\n"];
    [tmpBuffer appendString:@"% ================================================================== %\n"];
    
    // return -
    return tmpBuffer;
}


@end
