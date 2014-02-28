//
//  VLAbstractOutputHandler.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/5/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLAbstractOutputHandler.h"

@implementation VLAbstractOutputHandler


-(id)performVLGenericCodeGenerationOutputActionWithOptions:(NSDictionary *)options
{
    // force the user to overide -
    [self doesNotRecognizeSelector:_cmd];
    return @"bummer_u_need_2_override_me";
}

-(void)writeCodeGenerationOutput:(id)output toFileWithOptions:(NSDictionary *)options
{
    if (options == nil)
    {
        return;
    }
    
    // Get our trees from the dictionary -
    NSXMLDocument *transformation_tree = [options objectForKey:@"TRANSFORMATION_TREE"];
    NSXMLElement *transformation = [options objectForKey:@"TRANSFORMATION_XML_ELEMENT"];
    
    // Lookup global properties -
    NSString *working_directory = [[[transformation_tree nodesForXPath:@".//property[@symbol='WORKING_DIRECTORY']/@value" error:nil] lastObject] stringValue];

    // I should have execute the code_block -
    // dump to disk -
    NSString *output_file_path = [[[transformation nodesForXPath:@"./output_handler/transformation_property[@type='PATH']/@value" error:nil] lastObject] stringValue];
    
    NSString *fullPathString;
    if (working_directory !=nil)
    {
        fullPathString = [NSString stringWithFormat:@"%@%@",working_directory,output_file_path];
    }
    else
    {
        fullPathString = [NSString stringWithFormat:@"%@",output_file_path];
    }
    
    NSURL *fileURL = [NSURL fileURLWithPath:fullPathString];
    [VLCoreUtilitiesLib writeBuffer:output toURL:fileURL];
}

-(void)writeCodeGenerationHeaderFileOutput:(id)output toFileWithOptions:(NSDictionary *)options
{
    if (options == nil)
    {
        return;
    }
    
    // Get our trees from the dictionary -
    NSXMLDocument *transformation_tree = [options objectForKey:@"TRANSFORMATION_TREE"];
    NSXMLElement *transformation = [options objectForKey:@"TRANSFORMATION_XML_ELEMENT"];
    
    // Lookup global properties -
    NSString *working_directory = [[[transformation_tree nodesForXPath:@".//property[@symbol='WORKING_DIRECTORY']/@value" error:nil] lastObject] stringValue];
    
    // I should have execute the code_block -
    // dump to disk -
    NSString *output_file_path = [[[transformation nodesForXPath:@"./output_handler/transformation_property[@type='HEADER_PATH']/@value" error:nil] lastObject] stringValue];
    
    NSString *fullPathString;
    if (working_directory !=nil)
    {
        fullPathString = [NSString stringWithFormat:@"%@%@",working_directory,output_file_path];
    }
    else
    {
        fullPathString = [NSString stringWithFormat:@"%@",output_file_path];
    }
    
    NSURL *fileURL = [NSURL fileURLWithPath:fullPathString];
    [VLCoreUtilitiesLib writeBuffer:output toURL:fileURL];

}


@end
