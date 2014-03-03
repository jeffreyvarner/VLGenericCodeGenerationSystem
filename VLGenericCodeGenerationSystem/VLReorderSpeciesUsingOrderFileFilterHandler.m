//
//  VLReorderSpeciesUsingOrderFileFilterHandler.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 3/3/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLReorderSpeciesUsingOrderFileFilterHandler.h"

@implementation VLReorderSpeciesUsingOrderFileFilterHandler


-(id)performVLGenericCodeGenerationFilterActionWithOptions:(NSDictionary *)options
{
    // Get our trees from the dictionary -
    NSXMLDocument *transformation_tree = [options objectForKey:kXMLTransformationTree];
    NSXMLElement *transformation = [options objectForKey:kXMLTransformationElement];
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:kXMLModelInputTree];
    
    // ok, we need to load the order file -
    
    
    
    
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
