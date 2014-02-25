//
//  main.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/4/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import <Foundation/Foundation.h>

// code generation classes -
#import "VLCoreUtilitiesLib.h"
#import "VLGenericCodeGenerationService.h"
#import "VLGenericCodeGenerationStrategyFactory.h"

// define -
#define INDEX_TRANSFORMATION_FILE 0
#define INDEX_MAPPING_FILE 1

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        
        // collect the args -
        NSMutableArray *argsArray = [[NSMutableArray alloc] initWithCapacity:argc];
        
        // Loop through and process the input arguments -
        for (int arg_index = 0;arg_index<argc;arg_index++)
        {
            if (arg_index>0)
            {
                // Grab the function name, convert const char * into NSString and then put into the array -
                NSString *tmpString = [NSString stringWithCString:argv[arg_index]
                                                         encoding:[NSString defaultCStringEncoding]];
                
                // Put into function -
                [argsArray addObject:tmpString];
            }
        }
        
        // Get the input path to the transformation file -
        NSString *path_to_tree_file = [argsArray objectAtIndex:INDEX_TRANSFORMATION_FILE];
        NSXMLDocument *xml_transformation_tree = [VLCoreUtilitiesLib createXMLDocumentFromFile:[NSURL fileURLWithPath:path_to_tree_file]];
        
        // Get the mapping file -
        NSString *path_to_mapping_file = [argsArray objectAtIndex:INDEX_MAPPING_FILE];
        NSXMLDocument *xml_mapping_tree = [VLCoreUtilitiesLib createXMLDocumentFromFile:[NSURL fileURLWithPath:path_to_mapping_file]];

        // Build the strategy factory -
        VLGenericCodeGenerationStrategyFactory *strategy_factory = [VLGenericCodeGenerationStrategyFactory buildStrategyFactory];
        [strategy_factory setMyStrategyMappingTree:xml_mapping_tree];
        
        // Build the service -
        VLGenericCodeGenerationService *service = [VLGenericCodeGenerationService startService];
        
        // Set the transformation tree -
        [service setMyCodeTransformationTree:xml_transformation_tree];
        [service setMyCodeTransformationMappingTree:xml_mapping_tree];
        
        // Do the transformation -
        // completion handler -
        void (^MyCompletionHandler)(void) = ^{
            
            // shutdown -
            [VLGenericCodeGenerationService shutdownService];
        };
        
        // execute -
        [service generateModelCodeWithCompletionHandler:MyCompletionHandler];
        
    }
    return 0;
}

