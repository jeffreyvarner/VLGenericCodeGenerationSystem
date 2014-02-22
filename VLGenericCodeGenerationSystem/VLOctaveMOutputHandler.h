//
//  VLOctaveMOutputHandler.h
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/21/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLAbstractOutputHandler.h"

@interface VLOctaveMOutputHandler : VLAbstractOutputHandler
{
    
}


// language specific logic methods
-(id)generateOctaveMDataFileActionWithOptions:(NSDictionary *)options;
-(id)generateOctaveMBalanceEquationsActionWithOptions:(NSDictionary *)options;

@end
