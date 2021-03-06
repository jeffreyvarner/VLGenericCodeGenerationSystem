//
//  VLOctaveMDataFileMassActionModelStrategy.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/25/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLOctaveMDataFileMassActionModelStrategy.h"

@implementation VLOctaveMDataFileMassActionModelStrategy

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
    
    // I need to load the copyright block -
    NSString *copyright_xpath = @".//properties/property[@symbol=\"COPYRIGHT_TEXT\"]/@value";
    NSString *copyright_file_path = [[[transformation_tree nodesForXPath:copyright_xpath error:nil] lastObject] stringValue];
    NSArray *copyright_buffer = [VLCoreUtilitiesLib loadCopyrightFileAtPath:copyright_file_path];
    
    // What is my model type?
    NSString *model_type_xpath = @".//model/@type";
    NSString *typeString = [[[input_tree nodesForXPath:model_type_xpath error:nil] lastObject] stringValue];
    
    // What is my function name?
    NSString *fname_xpath = @"./output_handler/transformation_property[@type=\"FUNCTION_NAME\"]/@value";
    NSString *tmpFunctionName = [[[transformation nodesForXPath:fname_xpath error:nil] lastObject] stringValue];
    
    // start -
    // add the copyright statement -
    [self addCopyrightStatement:copyright_buffer toBuffer:buffer];
    
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
    
    // load the stoichiometric matrix -
    [buffer appendString:@"% Stoichiometric matrix --\n"];
    [buffer appendString:@"STM = load('../network/Network.dat');\n"];
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
    NSString *model_source_encoding = [[[document nodesForXPath:@".//model/@source_encoding" error:nil] lastObject] stringValue];
    
    // depending upon the type of model *and* the source encoding, we execute different logic
    if ([model_source_encoding isEqualToString:kSourceEncodingVFF] == YES)
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
            
            // Depending upon FORWARD -or- RERVESE 
            NSRange contains_forward_range = [reaction_name_string rangeOfString:@"FORWARD"];
            NSRange contains_reverse_range = [reaction_name_string rangeOfString:@"REVERSE"];
            NSRange contains_gen_range = [reaction_name_string rangeOfString:@"GEN"];
            
            float value = 0.0f;
            if (contains_forward_range.location == NSNotFound &&
                contains_reverse_range.location == NSNotFound)
            {
                value = [VLCoreUtilitiesLib generateRandomFloatingPointNumber];
            }
            else if (contains_reverse_range.location != NSNotFound &&
                     contains_forward_range.location == NSNotFound)
            {
                // reverse value -
                value = [VLCoreUtilitiesLib generateRandomFloatingPointNumber];
            }
            else if (contains_reverse_range.location == NSNotFound &&
                     contains_forward_range.location != NSNotFound)
            {
                if (contains_gen_range.location == NSNotFound)
                {
                    // reverse value -
                    value = 10*[VLCoreUtilitiesLib generateRandomFloatingPointNumber];
                }
                else
                {
                    value = 0.0f;
                }
            }

            
            //  get string -
            NSString *reactant_string = [[[reaction_node nodesForXPath:@"./interaction_input/@reaction_string" error:nil] lastObject] stringValue];
            NSString *product_string = [[[reaction_node nodesForXPath:@"./interaction_output/@reaction_string" error:nil] lastObject] stringValue];
            
            // comment string -
            NSString *comment_string = [NSString stringWithFormat:@"%@ --> %@",reactant_string,product_string];
            
            // ok, so we have a k_cat for each reaction, *and* a variable number of K -
            [buffer appendFormat:@"\t %f\t;\t \%%  %lu k_%lu %@\n",value,(long)parameter_counter++,reaction_counter,comment_string];
            
            // update the reaction counter (1 based becuase we in octave/,atlab)
            reaction_counter++;
        }
    }
    else if ([model_source_encoding isEqualToString:kSourceEncodingSBML] == YES)
    {
        // ok - we have a cell free model coming from a VFF file.
        // need multiple saturation kinetics
        NSArray *reaction_array = [document nodesForXPath:@".//reaction" error:nil];
        NSInteger reaction_counter = 1;
        NSInteger parameter_counter = 1;
        for (NSXMLElement *reaction_node in reaction_array)
        {
            // What is the reaction name?
            NSString *reaction_name_string = [[reaction_node attributeForName:@"name"] stringValue];
            NSString *reaction_id_string = [[reaction_node attributeForName:@"id"] stringValue];
            
            // Depending upon FORWARD -or- RERVESE
            NSRange contains_forward_range = [reaction_name_string rangeOfString:@"FORWARD"];
            NSRange contains_reverse_range = [reaction_name_string rangeOfString:@"REVERSE"];
            NSRange contains_gen_range = [reaction_name_string rangeOfString:@"GEN"];
            
            float value = 0.0f;
            if (contains_forward_range.location == NSNotFound &&
                contains_reverse_range.location == NSNotFound)
            {
                value = [VLCoreUtilitiesLib generateRandomFloatingPointNumber];
            }
            else if (contains_reverse_range.location != NSNotFound &&
                     contains_forward_range.location == NSNotFound)
            {
                // reverse value -
                value = [VLCoreUtilitiesLib generateRandomFloatingPointNumber];
            }
            else if (contains_reverse_range.location == NSNotFound &&
                     contains_forward_range.location != NSNotFound)
            {
                if (contains_gen_range.location == NSNotFound)
                {
                    // reverse value -
                    value = 10*[VLCoreUtilitiesLib generateRandomFloatingPointNumber];
                }
                else
                {
                    value = 0.0f;
                }
            }
            
        
            // comment string -
            NSString *comment_string = [NSString stringWithFormat:@"id: %@  name: %@",reaction_id_string,reaction_name_string];
            
            // ok, so we have a k_cat for each reaction, *and* a variable number of K -
            [buffer appendFormat:@"\t %f\t;\t \%%  %lu k_%lu %@\n",value,(long)parameter_counter++,reaction_counter,comment_string];
            
            // update the reaction counter (1 based becuase we in octave/matlab)
            reaction_counter++;
        }
    }

    // return -
    return buffer;
}

