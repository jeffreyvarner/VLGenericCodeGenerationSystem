//
//  VLJuliaOutputHandler.h
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 5/7/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLAbstractOutputHandler.h"

@interface VLJuliaOutputHandler : VLAbstractOutputHandler
{
    
}

-(id)generateJuliaConstrainedSignalingDataFileActionWithOptions:(NSDictionary *)options;
-(id)generateJuliaConstrainedSignalingControlFileActionWithOptions:(NSDictionary *)options;


@end
