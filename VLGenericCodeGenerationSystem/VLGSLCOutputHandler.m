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

-(id)generateGSLCJacobianMatrixActionWithOptions:(NSDictionary *)options
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
    NSString *header_buffer = [self generateModelJacobianMatrixHeaderBufferWithOptions:options];
    [self writeCodeGenerationHeaderFileOutput:header_buffer toFileWithOptions:options];
    
    // return the result from the strategy object -
    return result;
}

-(id)generateGSLCBMatrixActionWithOptions:(NSDictionary *)options
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
    NSString *header_buffer = [self generateModelBMatrixHeaderBufferWithOptions:options];
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
    
    // header content -
    NSString *header_buffer = [self generateVLGlobalHeaderBufferWithOptions:options];
    [self writeCodeGenerationHeaderFileOutput:header_buffer toFileWithOptions:options];
    
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

-(id)generateGSLCAdjointBalanceEquationsActionWithOptions:(NSDictionary *)options
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
    NSString *header_buffer = [self generateModelAdjointMassBalancesHeaderBufferWithOptions:options];
    [self writeCodeGenerationHeaderFileOutput:header_buffer toFileWithOptions:options];
    
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

-(id)generateGSLCEnzymeActivityControlActionWithOptions:(NSDictionary *)options
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
    NSString *header_buffer = [self generateEnzymeActivityControlHeaderBufferWithOptions:options];
    [self writeCodeGenerationHeaderFileOutput:header_buffer toFileWithOptions:options];
    
    // return the result from the strategy object -
    return result;
}

-(id)generateGSLCShellScriptActionWithOptions:(NSDictionary *)options
{
    // build the shell script -
    NSString *shell_script = [self generateModelSolveShellScriptBufferWithOptions:options];
    
    // dump to disk -
    [self writeCodeGenerationOutput:shell_script toFileWithOptions:options];
    
    // return -
    return shell_script;
}

#pragma mark - helpers
-(id)executeStrategyFactoryCallForObject:(NSObject *)caller
                             andSelector:(SEL)methodSelector
                             withOptions:(NSDictionary *)options
{
    // Get trees -
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:@"INPUT_DATA_TREE"];
    
    // Get some stuff from model tree -
    NSString *model_node_xpath = @".//model";
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

-(NSString *)generateEnzymeActivityControlHeaderBufferWithOptions:(NSDictionary *)options
{
    // get the transformation -
    NSXMLElement *transformation = [options objectForKey:kXMLTransformationElement];
    
    // function name?
    NSString *fname_xpath = @"./output_handler/transformation_property[@type=\"FUNCTION_NAME\"]/@value";
    NSString *functionName = [[[transformation nodesForXPath:fname_xpath error:nil] lastObject] stringValue];
    
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
    [buffer appendString:@"/* public methods */\n"];
    [buffer appendFormat:@"void %@(double t,gsl_vector *pStateVector, gsl_vector *pRateVector, gsl_vector *pControlVector,void* parameter_object);\n\n",functionName];
    [buffer appendString:@"\n"];
    
    // return -
    return [NSString stringWithString:buffer];
}

-(NSString *)generateModelOperationKineticsHeaderBufferWithOptions:(NSDictionary *)options
{
    // get the transformation -
    NSXMLElement *transformation = [options objectForKey:kXMLTransformationElement];
    
    // function name?
    NSString *fname_xpath = @"./output_handler/transformation_property[@type=\"FUNCTION_NAME\"]/@value";
    NSString *functionName = [[[transformation nodesForXPath:fname_xpath error:nil] lastObject] stringValue];

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
    [buffer appendString:@"#include \"VLGlobal.h\"\n"];
    [buffer appendString:@"\n"];
    [buffer appendString:@"/* public methods */\n"];
    [buffer appendFormat:@"void %@(double t,gsl_vector *pStateVector, gsl_vector *pRateVector, void* parameter_object);\n\n",functionName];
    [buffer appendString:@"\n"];
    
    // return -
    return [NSString stringWithString:buffer];
}

