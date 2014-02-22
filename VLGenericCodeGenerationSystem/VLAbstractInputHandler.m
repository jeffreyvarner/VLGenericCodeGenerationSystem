//
//  VLAbstractInputHandler.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/5/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLAbstractInputHandler.h"

@implementation VLAbstractInputHandler

-(id)performVLGenericCodeGenerationInputActionWithOptions:(NSDictionary *)options
{
    // force the user to overide -
    [self doesNotRecognizeSelector:_cmd];
    return @"bummer_u_need_2_override_me";
}

@end
