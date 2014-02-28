//
//  VLGSLCOutputHandler.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/25/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLGSLCOutputHandler.h"

#define NEW_LINE [buffer appendString:@"\n"]

@implementation VLGSLCOutputHandler

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
-(id)generateGSLCMakeFileActionWithOptions:(NSDictionary *)options
{
    // construct the build file -
    NSString *buffer = [self generateModelMakeFileBufferWithOptions:options];
    
    // write -
    [self writeCodeGenerationOutput:buffer toFileWithOptions:options];

    return buffer;
}

-(id)generateGSLCKineticsActionWithOptions:(NSDictionary *)options
{
    // I also need my current method sel and my class -
    SEL my_current_selector = _cmd;
    
    // execute strategy -
    id result = [self executeStrategyFactoryCallForObject:self
                                              andSelector:my_current_selector
                                              withOptions:options];
    
    // write -
    [self writeCodeGenerationOutput:result toFileWithOptions:options];
    
    // Header content -
    NSString *header_buffer = [self generateModelOperationKineticsHeaderBufferWithOptions:options];
    [self writeCodeGenerationHeaderFileOutput:header_buffer toFileWithOptions:options];
    
    // return the result from the strategy object -
    return result;
}

-(id)generateGSLCSolveBalanceEquationsActionWithOptions:(NSDictionary *)options
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

-(id)generateGSLCDataFileActionWithOptions:(NSDictionary *)options
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

-(id)generateGSLCBalanceEquationsActionWithOptions:(NSDictionary *)options
{
    
    // I also need my current method sel and my class -
    SEL my_current_selector = _cmd;
    
    // execute strategy -
    id result = [self executeStrategyFactoryCallForObject:self
                                              andSelector:my_current_selector
                                              withOptions:options];
    
    // write -
    [self writeCodeGenerationOutput:result toFileWithOptions:options];
    
    // Header content -
    NSString *header_buffer = [self generateModelMassBalancesHeaderBufferWithOptions:options];
    [self writeCodeGenerationHeaderFileOutput:header_buffer toFileWithOptions:options];
    
    // return the result from the strategy object -
    return result;
}

#pragma mark - helpers
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

-(NSString *)generateModelOperationKineticsHeaderBufferWithOptions:(NSDictionary *)options
{
    // initialize the buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // headers -
    [buffer appendString:@"/* Load the GSL and other headers - */\n"];
    [buffer appendString:@"#include <stdio.h>\n"];
    [buffer appendString:@"#include <math.h>\n"];
    [buffer appendString:@"#include <time.h>\n"];
    [buffer appendString:@"#include <gsl/gsl_errno.h>\n"];
    [buffer appendString:@"#include <gsl/gsl_matrix.h>\n"];
    [buffer appendString:@"#include <gsl/gsl_odeiv.h>\n"];
    [buffer appendString:@"#include <gsl/gsl_vector.h>\n"];
    [buffer appendString:@"#include <gsl/gsl_blas.h>\n\n"];
    [buffer appendString:@"\n"];
    [buffer appendString:@"/* parameter struct */\n"];
    [buffer appendString:@"struct VLParameters\n"];
    [buffer appendString:@"{\n"];
    [buffer appendString:@"\tgsl_vector *pModelKineticsParameterVector;\n"];
    [buffer appendString:@"\tgsl_vector *pModelVolumeVector;\n"];
    [buffer appendString:@"\tgsl_matrix *pModelCirculationMatrix;\n"];
    [buffer appendString:@"\tgsl_matrix *pModelStoichiometricMatrix;\n"];
    [buffer appendString:@"};\n\n"];
    [buffer appendString:@"\n"];
    [buffer appendString:@"/* public methods */\n"];
    [buffer appendString:@"void Kinetics(double t,double const state_vector[], gsl_vector *pRateVector, void* parameter_object);\n\n"];
    [buffer appendString:@"\n"];
    
    // return -
    return [NSString stringWithString:buffer];
}

