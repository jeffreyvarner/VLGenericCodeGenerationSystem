//
//  VLVFFInputHandler.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/5/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLVFFInputHandler.h"

#define INDEX_NAME_STRING 0
#define INDEX_REACTANT_STRING 1
#define INDEX_PRODUCT_STRING 2
#define INDEX_FORWARD_STRING 3
#define INDEX_REVERSE_STRING 4

@implementation VLVFFInputHandler

#pragma mark - override this
-(id)performVLGenericCodeGenerationInputActionWithOptions:(NSDictionary *)options
{
    // Get tree's from dictionary -
    NSXMLDocument *transformation_tree = [options objectForKey:@"TRANSFORMATION_TREE"];
    NSXMLElement *transformation = [options objectForKey:@"TRANSFORMATION_XML_ELEMENT"];
    
    // Lookup global properties -
    NSString *working_directory = [[[transformation_tree nodesForXPath:@".//property[@symbol='WORKING_DIRECTORY']/@value" error:nil] lastObject] stringValue];
    NSString *model_type = [[[transformation_tree nodesForXPath:@"/Model/@type" error:nil] lastObject] stringValue];
    
    
    // What is the file name?
    NSString *file_path_fragment = [[[transformation nodesForXPath:@"./input_handler/transformation_property[@type='PATH']/@value" error:nil] lastObject] stringValue];
    
    // build full path -
    NSString *path_to_vff_file = nil;
    if (working_directory == nil)
    {
        path_to_vff_file = [NSString stringWithFormat:@"%@",file_path_fragment];
    }
    else
    {
        path_to_vff_file = [NSString stringWithFormat:@"%@%@",working_directory,file_path_fragment];
    }
    
    // Loads the VFF as an array of arrays -
    NSArray *vff_components_array = [VLCoreUtilitiesLib loadGenericFlatFile:path_to_vff_file
                                                      withRecordDeliminator:@"\n"
                                                       withFieldDeliminator:@","];
    
    // Create cannonical model tree -
    NSXMLDocument *document = [self convertVFFToCannonicalTree:vff_components_array
                                                  forModelType:model_type];
    
    return document;
}

-(NSXMLDocument *)convertVFFToCannonicalTree:(NSArray *)componentArray forModelType:(NSString *)modelType
{
    // build XML string buffer, create document and return -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // header -
    [buffer appendString:@"<?xml version=\"1.0\" standalone=\"yes\"?>\n"];
    [buffer appendFormat:@"<Model type='%@' source_encoding='VFF'>\n",modelType];
    
    // Compute the species set -
    [buffer appendString:@"\t<listOfSpecies>\n"];
    NSSet *species_set = [self constructListOfSpeciesFromVFFComponents:componentArray forModelType:modelType];
    for (NSString *species_symbol in species_set)
    {
        [buffer appendFormat:@"\t\t<species symbol='%@' initial_amount='0.0'/>\n",species_symbol];
    }
    [buffer appendString:@"\t</listOfSpecies>\n"];
    
    // compute the reaction set -
    [buffer appendString:@"\t<listOfInteractions>\n"];
    NSSet *reaction_set = [self constructListOfReactionsFromVFFComponents:componentArray];
    for (NSString *reaction_block in reaction_set)
    {
        [buffer appendFormat:@"\t\t%@\n",reaction_block];
        NSLog(@"%@",reaction_block);
    }
    
    [buffer appendString:@"\t</listOfInteractions>\n"];
    
    // close -
    [buffer appendString:@"</Model>\n"];
    
    // Build document -
    NSXMLDocument *document = [[NSXMLDocument alloc] initWithXMLString:[NSString stringWithString:buffer]
                                                               options:NSXMLDocumentValidate
                                                                 error:nil];
    return document;
}

