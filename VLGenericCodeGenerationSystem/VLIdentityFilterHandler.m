//
//  VLIdentityFilterHandler.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/5/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLIdentityFilterHandler.h"

@implementation VLIdentityFilterHandler

-(id)performVLGenericCodeGenerationFilterActionWithOptions:(NSDictionary *)options
{
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:kXMLModelInputTree];
    return input_tree;
}

@end
