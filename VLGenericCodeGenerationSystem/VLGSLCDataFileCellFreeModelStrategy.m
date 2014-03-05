//
//  VLGSLCDataFileCellFreeModelStrategy.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 3/5/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLGSLCDataFileCellFreeModelStrategy.h"

@implementation VLGSLCDataFileCellFreeModelStrategy


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
    
    // What is my model encoding?
    NSString *model_source_encoding = [[[input_tree nodesForXPath:@".//model/@source_encoding" error:nil] lastObject] stringValue];
    
    // I need to load the copyright block -
    NSString *copyright_xpath = @".//properties/property[@symbol=\"COPYRIGHT_TEXT\"]/@value";
    NSString *copyright_file_path = [[[transformation_tree nodesForXPath:copyright_xpath error:nil] lastObject] stringValue];
    NSArray *copyright_buffer = [VLCoreUtilitiesLib loadCopyrightFileAtPath:copyright_file_path];
    
    // What is my model type?
    NSString *model_type_xpath = @"./model/@type";
    NSString *typeString = [[[input_tree nodesForXPath:model_type_xpath error:nil] lastObject] stringValue];
    
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

    
    if ([model_source_encoding isEqualToString:kSourceEncodingVFF] == YES)
    {
        // to do ...
    }
    else if ([model_source_encoding isEqualToString:kSourceEncodingSBML] == YES)
    {
        // we have an SBML tree -
        // formulate the parameters list -
        [buffer appendString:@"% Parameters list --\n"];
        [buffer appendString:@"kV = [\n"];
        NSString *parameters_list = [self formulateKineticsParameterListWithSBMLTree:input_tree];
        [buffer appendString:parameters_list];
        [buffer appendString:@"];\n"];
        [buffer appendString:@"\n"];
        
        // Formulate the IC list -
        [buffer appendString:@"% Initial conditions --\n"];
        [buffer appendString:@"IC = [\n"];
        NSString *icList = [self formulateInitialConditionListWithSBMLTree:input_tree];
        [buffer appendString:icList];
        [buffer appendString:@"];\n"];
        [buffer appendString:@"\n"];
        
        // footer -
        [buffer appendString:@"\n"];
        NSString *footer = [self formulateDataFileStructWithSBMLTree:input_tree];
        [buffer appendString:footer];
        [buffer appendString:@"\n"];
        [buffer appendString:@"return;\n"];
    }
 
    // return the buffer -
    return buffer;
}

#pragma mark - private helper methods
-(NSString *)formulateKineticsParameterListWithSBMLTree:(NSXMLDocument *)document
{
    // Initialize initial string -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // start -
    // Get the list of reactions -
    NSArray *reaction_array = [document nodesForXPath:@".//reaction" error:nil];
    NSInteger rate_counter = 0;
    NSInteger parameter_counter = 0;
    for (NSXMLElement *reaction_node in reaction_array)
    {
        float k_value = [VLCoreUtilitiesLib generateRandomFloatingPointNumber];
        
        // comment string -
        NSString *rate_id = [[reaction_node attributeForName:@"id"] stringValue];
        NSString *comment_string = [NSString stringWithFormat:@"%@",rate_id];
        
        // ok, so we have a k_cat for each reaction, *and* a variable number of K -
        [buffer appendFormat:@"\t%f\t;\t\%%\t%lu\tk_%lu\t%@\n",k_value,(long)parameter_counter++,rate_counter,comment_string];
        
        // Get reaction arrays -
        NSArray *reactant_array = [reaction_node nodesForXPath:@"./listOfReactants/speciesReference" error:nil];
        for (NSXMLElement *reactant_node in reactant_array)
        {
            NSString *symbol = [[reactant_node attributeForName:@"species"] stringValue];
            NSRange enzyme_range = [symbol rangeOfString:@"ENZYME_"];
            if (enzyme_range.location == NSNotFound)
            {
                float K_value = 0.1*[VLCoreUtilitiesLib generateRandomFloatingPointNumber];
                [buffer appendFormat:@"\t%f\t;\t\%%\t%lu\tK_%@_%lu\t%@\n",K_value,(long)parameter_counter++,symbol,rate_counter,comment_string];
            }
        }
        
        // update rate_counter -
        rate_counter++;
    }
    
    
    // return -
    return buffer;
}

-(NSString *)formulateInitialConditionListWithSBMLTree:(NSXMLDocument *)document
{
    // Initialize initial string -
    __block NSMutableString *tmpBuffer = [NSMutableString string];
    
    // Ok, get the list of species -
    NSError *err = nil;
    NSString *xpathString = @"//species/@initialAmount";
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
        NSString *tmpXPathSpeciesNames = @"//species/@id";
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

-(NSString *)formulateDataFileStructWithSBMLTree:(NSXMLDocument *)document
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