-(NSString *)generateVLGlobalHeaderBufferWithOptions:(NSDictionary *)options
{
    // Declare parameter struct in this header -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    /* Load the GSL and other headers - */
    [buffer appendString:@"#include <stdio.h>\n"];
    [buffer appendString:@"#include <math.h>\n"];
    [buffer appendString:@"#include <time.h>\n"];
    [buffer appendString:@"#include <gsl/gsl_errno.h>\n"];
    [buffer appendString:@"#include <gsl/gsl_matrix.h>\n"];
    [buffer appendString:@"#include <gsl/gsl_odeiv.h>\n"];
    [buffer appendString:@"#include <gsl/gsl_vector.h>\n"];
    [buffer appendString:@"#include <gsl/gsl_blas.h>\n"];
    
    [buffer appendString:@"/* parameter struct */\n"];
    [buffer appendString:@"#ifndef VLGLOBAL_H\n"];
    [buffer appendString:@"#define VLGLOBAL_H\n"];
    
    [buffer appendString:@"\tstruct VLParameters\n"];
    [buffer appendString:@"{\n"];
    [buffer appendString:@"\tgsl_vector *pModelKineticsParameterVector;\n"];
    [buffer appendString:@"\tgsl_vector *pModelVolumeVector;\n"];
    [buffer appendString:@"\tgsl_matrix *pModelCirculationMatrix;\n"];
    [buffer appendString:@"\tgsl_matrix *pModelStoichiometricMatrix;\n"];
    [buffer appendString:@"\tint parameter_index;\n"];
    [buffer appendString:@"};\n"];
    [buffer appendString:@"#endif\n"];
    
    // return -
    return buffer;
}

-(NSString *)generateModelAdjointMassBalancesHeaderBufferWithOptions:(NSDictionary *)options
{
    // get the transformation -
    NSXMLElement *transformation = [options objectForKey:kXMLTransformationElement];
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:kXMLModelInputTree];
    
    // What is my model type?
    NSString *model_type_xpath = @".//model/@type";
    NSString *model_type_string = [[[input_tree nodesForXPath:model_type_xpath error:nil] lastObject] stringValue];
    
    // function name?
    NSString *fname_xpath = @"./output_handler/transformation_property[@type=\"FUNCTION_NAME\"]/@value";
    NSString *functionName = [[[transformation nodesForXPath:fname_xpath error:nil] lastObject] stringValue];
    
    // Balance equations requires the name of the kinetics function name -
    NSString *dependency_xpath = @"./output_handler/output_handler_dependencies/dependency[@type=\"KINETICS_FUNCTION_NAME\"]/@value";
    NSString *dependencyName = [[[transformation nodesForXPath:dependency_xpath error:nil] lastObject] stringValue];
    
    // Do we have a jacobian?
    NSString *jacobian_dependency_xpath = @"./output_handler/output_handler_dependencies/dependency[@type=\"JACOBIAN_FUNCTION_NAME\"]/@value";
    NSString *jacobianDependencyName = [[[transformation nodesForXPath:jacobian_dependency_xpath error:nil] lastObject] stringValue];
    
    // do we have a BMatrix?
    NSString *bmatrix_dependency_xpath = @"./output_handler/output_handler_dependencies/dependency[@type=\"PARTIAL_DERIVATIVE_PARAMETER_FUNCTION_NAME\"]/@value";
    NSString *bmatrixDependencyName = [[[transformation nodesForXPath:bmatrix_dependency_xpath error:nil] lastObject] stringValue];

    
    // initialize the buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // There are a few options *depending* upon which model type we are -
    if ([model_type_string isEqualToString:kModelTypeCellFreeModel] == YES)
    {
        // Cell free *also* depends upon a control function -
        NSString *dependency_xpath_control = @"./output_handler/output_handler_dependencies/dependency[@type=\"ENZYME_ACTIVITY_CONTROL_FUNCTION_NAME\"]/@value";
        NSString *dependencyNameControl = [[[transformation nodesForXPath:dependency_xpath_control error:nil] lastObject] stringValue];
        
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
        [buffer appendString:@"#include \"VLGlobal.h\"\n"];
        [buffer appendFormat:@"#include \"%@.h\"\n",dependencyName];
        [buffer appendFormat:@"#include \"%@.h\"\n",dependencyNameControl];
        NEW_LINE;
        [buffer appendString:@"/* public methods */\n"];
        [buffer appendFormat:@"int %@(double t,const double x[],double f[],void * parameter_object);\n",functionName];
    }
    else if ([model_type_string isEqualToString:kModelTypeMassActionModel] == YES)
    {
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
        [buffer appendString:@"#include \"VLGlobal.h\"\n"];
        [buffer appendFormat:@"#include \"%@.h\"\n",dependencyName];
        [buffer appendFormat:@"#include \"%@.h\"\n",jacobianDependencyName];
        [buffer appendFormat:@"#include \"%@.h\"\n",bmatrixDependencyName];
        
        NEW_LINE;
        [buffer appendString:@"/* public methods */\n"];
        [buffer appendFormat:@"int %@(double t,const double x[],double f[],void * parameter_object);\n",functionName];
    }
    
    
    // return -
    return [NSString stringWithString:buffer];
}

