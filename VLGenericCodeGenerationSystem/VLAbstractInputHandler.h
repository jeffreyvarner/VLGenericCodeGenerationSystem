//
//  VLAbstractInputHandler.h
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/5/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLAbstractInputHandler : NSObject
{
    
}

#pragma mark - override in subclasses
-(id)performVLGenericCodeGenerationInputActionWithOptions:(NSDictionary *)options;

@end