-(NSSet *)constructListOfReactionsFromVFFComponents:(NSArray *)componentArray
{
    // reaction set -
    NSMutableSet *reaction_set = [NSMutableSet set];
    
    // ok - go through my array -
    for (NSArray *reaction in componentArray)
    {
        // Buffer -
        NSMutableString *buffer = [[NSMutableString alloc] init];
        
        // Get stuff for this reaction -
        NSString *raw_name_string = [reaction objectAtIndex:INDEX_NAME_STRING];
        NSString *raw_input_string = [reaction objectAtIndex:INDEX_REACTANT_STRING];
        NSString *raw_output_string = [reaction objectAtIndex:INDEX_PRODUCT_STRING];

        // Is this reaction reversible?
        NSString *raw_reverse_string = [reaction objectAtIndex:INDEX_REVERSE_STRING];
        if ([raw_reverse_string isEqualToString:@"inf;"] == YES)
        {
            // reversible - split
            [buffer appendFormat:@"<interaction id='%@::FORWARD'>\n",raw_name_string];
            [buffer appendFormat:@"\t<interaction_input reaction_string='%@'/>\n",raw_input_string];
            [buffer appendFormat:@"\t<interaction_output reaction_string='%@'/>\n",raw_output_string];
            [buffer appendFormat:@"</interaction>\n"];
            
            [buffer appendFormat:@"<interaction id='%@::REVERSE'>\n",raw_name_string];
            [buffer appendFormat:@"\t<interaction_input reaction_string='%@'/>\n",raw_output_string];
            [buffer appendFormat:@"\t<interaction_output reaction_string='%@'/>\n",raw_input_string];
            [buffer appendFormat:@"</interaction>\n"];
        }
        else
        {
            // *not* reversible -
            [buffer appendFormat:@"<interaction id='%@::FORWARD'>\n",raw_name_string];
            [buffer appendFormat:@"\t<interaction_input reaction_string='%@'/>\n",raw_input_string];
            [buffer appendFormat:@"\t<interaction_output reaction_string='%@'/>\n",raw_output_string];
            [buffer appendFormat:@"</interaction>\n"];
        }
        
        [reaction_set addObject:buffer];
    }
    
    // return the set -
    return [NSSet setWithSet:reaction_set];
}


-(NSSet *)constructListOfSpeciesFromVFFComponents:(NSArray *)componentArray
                                     forModelType:(NSString *)modelType
{
    NSMutableArray *species_array = [[NSMutableArray alloc] init];
    NSMutableSet *species_set = [NSMutableSet set];
    
    
    for (NSArray *reaction in componentArray)
    {
        // Cut around the + and *'s
        NSString *raw_reactant_string = [reaction objectAtIndex:INDEX_REACTANT_STRING];
        NSString *raw_product_string = [reaction objectAtIndex:INDEX_PRODUCT_STRING];
        
        // build array -
        [species_array addObjectsFromArray:[raw_product_string componentsSeparatedByString:@"+"]];
        [species_array addObjectsFromArray:[raw_reactant_string componentsSeparatedByString:@"+"]];
        
        // go through the array -
        for (NSString *species in species_array)
        {
            // do we have a stoichiometric coefficient?
            NSRange range = [species rangeOfString:@"*" options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound)
            {
                // ok, so we have a stoichiometric coefficient -
                NSArray *split_components = [species componentsSeparatedByString:@"*"];
                
                // the species symbol will be the *last* object in the array -
                [species_set addObject:[split_components lastObject]];
            }
            else
            {
                // no stoichometric coefficients -
                [species_set addObject:species];
            }
        }
    }
    
    // if we have a CELL_FREE_MODEL - we need to include enzymes -
    if ([modelType isEqualToString:@"CELL_FREE_MODEL"] == YES)
    {
        NSInteger reaction_counter = 1;
        for (NSArray *reaction in componentArray)
        {
            NSString *species_symbol = [NSString stringWithFormat:@"E_%lu",(long)reaction_counter++];
            [species_set addObject:species_symbol];
        }
    }
    
    return [NSSet setWithSet:species_set];
}

@end
