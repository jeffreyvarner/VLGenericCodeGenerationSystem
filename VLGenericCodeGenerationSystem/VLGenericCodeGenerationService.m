//
//  VLGenericCodeGenerationService.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/5/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLGenericCodeGenerationService.h"

@implementation VLGenericCodeGenerationService

// static instance returned when we get the shared instance -
static VLGenericCodeGenerationService *_sharedInstance;

// lifecycle methods
+(id)startService
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}


+(void)shutdownService
{
    @synchronized(self)
    {
        // set the shared pointer to nil?
        _sharedInstance = nil;
    }
}

-(void)dealloc
{
    [self cleanMyMemory];
}

#pragma mark - main method
-(void)generateModelCodeWithCompletionHandler:(VLCellFreeCodeGenerationSessionCompleted)completionHandler
{
    if (completionHandler == nil ||
        [self myCodeTransformationTree] == nil ||
        self.myCodeTransformationMappingTree == nil)
    {
        // oops - we have no tree, no completion handler or no mapping tree
        return;
    }
    
    // transformation tree -
    NSXMLDocument *tree = self.myCodeTransformationTree;
    NSXMLDocument *mapping_tree = self.myCodeTransformationMappingTree;
    
    // Create a mapping dictionary -
    NSMutableDictionary *mapping_dictionary = [[NSMutableDictionary alloc] init];
    NSArray *link_blocks = [mapping_tree nodesForXPath:@".//map_link" error:nil];
    for (NSXMLElement *link_object in link_blocks)
    {
        // Get the symbol -
        NSString *link_symbol = [[link_object attributeForName:@"symbol"] stringValue];
        NSString *link_class_value = [[link_object attributeForName:@"class"] stringValue];
        NSString *link_method_value = [[link_object attributeForName:@"method"] stringValue];
        
        // Dictionary -
        NSDictionary *link_dictionary = @
        {
            @"CLASS"    :   link_class_value,
            @"METHOD"   :   link_method_value
        };
        
        // add to the dictionary -
        [mapping_dictionary setValue:link_dictionary forKey:link_symbol];
    }
    
    // Process ... main loop
    NSArray *transformation_blocks = [tree nodesForXPath:@".//transformation" error:nil];
    for (NSXMLElement *transformation in transformation_blocks)
    {
        // Generate options dictionary for input handler -
        NSDictionary *input_options = @
        {
            @"TRANSFORMATION_TREE"          :   tree,
            @"TRANSFORMATION_XML_ELEMENT"   :   transformation,
            @"MAPPING_TREE"                 :   mapping_tree
        };
        
        // process my inputs -
        id input = [self processInputsForTransformation:transformation
                                  withMappingDictionary:mapping_dictionary
                                             andOptions:input_options];
        
        // process my filters -
        // ...
        
        // Generate options dictionary for output handler -
        NSDictionary *output_options = @
        {
            @"TRANSFORMATION_TREE"          :   tree,
            @"TRANSFORMATION_XML_ELEMENT"   :   transformation,
            @"MAPPING_TREE"                 :   mapping_tree,
            @"INPUT_DATA_TREE"              :   input
        };

        // process my outputs -
        id output = [self processOutputsForTransformation:transformation
                                    withMappingDictionary:mapping_dictionary
                                               andOptions:output_options];
        
    }
    
    // call the completion handler -
    completionHandler();
}

#pragma mark - helper
-(id)processInputsForTransformation:(NSXMLElement *)transformation
              withMappingDictionary:(NSDictionary *)mappingDictionary
                         andOptions:(NSDictionary *)options

{
    // What is my inpt key?
    NSString *input_handler_strategy_key = [[[transformation nodesForXPath:@"./input_handler/@strategy_handler" error:nil] lastObject] stringValue];
    
    // Get my implementation dicionary -
    NSDictionary *input_symbol_dictionary = [mappingDictionary objectForKey:input_handler_strategy_key];
    
    // Build the input class and method pointers -
    VLAbstractInputHandler *input_handler_class = [[NSClassFromString([input_symbol_dictionary valueForKey:@"CLASS"]) alloc] init];
    
    // get the selector -
    NSString *input_handle_selector_string = [input_symbol_dictionary valueForKey:@"METHOD"];
    SEL input_handler_selector = NSSelectorFromString(input_handle_selector_string);
    
    //specify the function pointer
    typedef NSString* (*methodPtr)(id, SEL,NSDictionary*);
    
    // get the actual method
    methodPtr input_handler_command = (methodPtr)[input_handler_class methodForSelector:input_handler_selector];
    
    // run the input method -
    id input_code_block = input_handler_command(input_handler_class,input_handler_selector,options);

    // return -
    return input_code_block;
}

-(id)processOutputsForTransformation:(NSXMLElement *)transformation
               withMappingDictionary:(NSDictionary *)mappingDictionary
                          andOptions:(NSDictionary *)options
{
    // What are the input, output and filter keys
    NSString *output_handler_strategy_key = [[[transformation nodesForXPath:@"./output_handler/@strategy_handler" error:nil] lastObject] stringValue];

    // ok, we need to load the class and the method for the input handler -
    NSDictionary *output_symbol_dictionary = [mappingDictionary objectForKey:output_handler_strategy_key];
    
    // specify the function pointer
    typedef NSString* (*methodPtr)(id, SEL,NSDictionary*);
    
    // Do the output handler -
    VLAbstractOutputHandler *output_handler_class = [[NSClassFromString([output_symbol_dictionary valueForKey:@"CLASS"]) alloc] init];
    
    // get the selector -
    NSString *output_handle_selector_string = [output_symbol_dictionary valueForKey:@"METHOD"];
    SEL output_handler_selector = NSSelectorFromString(output_handle_selector_string);
    
    // get the actual method
    methodPtr output_handler_command = (methodPtr)[output_handler_class methodForSelector:output_handler_selector];
    
    // run the input method -
    id output_code_block = output_handler_command(output_handler_class,output_handler_selector,options);

    // return -
    return output_code_block;
}

#pragma mark - setup
-(void)setup
{
    
}

-(void)cleanMyMemory
{
    [super cleanMyMemory];
    
    // kia my stuff -
    self.myCodeTransformationTree = nil;
    self.myCodeTransformationMappingTree = nil;
}


@end
