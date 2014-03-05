//
//  VLGSLCBalanceEquationsCellFreeModelStrategy.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 3/4/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLGSLCBalanceEquationsCellFreeModelStrategy.h"

#define NEW_LINE [buffer appendString:@"\n"]

@implementation VLGSLCBalanceEquationsCellFreeModelStrategy

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
    
    // Balance equations requires the name of the kinetics function name -
    NSString *dependency_xpath = @"./output_handler/output_handler_dependencies/dependency[@type=\"KINETICS_FUNCTION_NAME\"]/@value";
    NSString *dependencyName = [[[transformation nodesForXPath:dependency_xpath error:nil] lastObject] stringValue];
    
    NSString *dependency_xpath_control = @"./output_handler/output_handler_dependencies/dependency[@type=\"ENZYME_ACTIVITY_CONTROL_FUNCTION_NAME\"]/@value";
    NSString *dependencyNameControl = [[[transformation nodesForXPath:dependency_xpath_control error:nil] lastObject] stringValue];

    
    // What is my model type?
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
        
        [buffer appendFormat:@"int %@(double t,const double x[],double f[],void * parameter_object)\n",tmpFunctionName];
        [buffer appendString:@"{\n"];
        [buffer appendString:@"\t/* Initialize -- */\n"];
        [buffer appendString:@"\tstruct VLParameters *parameter_struct = (struct VLParameters *)parameter_object;\n"];
        [buffer appendString:@"\tgsl_vector *pRateVector = gsl_vector_alloc(NUMBER_OF_RATES);\n"];
        [buffer appendString:@"\tgsl_vector *pStateVector = gsl_vector_alloc(NUMBER_OF_STATES);\n"];
        [buffer appendString:@"\tgsl_vector *pControlVector = gsl_vector_alloc(NUMBER_OF_RATES);\n"];
        [buffer appendString:@"\tgsl_vector *pCorrectedRateVector = gsl_vector_alloc(NUMBER_OF_RATES);\n"];
        [buffer appendString:@"\tgsl_vector *pRightHandSideVector = gsl_vector_alloc(NUMBER_OF_STATES);\n"];
        NEW_LINE;
        [buffer appendString:@"\t/* Setup mass balance calculations -- */\n"];
        [buffer appendString:@"\tgsl_matrix *pStoichiometricMatrix = parameter_struct->pModelStoichiometricMatrix;\n"];
        NEW_LINE;
        [buffer appendString:@"\t/* Populate the state_vector -- */\n"];
        [buffer appendString:@"\tfor(int state_index = 0; state_index < NUMBER_OF_STATES; state_index++)\n"];
        [buffer appendString:@"\t{\n"];
        [buffer appendString:@"\t\t/* correct negative ... */\n"];
        [buffer appendString:@"\t\tif (x[state_index]<0)\n"];
        [buffer appendString:@"\t\t{\n"];
        [buffer appendString:@"\t\t\tgsl_vector_set(pStateVector,state_index,EPSILON);\n"];
        [buffer appendString:@"\t\t}\n"];
        [buffer appendString:@"\t\telse\n"];
        [buffer appendString:@"\t\t{\n"];
        [buffer appendString:@"\t\t\tgsl_vector_set(pStateVector,state_index,x[state_index]);\n"];
        [buffer appendString:@"\t\t}\n"];
        [buffer appendString:@"\t}\n"];
        NEW_LINE;
        [buffer appendString:@"\t/* Evaluate the kinetics -- */\n"];
        [buffer appendFormat:@"\t%@(t,pStateVector,pRateVector,parameter_object);\n",dependencyName];
        NEW_LINE;
        [buffer appendString:@"\t/* Evaluate the control vector -- */\n"];
        [buffer appendFormat:@"\t%@(t,pStateVector,pRateVector,pControlVector,parameter_object);\n",dependencyNameControl];
        NEW_LINE;
        [buffer appendString:@"\t/* Correct the kinetics vector -- */\n"];
        [buffer appendString:@"\tfor (int rate_index = 0;rate_index<NUMBER_OF_RATES;rate_index++)\n"];
        [buffer appendString:@"\t{\n"];
        [buffer appendString:@"\t\tdouble rate_value = gsl_vector_get(pRateVector,rate_index);\n"];
        [buffer appendString:@"\t\tdouble control_value = gsl_vector_get(pControlVector,rate_index);\n"];
        [buffer appendString:@"\t\tdouble corrected_value = rate_value*control_value;\n"];
        [buffer appendString:@"\t\tgsl_vector_set(pCorrectedRateVector,rate_index,corrected_value);\n"];
        [buffer appendString:@"\t}\n"];
        
        NEW_LINE;
        [buffer appendString:@"\t/* Calculate the right hand side -- */\n"];
        [buffer appendString:@"\tgsl_blas_dgemv(CblasNoTrans,1.0,pStoichiometricMatrix,pCorrectedRateVector,0.0,pRightHandSideVector);\n"];
        NEW_LINE;
        
        [buffer appendString:@"\t/* Populate the f[] term -- */\n"];
        [buffer appendString:@"\tfor(int state_index = 0; state_index < NUMBER_OF_STATES; state_index++)\n"];
        [buffer appendString:@"\t{\n"];
        [buffer appendString:@"\t\tf[state_index]=gsl_vector_get(pRightHandSideVector,state_index);\n"];
        [buffer appendString:@"\t}\n"];
        NEW_LINE;
        
        [buffer appendString:@"\t/* clean up -- */\n"];
        [buffer appendString:@"\tgsl_vector_free(pRateVector);\n"];
        [buffer appendString:@"\tgsl_vector_free(pStateVector);\n"];
        [buffer appendString:@"\tgsl_vector_free(pControlVector);\n"];
        [buffer appendString:@"\tgsl_vector_free(pCorrectedRateVector);\n"];
        [buffer appendString:@"\tgsl_vector_free(pRightHandSideVector);\n"];
        [buffer appendString:@"\treturn(GSL_SUCCESS);\n"];
        [buffer appendString:@"}\n"];
        
        // return -
        return [NSString stringWithString:buffer];
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
        
        [buffer appendFormat:@"int %@(double t,const double x[],double f[],void * parameter_object)\n",tmpFunctionName];
        [buffer appendString:@"{\n"];
        [buffer appendString:@"\t/* Initialize -- */\n"];
        [buffer appendString:@"\tstruct VLParameters *parameter_struct = (struct VLParameters *)parameter_object;\n"];
        [buffer appendString:@"\tgsl_vector *pRateVector = gsl_vector_alloc(NUMBER_OF_RATES);\n"];
        [buffer appendString:@"\tgsl_vector *pStateVector = gsl_vector_alloc(NUMBER_OF_STATES);\n"];
        [buffer appendString:@"\tgsl_vector *pControlVector = gsl_vector_alloc(NUMBER_OF_RATES);\n"];
        [buffer appendString:@"\tgsl_vector *pCorrectedRateVector = gsl_vector_alloc(NUMBER_OF_RATES);\n"];
        [buffer appendString:@"\tgsl_vector *pRightHandSideVector = gsl_vector_alloc(NUMBER_OF_STATES);\n"];
        NEW_LINE;
        [buffer appendString:@"\t/* Setup mass balance calculations -- */\n"];
        [buffer appendString:@"\tgsl_matrix *pStoichiometricMatrix = parameter_struct->pModelStoichiometricMatrix;\n"];
        NEW_LINE;
        [buffer appendString:@"\t/* Populate the state_vector -- */\n"];
        [buffer appendString:@"\tfor(int state_index = 0; state_index < NUMBER_OF_STATES; state_index++)\n"];
        [buffer appendString:@"\t{\n"];
        [buffer appendString:@"\t\t/* correct negative ... */\n"];
        [buffer appendString:@"\t\tif (x[state_index]<0)\n"];
        [buffer appendString:@"\t\t{\n"];
        [buffer appendString:@"\t\t\tgsl_vector_set(pStateVector,state_index,EPSILON);\n"];
        [buffer appendString:@"\t\t}\n"];
        [buffer appendString:@"\t\telse\n"];
        [buffer appendString:@"\t\t{\n"];
        [buffer appendString:@"\t\t\tgsl_vector_set(pStateVector,state_index,x[state_index]);\n"];
        [buffer appendString:@"\t\t}\n"];
        [buffer appendString:@"\t}\n"];
        NEW_LINE;
        [buffer appendString:@"\t/* Evaluate the kinetics -- */\n"];
        [buffer appendFormat:@"\t%@(t,pStateVector,pRateVector,parameter_object);\n",dependencyName];
        NEW_LINE;
        [buffer appendString:@"\t/* Evaluate the control vector -- */\n"];
        [buffer appendFormat:@"\t%@(t,pStateVector,pRateVector,pControlVector,parameter_object);\n",dependencyNameControl];
        NEW_LINE;
        [buffer appendString:@"\t/* Correct the kinetics vector -- */\n"];
        [buffer appendString:@"\tfor (int rate_index = 0;rate_index<NUMBER_OF_RATES;rate_index++)\n"];
        [buffer appendString:@"\t{\n"];
        [buffer appendString:@"\t\tdouble rate_value = gsl_vector_get(pRateVector,rate_index);\n"];
        [buffer appendString:@"\t\tdouble control_value = gsl_vector_get(pControlVector,rate_index);\n"];
        [buffer appendString:@"\t\tdouble corrected_value = rate_value*control_value;\n"];
        [buffer appendString:@"\t\tgsl_vector_set(pCorrectedRateVector,corrected_value,rate_index);\n"];
        [buffer appendString:@"\t}\n"];
        
        NEW_LINE;
        [buffer appendString:@"\t/* Calculate the right hand side -- */\n"];
        [buffer appendString:@"\tgsl_blas_dgemv(CblasNoTrans,1.0,pStoichiometricMatrix,pCorrectedRateVector,0.0,pRightHandSideVector);\n"];
        NEW_LINE;
        
        [buffer appendString:@"\t/* Populate the f[] term -- */\n"];
        [buffer appendString:@"\tfor(int state_index = 0; state_index < NUMBER_OF_STATES; state_index++)\n"];
        [buffer appendString:@"\t{\n"];
        [buffer appendString:@"\t\tf[state_index]=gsl_vector_get(pRightHandSideVector,state_index);\n"];
        [buffer appendString:@"\t}\n"];
        NEW_LINE;
        
        [buffer appendString:@"\t/* clean up -- */\n"];
        [buffer appendString:@"\tgsl_vector_free(pRateVector);\n"];
        [buffer appendString:@"\tgsl_vector_free(pStateVector);\n"];
        [buffer appendString:@"\tgsl_vector_free(pControlVector);\n"];
        [buffer appendString:@"\tgsl_vector_free(pCorrectedRateVector);\n"];
        [buffer appendString:@"\tgsl_vector_free(pRightHandSideVector);\n"];
        [buffer appendString:@"\treturn(GSL_SUCCESS);\n"];
        [buffer appendString:@"}\n"];
        
        // return -
        return [NSString stringWithString:buffer];
    }
    
    return buffer;
}


@end
