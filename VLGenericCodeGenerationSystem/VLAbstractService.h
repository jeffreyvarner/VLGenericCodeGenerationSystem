//
//  VLAbstractService.h
//  VLCellFreeCodeGenerator
//
//  Created by Jeffrey Varner on 1/31/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLAbstractService : NSObject
{
    
}

// public methods -
+(id)startService;
+(void)shutdownService;
-(void)setup;
-(void)cleanMyMemory;


@end
