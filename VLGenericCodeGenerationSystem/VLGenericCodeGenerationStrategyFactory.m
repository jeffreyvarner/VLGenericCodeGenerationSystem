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

//-(id)executeStrategyForClass:(NSObject *)callerObject
//                 andSelector:(SEL)methodSelector
//               withModelType:(NSString *)modelType
//          withSourceEncoding:(NSString *)sourceEncoding
//                 withOptions:(NSDictionary *)options
//{
//    // how do we do the matching?
//    id result = nil;
//    VLAbstractStrategy *strategy = nil;
//    
//    // hardcode for now - we need to make this dynamic somehow ...
//    if ([callerObject isKindOfClass:[VLOctaveMOutputHandler class]] == YES)
//    {
//        // ok, we have a octave-m job. What type of job?
//        NSString *method_selector_string = NSStringFromSelector(methodSelector);
//        if ([method_selector_string isEqualToString:@"generateOctaveMDataFileActionWithOptions:"] == YES)
//        {
//            // ok, we are building an octave-m datafile, what type of model?
//            if ([modelType isEqualToString:@"CELL_FREE_MODEL"] == YES)
//            {
//                // octave-m datafile for a cell free model -
//                strategy = [[VLOctaveMDataFileCellFreeModelStrategy alloc] init];
//            }
//        }
//        else if ([method_selector_string isEqualToString:@"generateOctaveMBalanceEquationsActionWithOptions:"] == YES)
//        {
//            // ok, we are building an octave-m datafile, what type of model?
//            if ([modelType isEqualToString:@"CELL_FREE_MODEL"] == YES)
//            {
//                // octave-m datafile for a cell free model -
//                strategy = [[VLOctaveMBalanceEquationsCellFreeModelStrategy alloc] init];
//            }
//        }
//        else if ([method_selector_string isEqualToString:@"generateOctaveMSolveBalanceEquationsActionWithOptions:"] == YES)
//        {
//            // this code will be the same no matter what model type we have -
//            strategy = [[VLOctaveMGenericDriverSolveBalancesEquationsStrategy alloc] init];
//        }
//        else if ([method_selector_string isEqualToString:@"generateOctaveMKineticsActionWithOptions:"] == YES)
//        {
//            // ok, we are building an octave-m datafile, what type of model?
//            if ([modelType isEqualToString:@"CELL_FREE_MODEL"] == YES)
//            {
//                strategy = [[VLOctaveMKineticsCellFreeModelStrategy alloc] init];
//            }
//        }
//        else
//        {
//            
//        }
//    }
//    
//    // execute the strategy -
//    result = [strategy executeStrategyWithOptions:options];
//    
//    // default is to return nil -
//    return  result;
//}

-(id)executeStrategyForClass:(NSObject *)callerObject
                 andSelector:(SEL)methodSelector
               withModelType:(NSString *)modelType
          withSourceEncoding:(NSString *)sourceEncoding
                 withOptions:(NSDictionary *)options
{
    // if we do *not* have the mapping tree, are other required stuff to look up the strategy, then all is lost ...
    if ([self myStrategyMappingTree] == nil ||
        modelType == nil ||
        callerObject == nil ||
        methodSelector == NULL)
    {
        return nil;
    }
    
    // how do we do the matching?
    id result = nil;
    VLAbstractStrategy *strategy = nil;
    
    // Get the strategy_mapping_block -
    NSXMLDocument *mapping_tree = self.myStrategyMappingTree;
    NSString *caller_class = NSStringFromClass([callerObject class]);
    NSString *method_selector_string = NSStringFromSelector(methodSelector);
    NSString *xpath = [NSString stringWithFormat:@".//strategy_mapping_block/%@/strategy_map[@model_type='%@' and @method = '%@']/@strategy_class",caller_class,modelType,method_selector_string];
    NSString *strategy_class_string = [[[mapping_tree nodesForXPath:xpath error:nil] lastObject] stringValue];
    
    // Build my strategy class -
    strategy = [[NSClassFromString(strategy_class_string) alloc] init];
    
    // execute the strategy -
    result = [strategy executeStrategyWithOptions:options];
    
    // return nil result by default -
    return result;
}


#pragma mark - setup and shutdown private
-(void)setup
{
    
}

-(void)cleanMyMemory
{
    // kia my iVars -
    self.myStrategyMappingTree = nil;
    
    // remove me from notifications -
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
