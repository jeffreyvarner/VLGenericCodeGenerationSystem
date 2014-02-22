//
//  VLOctaveMBalanceEquationsCellFreeModelStrategy.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/21/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLOctaveMBalanceEquationsCellFreeModelStrategy.h"

@implementation VLOctaveMBalanceEquationsCellFreeModelStrategy



-(id)executeStrategyWithOptions:(NSDictionary *)options
{
    if (options == nil)
    {
        return nil;
    }
    
    // Buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // ok, we need to build the mass balances -
    // Get our trees from the dictionary -
    NSXMLDocument *transformation_tree = [options objectForKey:@"TRANSFORMATION_TREE"];
    NSXMLElement *transformation = [options objectForKey:@"TRANSFORMATION_XML_ELEMENT"];
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:@"INPUT_DATA_TREE"];
    
    // What is my model type?
    NSString *model_type_xpath = @"./Model/@type";
    NSString *typeString = [[[input_tree nodesForXPath:model_type_xpath error:nil] lastObject] stringValue];
    NSString *model_source_encoding = [[[input_tree nodesForXPath:@"./Model/@source_encoding" error:nil] lastObject] stringValue];
    
    // What is my function name?
    NSString *fname_xpath = @"./output_handler/transformation_property[@type=\"FUNCTION_NAME\"]/@value";
    NSString *tmpFunctionName = [[[transformation nodesForXPath:fname_xpath error:nil] lastObject] stringValue];
    
    // Are we generating sparse balances?
    NSString *compact_balances_xpath = @"./output_handler/transformation_property[@type=\"COMPACT_BALANCE_MODE\"]/@value";
    NSString *compact_form = [[[transformation nodesForXPath:compact_balances_xpath error:nil] lastObject] stringValue];
    
    // start -
    // Populate the buffer --
    [buffer appendFormat:@"function [DXDT] = %@(x,t,DF,S,kV,NUMBER_OF_STATES,NUMBER_OF_RATES)\n",tmpFunctionName];
    [buffer appendFormat:@"\n"];
    
    // call to the kinetics function -
    [buffer appendString:@"\t\% Calculate the kinetics rate vector -- \n"];
    [buffer appendString:@"\trV = Kinetics(t,x,kV,DF);\n"];
    [buffer appendFormat:@"\n"];
    [buffer appendString:@"\t\% Calculate the v-variable vector -- \n"];
    [buffer appendString:@"\tvV = Control(t,x,rV,kV,DF);\n"];
    [buffer appendFormat:@"\n"];
    [buffer appendString:@"\t\% Modify the rate vector -- \n"];
    [buffer appendString:@"\trate_vector = rV.*vV;\n"];
    [buffer appendFormat:@"\n"];
    
    
    // ok, if we are do compact form, then we are almost done -
    if ([compact_form isLike:@"TRUE"] == YES)
    {
        [buffer appendString:@"\t\% Write the mass balance equations (compact form) -- \n"];
        [buffer appendFormat:@"\tDXDT = S*rate_vector;\n"];
        [buffer appendFormat:@"\n"];
    }
    else
    {
        [buffer appendString:@"\t\% Write the mass balance equations (expansive form) -- \n"];
        
        // How many states do we have?
        [buffer appendString:@"DXDT(NUMBER_OF_STATES,1) = zeros(NUMBER_OF_STATES,1);\n"];
        
        // ok, when I get here - I need to know what type of source encoding that I have -
        
    }
    
    
    [buffer appendFormat:@"return;\n"];

    
    // return the buffer -
    return [NSString stringWithString:buffer];
}

@end
