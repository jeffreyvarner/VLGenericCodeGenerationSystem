//
//  VLSBMLOutputHandler.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/5/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLSBMLOutputHandler.h"

#define NEW_LINE [buffer appendString:@"\n"]

@implementation VLSBMLOutputHandler


-(id)performVLGenericCodeGenerationOutputActionWithOptions:(NSDictionary *)options
{
    
    if (options == nil)
    {
        return nil;
    }
    
    // buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];

    
    // Get our trees from the dictionary -
    __unused NSXMLDocument *transformation_tree = [options objectForKey:kXMLTransformationTree];
    __unused NSXMLElement *transformation = [options objectForKey:kXMLTransformationElement];
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:kXMLModelInputTree];

    // what source encoding do I have?
    NSString *model_source_encoding = [[[input_tree nodesForXPath:@"./Model/@source_encoding" error:nil] lastObject] stringValue];
    
    // What model type do I have?
    NSString *model_type = [[[transformation_tree nodesForXPath:@"/Model/@type" error:nil] lastObject] stringValue];
    
    if ([model_source_encoding isEqualToString:kSourceEncodingVFF] == YES)
    {
        // header -
        [buffer appendString:@"<?xml version=\"1.0\" standalone=\"yes\"?>\n"];
        [buffer appendString:@"<sbml xmlns=\"http://www.sbml.org/sbml/level2\" level=\"2\" version=\"1\">\n"];
        [buffer appendFormat:@"\t<model type='%@' source_encoding='%@'>\n",model_type,model_source_encoding];
        
        // list of compartmemts -
        [buffer appendString:@"\t\t<listOfCompartments>\n"];
        [buffer appendString:@"\t\t\t<compartment id=\"MODEL\"/>\n"];
        [buffer appendString:@"\t\t</listOfCompartments>\n"];
        NEW_LINE;
        
        // list of species -
        [buffer appendString:@"\t\t<listOfSpecies>\n"];
        NSArray *list_of_species = [input_tree nodesForXPath:@".//species" error:nil];
        for (NSXMLElement *species_node in list_of_species)
        {
            // Get the string -
            NSString *species_symbol = [[species_node attributeForName:@"symbol"] stringValue];
            NSString *initial_amount = [[species_node attributeForName:@"initial_amount"] stringValue];
            
            // write the species line -
            [buffer appendFormat:@"\t\t\t<species id='%@' name='%@' compartment='MODEL' initialAmount='%@'/>\n",species_symbol,species_symbol,initial_amount];
        }
        [buffer appendString:@"\t\t</listOfSpecies>\n"];
        NEW_LINE;
        
        // list of reactions -
        [buffer appendString:@"\t\t<listOfReactions>\n"];
        
        // get my list of interactions -
        NSArray *list_of_interactions = [input_tree nodesForXPath:@".//interaction" error:nil];
        for (NSXMLElement *interaction_node in list_of_interactions)
        {
            // Get data -
            NSString *interaction_id = [[interaction_node attributeForName:@"id"] stringValue];
            [buffer appendFormat:@"\t\t\t<reaction id='R_%@' name='%@' reversible='false'>\n",interaction_id,interaction_id];
            [buffer appendString:@"\t\t\t\t<listOfReactants>\n"];
            
            // build species reference -
            
            [buffer appendString:@"\t\t\t\t</listOfReactants>\n"];
            
            [buffer appendString:@"\t\t\t\t<listOfProducts>\n"];
            [buffer appendString:@"\t\t\t\t</listOfProducts>\n"];
            
            // close -
            [buffer appendFormat:@"\t\t\t</reaction>\n"];
        }
        
        [buffer appendString:@"\t\t</listOfReactions>\n"];
        NEW_LINE;
        
        // close -
        [buffer appendFormat:@"\t</model>\n"];
        [buffer appendFormat:@"</sbml>\n"];
        
        // write -
        [self writeCodeGenerationOutput:buffer toFileWithOptions:options];
    }
    else if ([model_source_encoding isEqualToString:kSourceEncodingSBML] == YES)
    {
        // get the tree -
        NSString *local_sbml_tree = [input_tree XMLStringWithOptions:NSXMLNodePrettyPrint];
        
        // write the tree -
        [self writeCodeGenerationOutput:local_sbml_tree toFileWithOptions:options];
    }
    
    // return the code block -
    return nil;
}

#pragma mark - private helper methods

@end
