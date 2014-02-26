//
//  VLSahredUtilitiesOutputHandler.h
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/25/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLAbstractOutputHandler.h"

@interface VLSharedUtilitiesOutputHandler : VLAbstractOutputHandler
{
    
}

-(id)generateStoichiometricMatrixActionWithOptions:(NSDictionary *)options;

@end
