//
//  VLOctaveMOutputHandler.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/21/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLOctaveMOutputHandler.h"

@implementation VLOctaveMOutputHandler

-(id)performVLGenericCodeGenerationOutputActionWithOptions:(NSDictionary *)options
{
    
    if (options == nil)
    {
        return nil;
    }
    
    // Get our trees from the dictionary -
    NSXMLDocument *transformation_tree = [options objectForKey:@"TRANSFORMATION_TREE"];
    NSXMLElement *transformation = [options objectForKey:@"TRANSFORMATION_XML_ELEMENT"];
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:@"INPUT_DATA_TREE"];
    
    // dump to disk for debugging -
    NSString *code_block = [input_tree XMLStringWithOptions:NSXMLDocumentTidyXML];
    
    // write -
    [self writeCodeGenerationOutput:code_block toFileWithOptions:options];
    
    // return the code block -
    return code_block;
}

#pragma mark - public methods
-(id)generateOctaveMDataFileActionWithOptions:(NSDictionary *)options
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

-(id)generateOctaveMBalanceEquationsActionWithOptions:(NSDictionary *)options
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
