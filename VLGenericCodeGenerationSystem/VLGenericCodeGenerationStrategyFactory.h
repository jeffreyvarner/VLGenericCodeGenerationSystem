//
//  VLGenericCodeGenerationStrategyFactory.h
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/20/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLOctaveMOutputHandler.h"
#import "VLOctaveMDataFileCellFreeModelStrategy.h"
#import "VLOctaveMBalanceEquationsCellFreeModelStrategy.h"

@interface VLGenericCodeGenerationStrategyFactory : NSObject
{
    
}

// Build my factory (singleton) -
+(VLGenericCodeGenerationStrategyFactory *)buildStrategyFactory;

// main public method -
-(id)executeStrategyForClass:(NSObject *)callerObject
                 andSelector:(SEL)methodSelector
               withModelType:(NSString *)modelType
          withSourceEncoding:(NSString *)sourceEncoding
                 withOptions:(NSDictionary *)options;



@end
