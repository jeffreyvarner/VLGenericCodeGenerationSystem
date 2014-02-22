//
//  VLGenericCodeGenerationStrategyFactory.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/20/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLGenericCodeGenerationStrategyFactory.h"

@implementation VLGenericCodeGenerationStrategyFactory

// static instance returned when we get the shared instance -
static  VLGenericCodeGenerationStrategyFactory *_sharedInstance;

+(VLGenericCodeGenerationStrategyFactory *)buildStrategyFactory
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

+(void)shutdownFactory
{
    @synchronized(self)
    {
        // set the shared pointer to nil?
        _sharedInstance = nil;
    }
}

-(void)dealloc
{
    // kia my ivars -
    [self cleanMyMemory];
    
}

- (id)init
{
    self = [super init];
    if (self)
    {
        // setup -
        [self setup];
    }
    
    // return self -
    return self;
}

-(id)executeStrategyForClass:(NSObject *)callerObject
                 andSelector:(SEL)methodSelector
               withModelType:(NSString *)modelType
          withSourceEncoding:(NSString *)sourceEncoding
                 withOptions:(NSDictionary *)options
{
    // how do we do the matching?
    id result = nil;
    
    // hardcode for now - we need to make this dynamic somehow ...
    if ([callerObject isKindOfClass:[VLOctaveMOutputHandler class]] == YES)
    {
        // ok, we have a octave-m job. What type of job?
        NSString *method_selector_string = NSStringFromSelector(methodSelector);
        if ([method_selector_string isEqualToString:@"generateOctaveMDataFileActionWithOptions:"] == YES)
        {
            // ok, we are building an octave-m datafile, what type of model?
            if ([modelType isEqualToString:@"CELL_FREE_MODEL"] == YES)
            {
                // octave-m datafile for a cell free model -
                VLOctaveMDataFileCellFreeModelStrategy *strategy = [[VLOctaveMDataFileCellFreeModelStrategy alloc] init];
                result = [strategy executeStrategyWithOptions:options];
            }
        }
        else if ([method_selector_string isEqualToString:@"generateOctaveMBalanceEquationsActionWithOptions:"] == YES)
        {
            // ok, we are building an octave-m datafile, what type of model?
            if ([modelType isEqualToString:@"CELL_FREE_MODEL"] == YES)
            {
                // octave-m datafile for a cell free model -
                VLOctaveMBalanceEquationsCellFreeModelStrategy *strategy = [[VLOctaveMBalanceEquationsCellFreeModelStrategy alloc] init];
                result = [strategy executeStrategyWithOptions:options];
            }
        }
        else
        {
            
        }
    }
    
    // default is to return nil -
    return  result;
}


#pragma mark - setup and shutdown private
-(void)setup
{
    
}

-(void)cleanMyMemory
{
    
    // remove me from notifications -
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
