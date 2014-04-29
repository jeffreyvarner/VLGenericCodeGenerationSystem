//
//  VLMatlabMControlFunctionCBSignalingModelStrategy.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 4/29/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLMatlabMControlFunctionCBSignalingModelStrategy.h"

#define NEW_LINE [buffer appendString:@"\n"]

@implementation VLMatlabMControlFunctionCBSignalingModelStrategy

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
    [buffer appendFormat:@"function [LB,UB] = %@(time_value,XCURRENT,FLOW,DFIN)\n",tmpFunctionName];
    [buffer appendString:@"% ---------------------------------------------------------------------- %\n"];
    [buffer appendFormat:@"%% %@.m was generated using the UNIVERSAL code generation system.\n",tmpFunctionName];
    [buffer appendString:@"% Username: \n"];
    [buffer appendFormat:@"%% Type: %@ \n",typeString];
    [buffer appendString:@"% \n"];
    [buffer appendString:@"% DFIN  - Data file instance \n"];
    [buffer appendString:@"% ---------------------------------------------------------------------- %\n"];
    [buffer appendString:@"\n"];
    NEW_LINE;
    [buffer appendString:@"FB = DFIN.FLUX_BOUNDS;\n"];
    [buffer appendString:@"LB = FB(:,1);\n"];
    [buffer appendString:@"UB = FB(:,2);\n"];
    NEW_LINE;
    
    // alias the species -
    NSArray *species_array = [input_tree nodesForXPath:@".//species" error:nil];
    NSUInteger counter = 1;
    for (NSXMLElement *species_node in species_array)
    {
        // what is the id?
        NSString *species_id = [[species_node attributeForName:@"id"] stringValue];
        [buffer appendFormat:@"%@ = XCURRENT(%lu,1);\n",species_id,counter];
        
        // update and go around again -
        counter++;
    }
    NEW_LINE;

    return buffer;
}


@end
