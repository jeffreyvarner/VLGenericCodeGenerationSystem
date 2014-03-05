//
//  VLGSLCEnzymeActivityControlCellFreeModelStrategy.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 3/4/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLGSLCEnzymeActivityControlCellFreeModelStrategy.h"

#define NEW_LINE [buffer appendString:@"\n"]

@implementation VLGSLCEnzymeActivityControlCellFreeModelStrategy

-(id)executeStrategyWithOptions:(NSDictionary *)options
{
    if (options == nil)
    {
        return nil;
    }
    
    // Buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // Get our trees from the dictionary -
    __unused NSXMLDocument *transformation_tree = [options objectForKey:kXMLTransformationTree];
    NSXMLElement *transformation = [options objectForKey:kXMLTransformationElement];
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:kXMLModelInputTree];
    
    // function name?
    NSString *fname_xpath = @"./output_handler/transformation_property[@type=\"FUNCTION_NAME\"]/@value";
    NSString *tmpFunctionName = [[[transformation nodesForXPath:fname_xpath error:nil] lastObject] stringValue];
    
    // What is my model encoding?
    NSString *model_source_encoding = [[[input_tree nodesForXPath:@".//model/@source_encoding" error:nil] lastObject] stringValue];
    
    if ([model_source_encoding isEqualToString:kSourceEncodingVFF] == YES)
    {
        // system dimension?
        NSUInteger NUMBER_OF_RATES = [[input_tree nodesForXPath:@".//interaction" error:nil] count];
        NSUInteger NUMBER_OF_STATES = [[input_tree nodesForXPath:@".//species" error:nil] count];
        __unused NSUInteger NUMBER_OF_PARAMETERS = NUMBER_OF_RATES;
        __unused NSUInteger NUMBER_OF_COMPARTMENTS = 1;
        
        // headers -
        [buffer appendFormat:@"#include \"%@.h\"\n",tmpFunctionName];
        NEW_LINE;
        
        [buffer appendString:@"/* Problem specific define statements -- */\n"];
        [buffer appendFormat:@"#define NUMBER_OF_RATES %lu\n",NUMBER_OF_RATES];
        [buffer appendFormat:@"#define NUMBER_OF_STATES %lu\n",NUMBER_OF_STATES];
        [buffer appendString:@"#define EPSILON 1e-8\n"];
        NEW_LINE;
        
        [buffer appendString:@"\n"];
        [buffer appendFormat:@"void %@(double t,gsl_vector *pStateVector, gsl_vector *pRateVector, gsl_vector *pControlVector,void* parameter_object)\n",tmpFunctionName];
        [buffer appendString:@"{\n"];
        
        [buffer appendString:@"\t/* Default control vector is 1's -- */\n"];
        [buffer appendString:@"\tfor (int rate_index = 0;rate_index<NUMBER_OF_RATES;rate_index++)\n"];
        [buffer appendString:@"\t{\n"];
        [buffer appendString:@"\t\tgsl_vector_set(pControlVector,rate_index,1.0f);\n"];
        [buffer appendString:@"\t}\n"];
        
        [buffer appendString:@"}\n"];
    }
    else if ([model_source_encoding isEqualToString:kSourceEncodingSBML] == YES)
    {
        // system dimension?
        NSUInteger NUMBER_OF_RATES = [[input_tree nodesForXPath:@".//reaction" error:nil] count];
        NSUInteger NUMBER_OF_STATES = [[input_tree nodesForXPath:@".//species" error:nil] count];
        __unused NSUInteger NUMBER_OF_PARAMETERS = NUMBER_OF_RATES;
        __unused NSUInteger NUMBER_OF_COMPARTMENTS = 1;
        
        // headers -
        [buffer appendFormat:@"#include \"%@.h\"\n",tmpFunctionName];
        NEW_LINE;
        
        [buffer appendString:@"/* Problem specific define statements -- */\n"];
        [buffer appendFormat:@"#define NUMBER_OF_RATES %lu\n",NUMBER_OF_RATES];
        [buffer appendFormat:@"#define NUMBER_OF_STATES %lu\n",NUMBER_OF_STATES];
        [buffer appendString:@"#define EPSILON 1e-8\n"];
        NEW_LINE;
        
        [buffer appendString:@"\n"];
        [buffer appendFormat:@"void %@(double t,gsl_vector *pStateVector, gsl_vector *pRateVector, gsl_vector *pControlVector,void* parameter_object)\n",tmpFunctionName];
        [buffer appendString:@"{\n"];
        
        [buffer appendString:@"\t/* Default control vector is 1's -- */\n"];
        [buffer appendString:@"\tfor (int rate_index = 0;rate_index<NUMBER_OF_RATES;rate_index++)\n"];
        [buffer appendString:@"\t{\n"];
        [buffer appendString:@"\t\tgsl_vector_set(pControlVector,rate_index,1.0f);\n"];
        [buffer appendString:@"\t}\n"];
        
        [buffer appendString:@"}\n"];
    }

    
    // return -
    return buffer;
}

@end
