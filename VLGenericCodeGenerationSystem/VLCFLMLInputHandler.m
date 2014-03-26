//
//  VLCFLMLInputHandler.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 3/25/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLCFLMLInputHandler.h"

@implementation VLCFLMLInputHandler

#pragma mark - override this
-(id)performVLGenericCodeGenerationInputActionWithOptions:(NSDictionary *)options
{
    // Get tree's from dictionary -
    NSXMLDocument *transformation_tree = [options objectForKey:kXMLTransformationTree];
    NSXMLElement *transformation = [options objectForKey:kXMLTransformationElement];
    
    // Lookup global properties -
    NSString *working_directory = [[[transformation_tree nodesForXPath:@".//property[@symbol='WORKING_DIRECTORY']/@value" error:nil] lastObject] stringValue];
    NSString *model_type = [[[transformation_tree nodesForXPath:@"/Model/@type" error:nil] lastObject] stringValue];
    
    // What is the file name?
    NSString *file_path_fragment = [[[transformation nodesForXPath:@"./input_handler/transformation_property[@type='PATH']/@value" error:nil] lastObject] stringValue];
    
    // build full path -
    NSString *path_to_sbml_file = nil;
    if (working_directory == nil)
    {
        path_to_sbml_file = [NSString stringWithFormat:@"%@",file_path_fragment];
    }
    else
    {
        path_to_sbml_file = [NSString stringWithFormat:@"%@%@",working_directory,file_path_fragment];
    }
    
    // load the xml document -
    NSURL *sbml_file_url = [NSURL fileURLWithPath:path_to_sbml_file];
    NSXMLDocument *document = [[NSXMLDocument alloc] initWithContentsOfURL:sbml_file_url options:NSXMLNodePrettyPrint error:nil];
    
    return document;
}

@end
