//
//  VLAlphabeticalSpeciesFilterHandler.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/27/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLAlphabeticalSpeciesFilterHandler.h"

@implementation VLAlphabeticalSpeciesFilterHandler


-(id)performVLGenericCodeGenerationFilterActionWithOptions:(NSDictionary *)options
{
    // Get our trees from the dictionary -
    __unused NSXMLDocument *transformation_tree = [options objectForKey:@"TRANSFORMATION_TREE"];
    __unused NSXMLElement *transformation = [options objectForKey:@"TRANSFORMATION_XML_ELEMENT"];
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:@"INPUT_DATA_TREE"];
    
    
    // Need to redo the tree -
    // Get all the species nodes -
    NSArray *species_node_array = [input_tree nodesForXPath:@".//species" error:nil];
    
    // my comparison block -
    NSComparisonResult (^MyComparisonBlock)(NSXMLElement*, NSXMLElement*) = ^(NSXMLElement *obj1, NSXMLElement *obj2){
        
        // Get the symbol strings -
        NSString *symbol_species_1 = [[obj1 attributeForName:@"symbol"] stringValue];
        NSString *symbol_species_2 = [[obj2 attributeForName:@"symbol"] stringValue];
        
        return [symbol_species_1 compare:symbol_species_2];
    };
    
    // Sort -
    NSArray *sorted_species_nodes = [species_node_array sortedArrayUsingComparator:MyComparisonBlock];
    
    // remove all the species nodes -
    for (NSXMLElement *species_node in sorted_species_nodes)
    {
        [species_node detach];
    }
    
    // add the nodes back -
    NSXMLElement *list_of_species = [[input_tree nodesForXPath:@"/Model/listOfSpecies" error:nil] lastObject];
    for (NSXMLElement *species_node in sorted_species_nodes)
    {
        [list_of_species addChild:species_node];
    }
    
    return input_tree;
}


@end
