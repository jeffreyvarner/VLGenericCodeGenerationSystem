//
//  VLGSLCAdjointBalanceEquationsMassActionStrategy.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 3/18/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLGSLCAdjointBalanceEquationsMassActionStrategy.h"

#define NEW_LINE [buffer appendString:@"\n"]

@implementation VLGSLCAdjointBalanceEquationsMassActionStrategy

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
    
    // my function name?
    NSString *fname_xpath = @"./output_handler/transformation_property[@type=\"FUNCTION_NAME\"]/@value";
    NSString *tmpFunctionName = [[[transformation nodesForXPath:fname_xpath error:nil] lastObject] stringValue];
    
    // my balance equations function name -
    NSString *dependency_xpath = @"./output_handler/output_handler_dependencies/dependency[@type=\"KINETICS_FUNCTION_NAME\"]/@value";
    NSString *dependencyName = [[[transformation nodesForXPath:dependency_xpath error:nil] lastObject] stringValue];
    
    // Do we have a jacobian?
    NSString *jacobian_dependency_xpath = @"./output_handler/output_handler_dependencies/dependency[@type=\"JACOBIAN_FUNCTION_NAME\"]/@value";
    NSString *jacobianDependencyName = [[[transformation nodesForXPath:jacobian_dependency_xpath error:nil] lastObject] stringValue];
    
    // do we have a BMatrix?
    NSString *bmatrix_dependency_xpath = @"./output_handler/output_handler_dependencies/dependency[@type=\"PARTIAL_DERIVATIVE_PARAMETER_FUNCTION_NAME\"]/@value";
    NSString *bmatrixDependencyName = [[[transformation nodesForXPath:bmatrix_dependency_xpath error:nil] lastObject] stringValue];

    // What is my model type?
    //NSString *model_type_xpath = @".//model/@type";
    //NSString *model_type_string = [[[input_tree nodesForXPath:model_type_xpath error:nil] lastObject] stringValue];
    
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
        [buffer appendString:@"\tgsl_vector *pRightHandSideVector = gsl_vector_alloc(NUMBER_OF_STATES);\n"];

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
        [buffer appendString:@"\tgsl_vector *pSensitivityStateVector = gsl_vector_alloc(NUMBER_OF_STATES);\n"];
        [buffer appendString:@"\tgsl_vector *pModelStateVector = gsl_vector_alloc(NUMBER_OF_STATES);\n"];
        
        [buffer appendString:@"\tgsl_vector *pRightHandSideSensitivityVector = gsl_vector_alloc(NUMBER_OF_STATES);\n"];
        [buffer appendString:@"\tgsl_vector *pRightHandSideModelVector = gsl_vector_alloc(NUMBER_OF_STATES);\n"];
        [buffer appendString:@"\tgsl_matrix *pBMatrix = gsl_matrix_alloc(NUMBER_OF_STATES,NUMBER_OF_RATES);\n"];
        [buffer appendString:@"\tgsl_matrix *pJMatrix = gsl_matrix_alloc(NUMBER_OF_STATES,NUMBER_OF_STATES);\n"];
        [buffer appendString:@"\tint parameter_index = parameter_struct->parameter_index;\n"];
        [buffer appendString:@"\tdouble tmpJacobianArray[NUMBER_OF_STATES*NUMBER_OF_STATES];\n"];
        [buffer appendString:@"\tdouble localStateArray[NUMBER_OF_STATES];\n"];
        
        [buffer appendString:@"\t/* Check for negative states -- */\n"];
        [buffer appendString:@"\tfor(int state_index = 0; state_index < NUMBER_OF_STATES; state_index++)\n"];
        [buffer appendString:@"\t{\n"];
        [buffer appendString:@"\t\t/* correct negative ... */\n"];
        [buffer appendString:@"\t\tif (x[state_index]<0)\n"];
        [buffer appendString:@"\t\t{\n"];
        [buffer appendString:@"\t\t\tgsl_vector_set(pModelStateVector,state_index,EPSILON);\n"];
        [buffer appendString:@"\t\t\tlocalStateArray[state_index] = EPSILON;\n"];
        [buffer appendString:@"\t\t}\n"];
        [buffer appendString:@"\t\telse\n"];
        [buffer appendString:@"\t\t{\n"];
        [buffer appendString:@"\t\t\tgsl_vector_set(pModelStateVector,state_index,x[state_index]);\n"];
        [buffer appendString:@"\t\t\tlocalStateArray[state_index] = x[state_index];\n"];
        [buffer appendString:@"\t\t}\n"];
        [buffer appendString:@"\t}\n"];

        
        NEW_LINE;
        [buffer appendString:@"\t/* Compute the Jacobian matrix -- */\n"];
        [buffer appendFormat:@"\t%@(t,localStateArray,&tmpJacobianArray[0],f,parameter_object);\n",jacobianDependencyName];
        [buffer appendFormat:@"\tfor (int outer_balance_index = 0;outer_balance_index<NUMBER_OF_STATES;outer_balance_index++)\n"];
        [buffer appendFormat:@"\t{\n"];
        [buffer appendFormat:@"\t\tfor (int inner_balance_index = 0;inner_balance_index<NUMBER_OF_STATES;inner_balance_index++)\n"];
        [buffer appendFormat:@"\t\t{\n"];
        [buffer appendFormat:@"\t\t\tint linear_index = outer_balance_index*NUMBER_OF_STATES + inner_balance_index;\n"];
        [buffer appendFormat:@"\t\t\tdouble value = tmpJacobianArray[linear_index];\n"];
        [buffer appendFormat:@"\t\t\tgsl_matrix_set(pJMatrix,outer_balance_index,inner_balance_index,value);\n"];
        [buffer appendFormat:@"\t\t}\n"];
        [buffer appendFormat:@"\t}\n"];
        
        NEW_LINE;
        [buffer appendString:@"\t/* Compute the B-matrix -- */\n"];
        [buffer appendFormat:@"\t%@(t,localStateArray,pBMatrix,parameter_object);\n",bmatrixDependencyName];
        [buffer appendFormat:@"\tgsl_vector_view tmp =  gsl_matrix_column(pBMatrix,parameter_index);\n"];
        [buffer appendFormat:@"\tgsl_vector *bVector =  &tmp.vector;\n"];
        NEW_LINE;
        [buffer appendString:@"\t/* Compute the sensitivity balances -- */\n"];
        [buffer appendString:@"\tdouble tmp_value = 0.0;\n"];
        [buffer appendString:@"\tfor (int state_index = (NUMBER_OF_STATES);state_index<(2*NUMBER_OF_STATES);state_index++)\n"];
        [buffer appendFormat:@"\t{\n"];
        [buffer appendFormat:@"\t\ttmp_value = x[state_index];\n"];
        [buffer appendFormat:@"\t\tgsl_vector_set(pSensitivityStateVector,(state_index - NUMBER_OF_STATES),tmp_value);\n"];
        [buffer appendFormat:@"\t}\n"];
        NEW_LINE;
        [buffer appendString:@"\tgsl_blas_dgemv(CblasNoTrans,1.0,pJMatrix,pSensitivityStateVector,0.0,pRightHandSideSensitivityVector);\n"];
        [buffer appendString:@"\tgsl_blas_daxpy(1.0,bVector,pRightHandSideSensitivityVector);\n"];
        
        [buffer appendString:@"\t/* Compute the model balances -- */\n"];
        [buffer appendString:@"\t/* Evaluate the kinetics -- */\n"];
        [buffer appendFormat:@"\t%@(t,pModelStateVector,pRateVector,parameter_object);\n",dependencyName];
        NEW_LINE;
        [buffer appendString:@"\t/* Calculate the right hand side -- */\n"];
        [buffer appendString:@"\tgsl_matrix *pStoichiometricMatrix = parameter_struct->pModelStoichiometricMatrix;\n"];
        [buffer appendString:@"\tgsl_blas_dgemv(CblasNoTrans,1.0,pStoichiometricMatrix,pRateVector,0.0,pRightHandSideModelVector);\n"];
        NEW_LINE;
        
        [buffer appendString:@"\t/* Populate the f[] term for model states -- */\n"];
        [buffer appendString:@"\tfor(int state_index = 0; state_index < NUMBER_OF_STATES; state_index++)\n"];
        [buffer appendString:@"\t{\n"];
        [buffer appendString:@"\t\tf[state_index]=gsl_vector_get(pRightHandSideModelVector,state_index);\n"];
        [buffer appendString:@"\t}\n"];
        NEW_LINE;
        
        [buffer appendString:@"\t/* Populate the f[] term for sensitivity states -- */\n"];
        [buffer appendString:@"\tfor(int state_index = (NUMBER_OF_STATES); state_index < (2*NUMBER_OF_STATES); state_index++)\n"];
        [buffer appendString:@"\t{\n"];
        [buffer appendString:@"\t\tf[state_index]=gsl_vector_get(pRightHandSideSensitivityVector,(state_index - NUMBER_OF_STATES));\n"];
        [buffer appendString:@"\t}\n"];
        NEW_LINE;

        [buffer appendString:@"\t/* clean up -- */\n"];
        [buffer appendString:@"\tgsl_vector_free(pRateVector);\n"];
        [buffer appendString:@"\tgsl_vector_free(pSensitivityStateVector);\n"];
        [buffer appendString:@"\tgsl_vector_free(pModelStateVector);\n"];
        [buffer appendString:@"\tgsl_vector_free(pRightHandSideSensitivityVector);\n"];
        [buffer appendString:@"\tgsl_vector_free(pRightHandSideModelVector);\n"];
        [buffer appendString:@"\tgsl_matrix_free(pBMatrix);\n"];
        [buffer appendString:@"\tgsl_matrix_free(pJMatrix);\n"];
        [buffer appendString:@"\treturn(GSL_SUCCESS);\n"];
        [buffer appendString:@"}\n"];
    }

    
    // return -
    return buffer;
}

@end