-(NSString *)generateModelMassBalancesHeaderBufferWithOptions:(NSDictionary *)options
{
    // initialize the buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // headers -
    [buffer appendString:@"/* Load the GSL and other headers - */\n"];
    [buffer appendString:@"#include <stdio.h>\n"];
    [buffer appendString:@"#include <math.h>\n"];
    [buffer appendString:@"#include <time.h>\n"];
    [buffer appendString:@"#include <gsl/gsl_errno.h>\n"];
    [buffer appendString:@"#include <gsl/gsl_matrix.h>\n"];
    [buffer appendString:@"#include <gsl/gsl_odeiv.h>\n"];
    [buffer appendString:@"#include <gsl/gsl_vector.h>\n"];
    [buffer appendString:@"#include <gsl/gsl_blas.h>\n\n"];
    
    NEW_LINE;
    [buffer appendString:@"/* Load the model specific headers - */\n"];
    [buffer appendString:@"#include \"Kinetics.h\"\n"];
    NEW_LINE;
    [buffer appendString:@"/* public methods */\n"];
    [buffer appendString:@"int MassBalances(double t,const double x[],double f[],void * parameter_object);\n"];
    
    
    // return -
    return [NSString stringWithString:buffer];
    
}

-(NSString *)generateModelMakeFileBufferWithOptions:(NSDictionary *)options
{
    // initialize the buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    NSMutableArray *file_name_array = [[NSMutableArray alloc] init];
    
    // get trees from the options -
    NSXMLDocument *transformation_tree = [options objectForKey:kXMLTransformationElement];
    
    // build the flags at the beginning -
    [buffer appendString:@"CFLAGS = -std=c99 -pedantic -v -O2\n"];
    [buffer appendString:@"CC = gcc\n"];
    [buffer appendString:@"LFLAGS = /usr/local/lib/libgsl.a /usr/local/lib/libgslcblas.a -lm\n"];
    NEW_LINE;
    
    // Get the list of transformations -
    NSError *xpath_error;
    NSArray *transformation_array = [transformation_tree nodesForXPath:@"./output_handler/transformation_property[@type=\"FUNCTION_NAME\"]/@value" error:&xpath_error];
    for (NSXMLElement *value in transformation_array)
    {
        // get the children -
        NSString *output_file_name = [value stringValue];
        
        // What is the extension?
        NSString *file_extension = [output_file_name pathExtension];
        if ([file_extension isEqualToString:@"c"] == YES || [file_extension isEqualToString:@".c"] == YES)
        {
            // ok, so grab -
            NSRange name_range = NSMakeRange(0, [output_file_name length] - 2);
            NSString *file_name = [output_file_name substringWithRange:name_range];
            [file_name_array addObject:file_name];
        }
    }
    
    // write driver target -
    [buffer appendString:@"Driver: "];
    for (NSString *file_name in file_name_array)
    {
        [buffer appendFormat:@"%@.c ",file_name];
    }
    NEW_LINE;
    
    // write the compile line -
    [buffer appendString:@"\t$(CC) $(CCFLAGS) -o Driver "];
    for (NSString *file_name in file_name_array)
    {
        [buffer appendFormat:@"%@.c ",file_name];
    }
    [buffer appendString:@"$(LFLAGS)"];
    NEW_LINE;
    
    // write clean target -
    [buffer appendString:@"clean:\n\trm -f "];
    for (NSString *file_name in file_name_array)
    {
        [buffer appendFormat:@"%@.o %@ ",file_name,file_name];
    }
    NEW_LINE;
    
    // write the all target -
    [buffer appendString:@"all:\n\trm -f "];
    
    for (NSString *file_name in file_name_array)
    {
        [buffer appendFormat:@"%@.o %@ %@.c %@.h ",file_name,file_name,file_name,file_name];
    }
    NEW_LINE;
    
    // return -
    return [NSString stringWithString:buffer];
}


@end
