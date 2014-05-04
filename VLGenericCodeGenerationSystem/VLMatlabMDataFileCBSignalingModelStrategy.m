//
//  VLMatlabMDataFileCBSignalingModelStrategy.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 4/28/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLMatlabMDataFileCBSignalingModelStrategy.h"

#define NEW_LINE [buffer appendString:@"\n"]

@implementation VLMatlabMDataFileCBSignalingModelStrategy

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
    
    // I need to load the copyright block -
    NSString *copyright_xpath = @".//properties/property[@symbol=\"COPYRIGHT_TEXT\"]/@value";
    NSString *copyright_file_path = [[[transformation_tree nodesForXPath:copyright_xpath error:nil] lastObject] stringValue];
    NSArray *copyright_buffer = [VLCoreUtilitiesLib loadCopyrightFileAtPath:copyright_file_path];
    
    // What is my model type?
    NSString *model_source_encoding = [[[input_tree nodesForXPath:@".//model/@source_encoding" error:nil] lastObject] stringValue];
    
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
    [buffer appendString:@"STM = load('Network.dat');\n"];
    [buffer appendString:@"\n"];
    [buffer appendString:@"% Load the FB - \n"];
    [buffer appendString:@"FB = load('FB.dat');\n"];
    [buffer appendString:@"\n"];
    [buffer appendString:@"% Get the dimension of the system -\n"];
    [buffer appendString:@"[NSTATES,NRATES]=size(STM);\n"];
    [buffer appendString:@"\n"];
    NEW_LINE;
    
    if ([model_source_encoding isEqualToString:kSourceEncodingNLVFF] == YES)
    {
        // ok - we need ICs -
        [buffer appendString:@"% Initial conditions --\n"];
        [buffer appendString:@"IC = [\n"];
        
        // what are my species?
        NSUInteger species_counter = 1;
        NSArray *species_array = [input_tree nodesForXPath:@".//species" error:nil];
        for (NSXMLElement *species_node in species_array)
        {
            // What is the id?
            NSString *species_symbol = [[species_node attributeForName:@"id"] stringValue];
            NSString *initial_amount = [[species_node attributeForName:@"initialAmount"] stringValue];
            [buffer appendFormat:@"\t%@\t;\t%% %lu\t%@\n",initial_amount,species_counter,species_symbol];
            species_counter++;
        }
        
        [buffer appendString:@"];\n"];
        NEW_LINE;
        [buffer appendString:@"% Lower bound gain --\n"];
        [buffer appendString:@"ALPHA = [\n"];
        NSArray *reaction_array = [input_tree nodesForXPath:@".//reaction" error:nil];
        NSUInteger reaction_counter = 1;
        for (NSXMLElement *reaction_node in reaction_array)
        {
            NSMutableString *comment_buffer = [[NSMutableString alloc] init];
            [comment_buffer appendString:@"("];
            NSArray *reactant_array = [reaction_node nodesForXPath:@"./listOfReactants/speciesReference" error:nil];
            for (NSXMLElement *reactant_node in reactant_array)
            {
                NSString *species_symbol = [[reactant_node attributeForName:@"species"] stringValue];
                [comment_buffer appendFormat:@"%@ ",species_symbol];
            }
            
            [comment_buffer appendString:@") --> ("];
            NSArray *product_array = [reaction_node nodesForXPath:@"./listOfProducts/speciesReference" error:nil];
            for (NSXMLElement *product_node in product_array)
            {
                NSString *species_symbol = [[product_node attributeForName:@"species"] stringValue];
                [comment_buffer appendFormat:@"%@ ",species_symbol];
            }

            [comment_buffer appendString:@")"];
            
            NSString *name = [[reaction_node attributeForName:@"name"] stringValue];
            [buffer appendFormat:@"\t0.0\t;\t%% R_%lu\t%@\t%@\n",reaction_counter,name,comment_buffer];
            
            // update counter -
            reaction_counter++;
        }
        [buffer appendString:@"];\n"];

        NEW_LINE;
        [buffer appendString:@"% Upper bound gain --\n"];
        [buffer appendString:@"BETA = [\n"];
        reaction_counter = 1;
        for (NSXMLElement *reaction_node in reaction_array)
        {
            NSMutableString *comment_buffer = [[NSMutableString alloc] init];
            [comment_buffer appendString:@"("];
            NSArray *reactant_array = [reaction_node nodesForXPath:@"./listOfReactants/speciesReference" error:nil];
            for (NSXMLElement *reactant_node in reactant_array)
            {
                NSString *species_symbol = [[reactant_node attributeForName:@"species"] stringValue];
                [comment_buffer appendFormat:@"%@ ",species_symbol];
            }
            
            [comment_buffer appendString:@") --> ("];
            NSArray *product_array = [reaction_node nodesForXPath:@"./listOfProducts/speciesReference" error:nil];
            for (NSXMLElement *product_node in product_array)
            {
                NSString *species_symbol = [[product_node attributeForName:@"species"] stringValue];
                [comment_buffer appendFormat:@"%@ ",species_symbol];
            }
            
            [comment_buffer appendString:@")"];
            
            NSString *name = [[reaction_node attributeForName:@"name"] stringValue];
            [buffer appendFormat:@"\t100.0\t;\t%% R_%lu\t%@\t%@\n",reaction_counter,name,comment_buffer];
            
            // update counter -
            reaction_counter++;
        }
        [buffer appendString:@"];\n"];
        NEW_LINE;
        [buffer appendString:@"% Parameters in the bounds functions --\n"];
        [buffer appendString:@"kV = [\n"];
        for (NSXMLElement *reaction_node in reaction_array)
        {
            // What are the reactants?
            NSArray *reactant_array = [reaction_node nodesForXPath:@"./listOfReactants/speciesReference" error:nil];
            for (NSXMLElement *reactant_node in reactant_array)
            {
                NSString *species_symbol = [[reactant_node attributeForName:@"species"] stringValue];
                if ([species_symbol isEqualToString:@"[]"] == NO)
                {
                    // hill-coefficients -
                    [buffer appendString:@"\t1.0 1.0\t;\t% Hill-coefficients \n"];
                    
                    // saturation coefficients -
                    if ([species_symbol isEqualToString:@"RNAP"] == YES ||
                        [species_symbol isEqualToString:@"RIBOSOME"] == YES)
                    {
                        [buffer appendString:@"\t10.0 10.0\t;\t% Saturation \n"];
                    }
                    else
                    {
                        [buffer appendString:@"\t1.0 1.0\t;\t% Saturation \n"];
                    }
                }
            }
        }
        [buffer appendString:@"];\n"];
        
        // bottom footer -
        NEW_LINE;
        NSString *footer = [self formulateDataFileStructWithTree:input_tree];
        [buffer appendString:footer];
        [buffer appendString:@"return;\n"];
    }
    
    return buffer;
}

