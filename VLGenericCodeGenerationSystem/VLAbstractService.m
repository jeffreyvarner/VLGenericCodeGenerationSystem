//
//  VLAbstractService.m
//  VLCellFreeCodeGenerator
//
//  Created by Jeffrey Varner on 1/31/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLAbstractService.h"

@implementation VLAbstractService

// static instance returned when we get the shared instance -
static id _sharedInstance;

+(id)startService
{
    return nil;
}

+(void)shutdownService
{
    
}

-(void)dealloc
{
    // kia my ivars -
    [self cleanMyMemory];
    
    if (DEBUG == 1)
    {
        NSLog(@"%@ called on %@",NSStringFromSelector(_cmd),[[self class] description]);
    }
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    
    // return self -
    return self;
}

-(void)setup
{
    // print dmessages in debug mode
    if (DEBUG == 1)
    {
        NSLog(@"Parent - %@ called on %@",NSStringFromSelector(_cmd),[[self class] description]);
    }
}

-(void)cleanMyMemory
{
    // Remove me from the NSNotificationCenter -
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
