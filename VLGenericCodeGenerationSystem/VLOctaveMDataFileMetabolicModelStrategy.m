//
//  VLOctaveMDataFileMetabolicModelStrategy.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 4/8/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLOctaveMDataFileMetabolicModelStrategy.h"

@implementation VLOctaveMDataFileMetabolicModelStrategy

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
    
    // What is my extracellular compartment?
    NSString *extracellular_xpath = @"./output_handler/transformation_property[@type=\"UNBALANCED_SPECIES_COMPARTMENT_SYMBOL\"]/@value";
    NSString *extracellular_compartment_symbol = [[[transformation nodesForXPath:extracellular_xpath error:nil] lastObject] stringValue];
    
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
    [buffer appendString:@"% Get the dimension of the system -\n"];
    [buffer appendString:@"[NR,NCO]=size(STM);\n"];
    [buffer appendString:@"\n"];
    
    // generate the kinetics -
    if ([model_source_encoding isEqualToString:kSourceEncodingSBML] == YES)
    {
        NSMutableArray *local_species_array = [[NSMutableArray alloc] init];
        
        [buffer appendString:@"% Free metabolites - \n"];
        [buffer appendString:@"IDX_FREE_METABOLITES = [\n"];
        
        // Get list of species -
        NSUInteger species_index = 1;
        NSArray *species_array = [input_tree nodesForXPath:@".//listOfSpecies/species" error:nil];
        for (NSXMLElement *species_node in species_array)
        {
            // what comparment is this?
            NSString *local_compartment = [[species_node attributeForName:@"compartment"] stringValue];
            if ([local_compartment isEqualToString:extracellular_compartment_symbol] == YES)
            {
                // grab the species node for later -
                [local_species_array addObject:species_node];
                
                // Get species id -
                NSString *species_id = [[species_node attributeForName:@"id"] stringValue];
                
                // ok, we have the *correct* compartment -
                [buffer appendFormat:@"\t%lu\t;\t%%\t%@\n",species_index,species_id];
            }
            
            // update my species counter and go around again -
            species_index++;
        }
        
        [buffer appendString:@"];\n"];
        [buffer appendString:@"\n"];
        [buffer appendString:@"IDX_BALANCED_METABOLITES = setdiff(1:NR,IDX_FREE_METABOLITES);\n"];
        [buffer appendString:@"N_IDX_BALANCED_METABOLITES = length(IDX_BALANCED_METABOLITES);\n"];
        [buffer appendString:@"\n"];
        
        // Setup the constraints -
        species_index = 1;
        [buffer appendString:@"% Setup bounds on species -\n"];
        [buffer appendString:@"BASE_BOUND = 10;\n"];
        [buffer appendString:@"SPECIES_BOUND = [\n"];
        for (NSXMLElement *species_node in species_array)
        {
            // what comparment is this?
            NSString *local_compartment = [[species_node attributeForName:@"compartment"] stringValue];
            if ([local_compartment isEqualToString:extracellular_compartment_symbol] == YES)
            {
                // Get species id -
                NSString *species_id = [[species_node attributeForName:@"id"] stringValue];
                
                // ok, we have the *correct* compartment -
                [buffer appendFormat:@"\t%lu\t0\tBASE_BOUND\t;\t%%\t%@\n",species_index,species_id];
            }
            
            // update my species counter and go around again -
            species_index++;
        }
        
        [buffer appendString:@"];\n"];
        [buffer appendString:@"\n"];
    }
    
    [buffer appendString:@"% Split the stochiometrix matrix - \n"];
    [buffer appendString:@"S	=	STM(IDX_BALANCED_METABOLITES,:);\n"];
    [buffer appendString:@"SDB	=	STM(SPECIES_BOUND(:,1),:);\n"];
    [buffer appendString:@"\n"];
    [buffer appendString:@"% === DO NOT EDIT BELOW THIS LINE ===================== %\n"];
    [buffer appendString:@"DF.STOICHIOMETRIC_MATRIX = STM;\n"];
    [buffer appendString:@"DF.SPECIES_BOUND_ARRAY=SPECIES_BOUND;\n"];
    [buffer appendString:@"DF.FLUX_BOUNDS = FB;\n"];
    [buffer appendString:@"DF.BALANCED_MATRIX = S;\n"];
    [buffer appendString:@"DF.SPECIES_CONSTRAINTS=SDB;\n"];
    [buffer appendString:@"% ===================================================== %\n"];
    
    // return -
    return buffer;
}


@end
