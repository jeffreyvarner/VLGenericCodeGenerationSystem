//
//  VLGSLCOutputHandler.h
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/25/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLAbstractOutputHandler.h"

@interface VLGSLCOutputHandler : VLAbstractOutputHandler
{
    
}


// language specific logic methods
-(id)generateGSLCDataFileActionWithOptions:(NSDictionary *)options;
-(id)generateGSLCBalanceEquationsActionWithOptions:(NSDictionary *)options;
-(id)generateGSLCAdjointBalanceEquationsActionWithOptions:(NSDictionary *)options;
-(id)generateGSLCSolveBalanceEquationsActionWithOptions:(NSDictionary *)options;
-(id)generateGSLCSolveAdjointBalanceEquationsActionWithOptions:(NSDictionary *)options;
-(id)generateGSLCKineticsActionWithOptions:(NSDictionary *)options;
-(id)generateGSLCMakeFileActionWithOptions:(NSDictionary *)options;
-(id)generateGSLCShellScriptActionWithOptions:(NSDictionary *)options;
-(id)generateGSLCAdjointShellScriptActionWithOptions:(NSDictionary *)options;
-(id)generateGSLCJacobianMatrixActionWithOptions:(NSDictionary *)options;
-(id)generateGSLCBMatrixActionWithOptions:(NSDictionary *)options;
-(id)generateGSLCEnzymeActivityControlActionWithOptions:(NSDictionary *)options;

@end
