//
//  VLOctaveCOutputHandler.h
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/25/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLAbstractOutputHandler.h"

@interface VLOctaveCOutputHandler : VLAbstractOutputHandler
{
    
}

// language specific logic methods
-(id)generateOctaveCDataFileActionWithOptions:(NSDictionary *)options;
-(id)generateOctaveCBalanceEquationsActionWithOptions:(NSDictionary *)options;
-(id)generateOctaveCSolveBalanceEquationsActionWithOptions:(NSDictionary *)options;
-(id)generateOctaveCKineticsActionWithOptions:(NSDictionary *)options;


@end