-(NSString *)generateModelMassBalancesHeaderBufferWithOptions:(NSDictionary *)options
{
    // get the transformation -
    NSXMLElement *transformation = [options objectForKey:kXMLTransformationElement];
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:kXMLModelInputTree];
    
    // What is my model type?
    NSString *model_type_xpath = @".//model/@type";
    NSString *model_type_string = [[[input_tree nodesForXPath:model_type_xpath error:nil] lastObject] stringValue];
    
    // function name?
    NSString *fname_xpath = @"./output_handler/transformation_property[@type=\"FUNCTION_NAME\"]/@value";
    NSString *functionName = [[[transformation nodesForXPath:fname_xpath error:nil] lastObject] stringValue];
    
    // Balance equations requires the name of the kinetics function name -
    NSString *dependency_xpath = @"./output_handler/output_handler_dependencies/dependency[@type=\"KINETICS_FUNCTION_NAME\"]/@value";
    NSString *dependencyName = [[[transformation nodesForXPath:dependency_xpath error:nil] lastObject] stringValue];
    
    // initialize the buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];

    // There are a few options *depending* upon which model type we are -
    if ([model_type_string isEqualToString:kModelTypeCellFreeModel] == YES)
    {
        // Cell free *also* depends upon a control function -
        NSString *dependency_xpath_control = @"./output_handler/output_handler_dependencies/dependency[@type=\"ENZYME_ACTIVITY_CONTROL_FUNCTION_NAME\"]/@value";
        NSString *dependencyNameControl = [[[transformation nodesForXPath:dependency_xpath_control error:nil] lastObject] stringValue];
        
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
        [buffer appendString:@"#include \"VLGlobal.h\"\n"];
        [buffer appendFormat:@"#include \"%@.h\"\n",dependencyName];
        [buffer appendFormat:@"#include \"%@.h\"\n",dependencyNameControl];
        NEW_LINE;
        [buffer appendString:@"/* public methods */\n"];
        [buffer appendFormat:@"int %@(double t,const double x[],double f[],void * parameter_object);\n",functionName];
    }
    else if ([model_type_string isEqualToString:kModelTypeMassActionModel] == YES)
    {
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
        [buffer appendFormat:@"#include \"%@.h\"\n",dependencyName];
        NEW_LINE;
        [buffer appendString:@"/* public methods */\n"];
        [buffer appendFormat:@"int %@(double t,const double x[],double f[],void * parameter_object);\n",functionName];
    }
    
    
    // return -
    return [NSString stringWithString:buffer];
    
}

-(NSString *)generateModelBMatrixHeaderBufferWithOptions:(NSDictionary *)options
{
    // get the transformation -
    NSXMLElement *transformation = [options objectForKey:kXMLTransformationElement];
    
    // function name?
    NSString *fname_xpath = @"./output_handler/transformation_property[@type=\"FUNCTION_NAME\"]/@value";
    NSString *functionName = [[[transformation nodesForXPath:fname_xpath error:nil] lastObject] stringValue];
    
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
    [buffer appendString:@"#include \"VLGlobal.h\"\n"];
    
    NEW_LINE;
    [buffer appendString:@"/* public methods */\n"];
    [buffer appendFormat:@"int %@(double t, const double state[], gsl_matrix *pBMatrix, void* parameter_object);\n",functionName];
    
    
    // return -
    return [NSString stringWithString:buffer];
}


