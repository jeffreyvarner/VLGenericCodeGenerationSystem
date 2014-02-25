//
//  VLOctaveCOutputHandler.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/25/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLOctaveCOutputHandler.h"

@implementation VLOctaveCOutputHandler

-(id)performVLGenericCodeGenerationOutputActionWithOptions:(NSDictionary *)options
{
    
    if (options == nil)
    {
        return nil;
    }
    
    // return the code block -
    return nil;
}

#pragma mark - public methods
-(id)generateOctaveCKineticsActionWithOptions:(NSDictionary *)options
{
    // I also need my current method sel and my class -
    SEL my_current_selector = _cmd;
    
    // execute strategy -
    id result = [self executeStrategyFactoryCallForObject:self
                                              andSelector:my_current_selector
                                              withOptions:options];
    
    // write -
    [self writeCodeGenerationOutput:result toFileWithOptions:options];
    
    // return the result from the strategy object -
    return result;
}

-(id)generateOctaveCSolveBalanceEquationsActionWithOptions:(NSDictionary *)options
{
    // I also need my current method sel and my class -
    SEL my_current_selector = _cmd;
    
    // execute strategy -
    id result = [self executeStrategyFactoryCallForObject:self
                                              andSelector:my_current_selector
                                              withOptions:options];
    
    // write -
    [self writeCodeGenerationOutput:result toFileWithOptions:options];
    
    // return the result from the strategy object -
    return result;
}

-(id)generateOctaveCDataFileActionWithOptions:(NSDictionary *)options
{
    // I also need my current method sel and my class -
    SEL my_current_selector = _cmd;
    
    // execute strategy -
    id result = [self executeStrategyFactoryCallForObject:self
                                              andSelector:my_current_selector
                                              withOptions:options];
    
    // write -
    [self writeCodeGenerationOutput:result toFileWithOptions:options];
    
    // return the result from the strategy object -
    return result;
}

-(id)generateOctaveCBalanceEquationsActionWithOptions:(NSDictionary *)options
{
    
    // I also need my current method sel and my class -
    SEL my_current_selector = _cmd;
    
    // execute strategy -
    id result = [self executeStrategyFactoryCallForObject:self
                                              andSelector:my_current_selector
                                              withOptions:options];
    
    // write -
    [self writeCodeGenerationOutput:result toFileWithOptions:options];
    
    // return the result from the strategy object -
    return result;
}

#pragma mark - helper
-(id)executeStrategyFactoryCallForObject:(NSObject *)caller
                             andSelector:(SEL)methodSelector
                             withOptions:(NSDictionary *)options
{
    // Get trees -
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:@"INPUT_DATA_TREE"];
    
    // Get some stuff from model tree -
    NSString *model_node_xpath = @"/Model";
    NSXMLElement *model_node = [[input_tree nodesForXPath:model_node_xpath error:nil] lastObject];
    NSString *model_type = [[model_node attributeForName:@"type"] stringValue];
    NSString *model_source_encoding = [[model_node attributeForName:@"source_encoding"] stringValue];
    
    // Build a factory -
    VLGenericCodeGenerationStrategyFactory *strategy_factory = [VLGenericCodeGenerationStrategyFactory buildStrategyFactory];
    
    // execute a strategy bitches ...
    id result = [strategy_factory executeStrategyForClass:caller
                                              andSelector:methodSelector
                                            withModelType:model_type
                                       withSourceEncoding:model_source_encoding
                                              withOptions:options];
    
    return result;
}


@end