-(NSString *)formulateInitialConditionListWithTree:(NSXMLDocument *)document
{
    // Initialize initial string -
    __block NSMutableString *tmpBuffer = [NSMutableString string];
    
    // What type of model is this?
    NSString *model_source_encoding = [[[document nodesForXPath:@".//model/@source_encoding" error:nil] lastObject] stringValue];
    if ([model_source_encoding isEqualToString:kSourceEncodingVFF] == YES)
    {
        // Ok, get the list of species -
        NSError *err = nil;
        NSString *xpathString = @".//species/@initial_amount";
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
    }
    else if ([model_source_encoding isEqualToString:kSourceEncodingSBML] == YES)
    {
        NSArray *species_array = [document nodesForXPath:@".//species" error:nil];
        NSInteger species_counter = 1;
        for (NSXMLElement *species_node in species_array)
        {
            // What is the symbol -or- id?
            NSString *species_id = [[species_node attributeForName:@"id"] stringValue];
            NSString *initial_amount = [[species_node attributeForName:@"initialAmount"] stringValue];
            
            // Add the row -
            [tmpBuffer appendFormat:@"\t%@\t;\t%%\t%lu\t%@\n",initial_amount,species_counter,species_id];
            species_counter++;
        }
    }
    
    // return -
    return tmpBuffer;
}

-(NSString *)formulateDataFileStructWithTree:(NSXMLDocument *)document
{
    // Initialize initial string -
    NSMutableString *tmpBuffer = [NSMutableString string];
    
    [tmpBuffer appendString:@"% Initialize the measurement selection matrix. Default is *all* the states -- \n"];
    [tmpBuffer appendString:@"% Get the system dimension - \n"];
    [tmpBuffer appendString:@"NRATES = length(kV);\n"];
    [tmpBuffer appendString:@"NSTATES = length(IC);\n"];
    [tmpBuffer appendString:@"NPARAMETERS = length(kV);\n"];
    [tmpBuffer appendString:@"\n"];
    [tmpBuffer appendString:@"MEASUREMENT_INDEX_VECTOR = [1:NSTATES];\n"];
    [tmpBuffer appendString:@"\n"];
    
    [tmpBuffer appendString:@"% =========== DO NOT EDIT BELOW THIS LINE ========================== %\n"];
    [tmpBuffer appendString:@"DF.STOICHIOMETRIC_MATRIX          =   STM;\n"];
    [tmpBuffer appendString:@"DF.INITIAL_CONDITION_VECTOR       =   IC;\n"];
    [tmpBuffer appendString:@"DF.PARAMETER_VECTOR               =   kV;\n"];
    [tmpBuffer appendString:@"DF.MEASUREMENT_SELECTION_VECTOR   =   MEASUREMENT_INDEX_VECTOR;\n"];
    [tmpBuffer appendString:@"DF.NUMBER_PARAMETERS              =   NPARAMETERS;\n"];
    [tmpBuffer appendString:@"DF.NUMBER_OF_STATES               =   NSTATES;\n"];
    [tmpBuffer appendString:@"DF.NUMBER_OF_RATES                =   NRATES;\n"];
    [tmpBuffer appendString:@"% ================================================================== %\n"];
    
    // return -
    return tmpBuffer;
}

#pragma mark - override the copyright statement
-(void)addCopyrightStatement:(NSArray *)statement toBuffer:(NSMutableString *)buffer
{
    // first line -
    [buffer appendString:@"% ------------------------------------------------------------------------------------ %\n"];
    
    for (NSString *line in statement)
    {
        [buffer appendFormat:@"\%% %@ \n",line];
    }
    
    // close -
    [buffer appendString:@"% ------------------------------------------------------------------------------------ %\n"];
}

@end
