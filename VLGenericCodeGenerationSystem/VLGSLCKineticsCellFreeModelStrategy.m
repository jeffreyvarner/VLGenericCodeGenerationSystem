//
//  VLGSLCKineticsCellFreeModelStrategy.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 3/3/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLGSLCKineticsCellFreeModelStrategy.h"

@implementation VLGSLCKineticsCellFreeModelStrategy

-(id)executeStrategyWithOptions:(NSDictionary *)options
{
    if (options == nil)
    {
        return nil;
    }
    
    // ok, so this is going to use the *standard* data file -
    // Buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // Get our trees from the dictionary -
    NSXMLDocument *transformation_tree = [options objectForKey:kXMLTransformationTree];
    NSXMLElement *transformation = [options objectForKey:kXMLTransformationElement];
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:kXMLModelInputTree];
    
    // What is my model type?
    NSString *model_source_encoding = [[[input_tree nodesForXPath:@"./Model/@source_encoding" error:nil] lastObject] stringValue];
    
    // function name?
    NSString *fname_xpath = @"./output_handler/transformation_property[@type=\"FUNCTION_NAME\"]/@value";
    NSString *tmpFunctionName = [[[transformation nodesForXPath:fname_xpath error:nil] lastObject] stringValue];
    
    // headers -
    [buffer appendFormat:@"#include \"%@.h\"\n",tmpFunctionName];
    [buffer appendString:@"\n"];
    [buffer appendFormat:@"void %@(double t,gsl_vector *pStateVector, gsl_vector *pRateVector, void* parameter_object)\n",tmpFunctionName];
    [buffer appendString:@"{\n"];
    [buffer appendString:@"\t/* initialize -- */\n"];
    [buffer appendString:@"\tdouble rate_value = 0.0;\n"];
    [buffer appendString:@"\tdouble parameter_value = 0.0;\n"];
    [buffer appendString:@"\n"];
    [buffer appendString:@"\t/* Get the parameters from disk - */\n"];
    [buffer appendString:@"\tstruct VLParameters *parameter_struct = (struct VLParameters *)parameter_object;\n"];
    [buffer appendString:@"\tgsl_vector *pV = parameter_struct->pModelKineticsParameterVector;\n"];
    [buffer appendString:@"\n"];
    [buffer appendString:@"\t/* Alias elements of the state vector - */\n"];
    
    
    
    // return -
    return buffer;
}

@end