-(NSString *)formulateDataFileStructWithTree:(NSXMLDocument *)document
{
    // Initialize initial string -
    NSMutableString *tmpBuffer = [NSMutableString string];
    
    
    [tmpBuffer appendString:@"% =========== DO NOT EDIT BELOW THIS LINE ========================== %\n"];
    [tmpBuffer appendString:@"DF.INITIAL_CONDITION_VECTOR       =   IC;\n"];
    [tmpBuffer appendString:@"DF.STOICHIOMETRIC_MATRIX          =   STM;\n"];
    [tmpBuffer appendString:@"DF.FLUX_BOUNDS                    =   FB;\n"];
    [tmpBuffer appendString:@"DF.GAIN_LOWER_BOUND               =   ALPHA;\n"];
    [tmpBuffer appendString:@"DF.GAIN_UPPER_BOUND               =   BETA;\n"];
    [tmpBuffer appendString:@"DF.PARAMETERS_BOUNDS              =   kV;\n"];
    [tmpBuffer appendString:@"DF.NUMBER_OF_STATES               =   NSTATES;\n"];
    [tmpBuffer appendString:@"DF.NUMBER_OF_RATES                =   NRATES;\n"];
    [tmpBuffer appendString:@"% ================================================================== %\n"];
    
    // return -
    return tmpBuffer;
}


@end
