//
//  VLOctaveMKineticsCellFreeModelStrategy.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/24/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLOctaveMKineticsCellFreeModelStrategy.h"

@implementation VLOctaveMKineticsCellFreeModelStrategy

-(id)executeStrategyWithOptions:(NSDictionary *)options
{
    if (options == nil)
    {
        return nil;
    }
    
    // Buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];

    // Get our trees from the dictionary -
    NSXMLDocument *transformation_tree = [options objectForKey:@"TRANSFORMATION_TREE"];
    NSXMLElement *transformation = [options objectForKey:@"TRANSFORMATION_XML_ELEMENT"];
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:@"INPUT_DATA_TREE"];

    // Get some specific stuff from the trees -
    // What is my function name?
    NSString *fname_xpath = @"./output_handler/transformation_property[@type=\"FUNCTION_NAME\"]/@value";
    NSString *tmpFunctionName = [[[transformation nodesForXPath:fname_xpath error:nil] lastObject] stringValue];
    
    // build the buffer -
    // Write the function block -
    [buffer appendFormat:@"function [rV]= %@(t,x,kV,DF)",tmpFunctionName];
    [buffer appendString:@"\n"];
    [buffer appendString:@"% Build the kinetic expression for each model rate -- \n"];
    [buffer appendString:@"NUMBER_OF_RATES = DF.NUMBER_OF_RATES;\n"];
    [buffer appendString:@"rV = zeros(NUMBER_OF_RATES,1);\n"];
    [buffer appendString:@"\n"];
    [buffer appendString:@"% Alias the parameters - \n"];
    
    // get the array of interactions -
    NSArray *reaction_array = [input_tree nodesForXPath:@".//interaction" error:nil];
    NSInteger parameter_index = 1;
    for (NSXMLElement *reaction_node in reaction_array)
    {
        // What is my reaction string -
        NSString *raw_reactant_string = [[[reaction_node nodesForXPath:@"./interaction_input/@reaction_string" error:nil] lastObject] stringValue];
        
        // Ok, does this have a +?
        NSArray *reactant_array = [raw_reactant_string componentsSeparatedByString:@"+"];
        if ([reaction_array count]>0)
        {
            for (NSXMLElement *reactant_node in reaction_array)
            {
                
            }
        }
        else
        {
            [buffer appendFormat:@""];
        }
    }
    
    [buffer appendString:@"return;\n"];

    // return -
    return buffer;
}


@end
