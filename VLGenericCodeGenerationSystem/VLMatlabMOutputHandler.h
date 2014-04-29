//
//  VLMatlabMOutputHandler.h
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 4/28/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLAbstractOutputHandler.h"

@interface VLMatlabMOutputHandler : VLAbstractOutputHandler
{
    
}

// language specific logic methods
-(id)generateMatlabMConstrainedSiganlingDataFileActionWithOptions:(NSDictionary *)options;
-(id)generateMatlabMConstrainedSiganlingControlFileActionWithOptions:(NSDictionary *)options;

@end
