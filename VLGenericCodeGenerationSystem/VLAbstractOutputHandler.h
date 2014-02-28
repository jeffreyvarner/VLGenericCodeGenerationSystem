//
//  VLAbstractOutputHandler.h
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/5/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLCoreUtilitiesLib.h"

@interface VLAbstractOutputHandler : NSObject
{
    
}

-(id)performVLGenericCodeGenerationOutputActionWithOptions:(NSDictionary *)options;
-(void)writeCodeGenerationOutput:(id)output toFileWithOptions:(NSDictionary *)options;
-(void)writeCodeGenerationHeaderFileOutput:(id)output toFileWithOptions:(NSDictionary *)options;

@end
