//
//  VLSBMLOutputHandler.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/5/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLSBMLOutputHandler.h"

@implementation VLSBMLOutputHandler


-(id)performVLGenericCodeGenerationOutputActionWithOptions:(NSDictionary *)options
{
    
    if (options == nil)
    {
        return nil;
    }
    
    // Get our trees from the dictionary -
    __unused NSXMLDocument *transformation_tree = [options objectForKey:@"TRANSFORMATION_TREE"];
    __unused NSXMLElement *transformation = [options objectForKey:@"TRANSFORMATION_XML_ELEMENT"];
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:@"INPUT_DATA_TREE"];

    // dump to disk for debugging -
    NSString *code_block = [input_tree XMLStringWithOptions:NSXMLDocumentTidyXML];
    
    // write -
    [self writeCodeGenerationOutput:code_block toFileWithOptions:options];
    
    // return the code block -
    return code_block;
}


@end