-(NSString *)generateModelJacobianMatrixHeaderBufferWithOptions:(NSDictionary *)options
{
    // get the transformation -
    NSXMLElement *transformation = [options objectForKey:kXMLTransformationElement];
    
    // function name?
    NSString *fname_xpath = @"./output_handler/transformation_property[@type=\"FUNCTION_NAME\"]/@value";
    NSString *functionName = [[[transformation nodesForXPath:fname_xpath error:nil] lastObject] stringValue];
    
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
    [buffer appendString:@"#include \"VLGlobal.h\"\n"];
    
    NEW_LINE;
    [buffer appendString:@"/* public methods */\n"];
    [buffer appendFormat:@"int %@(double t, const double state[], double *dfdy, double dfdt[],void *parameter_object);\n",functionName];
    
    
    // return -
    return [NSString stringWithString:buffer];
    
}


-(NSString *)generateModelSolveShellScriptBufferWithOptions:(NSDictionary *)options
{
    // initialize the buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];

    // get the transformation -
    NSXMLElement *transformation = [options objectForKey:kXMLTransformationElement];
    NSXMLElement *transformation_tree = [options objectForKey:kXMLTransformationTree];
    
    // What is the executable name?
    NSString *fname_xpath = @"./output_handler/transformation_property[@type=\"EXECUTABLE_NAME\"]/@value";
    NSString *functionName = [[[transformation nodesForXPath:fname_xpath error:nil] lastObject] stringValue];
    
    // What is my working directory?
    NSString *working_directory = [[[transformation_tree nodesForXPath:@".//property[@symbol='WORKING_DIRECTORY']/@value" error:nil] lastObject] stringValue];
    
    // What is my working directory?
    [buffer appendString:@"#!/bin/sh\n"];
    NEW_LINE;
    
    // what options do we have?
    NSArray *dependency_array = [transformation nodesForXPath:@"./output_handler/output_handler_dependencies/dependency" error:nil];
    for (NSXMLElement *dependency_node in dependency_array)
    {
        // Get the type and value data -
        NSString *type_string = [[dependency_node attributeForName:@"type"] stringValue];
        NSString *value_string = [[dependency_node attributeForName:@"value"] stringValue];
        NSString *full_path;
        
        // Do we have a working dir to append?
        if (working_directory!=nil)
        {
            full_path = [NSString stringWithFormat:@"%@%@",working_directory,value_string];
        }
        else
        {
            full_path = value_string;
        }
        
        
        // build the read-only lines -
        [buffer appendFormat:@"readonly %@=%@\n",type_string,full_path];
    }
    
    //readonly EXECUTABLE_PATH=/Users/jeffreyvarner/octave_work/PBPK_model_v1/P3/src
    //readonly OUTPUT_FILE=/Users/jeffreyvarner/octave_work/PBPK_model_v1/P1/src/Simulation_P1.out
    //readonly KINETICS_FILE=/Users/jeffreyvarner/octave_work/PBPK_model_v1/P1/src/Parameters.dat
    //readonly IC_FILE=/Users/jeffreyvarner/octave_work/PBPK_model_v1/P1/src/InitialConditions.dat
    //readonly ST_MATRIX=/Users/jeffreyvarner/octave_work/PBPK_model_v1/P1/src/StoichiometricMatrix.dat
    //readonly FLOW_MATRIX=/Users/jeffreyvarner/octave_work/PBPK_model_v1/P1/src/CirculationMatrix.dat
    //readonly VOLUME_FILE=/Users/jeffreyvarner/octave_work/PBPK_model_v1/P1/src/Volume.dat
    
    NEW_LINE;
    
    // build the execution line -
    for (NSXMLElement *dependency_node in dependency_array)
    {
        // Get the type and value data -
        NSString *type_string = [[dependency_node attributeForName:@"type"] stringValue];
        [buffer appendFormat:@"$%@ ",type_string];
    }
    
    [buffer appendString:@"$1 $2 $3\n"];

    // return -
    return buffer;
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
    [buffer appendString:@"Model: "];
    for (NSString *file_name in file_name_array)
    {
        [buffer appendFormat:@"%@.c ",file_name];
    }
    NEW_LINE;
    
    // write the compile line -
    [buffer appendString:@"\t$(CC) $(CCFLAGS) -o Model "];
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
