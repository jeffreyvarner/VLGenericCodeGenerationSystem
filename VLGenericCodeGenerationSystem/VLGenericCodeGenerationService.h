//
//  VLGenericCodeGenerationService.h
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/5/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLAbstractService.h"
#import "VLCoreUtilitiesLib.h"
#import "VLAbstractInputHandler.h"
#import "VLAbstractOutputHandler.h"


// completion block -
typedef void (^VLCellFreeCodeGenerationSessionCompleted)(void);

@interface VLGenericCodeGenerationService : VLAbstractService
{
    @private
    NSXMLDocument *_myCodeTransformationTree;
    NSXMLDocument *_myCodeTransformationMappingTree;
    
}

// public properties -
@property (strong) NSXMLDocument *myCodeTransformationTree;
@property (strong) NSXMLDocument *myCodeTransformationMappingTree;


// execution -
-(void)generateModelCodeWithCompletionHandler:(VLCellFreeCodeGenerationSessionCompleted)completionHandler;


@end
