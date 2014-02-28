//
//  VLGSLCGenericDriverSolveBalancesEquationsStrategy.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/28/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLGSLCGenericDriverSolveBalancesEquationsStrategy.h"
#define NEW_LINE [buffer appendString:@"\n"]

@implementation VLGSLCGenericDriverSolveBalancesEquationsStrategy

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
    __unused NSXMLElement *transformation = [options objectForKey:kXMLTransformationElement];
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:kXMLModelInputTree];
    
    // What is my model type?
    NSString *model_source_encoding = [[[input_tree nodesForXPath:@"./Model/@source_encoding" error:nil] lastObject] stringValue];
    if ([model_source_encoding isEqualToString:kSourceEncodingVFF] == YES)
    {
        // system dimension?
        NSUInteger NUMBER_OF_RATES = [[input_tree nodesForXPath:@".//interaction" error:nil] count];
        NSUInteger NUMBER_OF_STATES = [[input_tree nodesForXPath:@".//species" error:nil] count];
        NSUInteger NUMBER_OF_PARAMETERS = NUMBER_OF_RATES;
        NSUInteger NUMBER_OF_COMPARTMENTS = 1;

        // main -
        [buffer appendString:@"/* Load the GSL and other headers - */\n"];
        [buffer appendString:@"#include <stdio.h>\n"];
        [buffer appendString:@"#include <math.h>\n"];
        [buffer appendString:@"#include <time.h>\n"];
        [buffer appendString:@"#include <gsl/gsl_errno.h>\n"];
        [buffer appendString:@"#include <gsl/gsl_matrix.h>\n"];
        [buffer appendString:@"#include <gsl/gsl_odeiv2.h>\n"];
        [buffer appendString:@"#include <gsl/gsl_vector.h>\n"];
        [buffer appendString:@"#include <gsl/gsl_blas.h>\n\n"];
        
        NEW_LINE;
        [buffer appendString:@"/* Load the model specific headers - */\n"];
        [buffer appendString:@"#include \"MassBalances.h\"\n"];
        NEW_LINE;
        [buffer appendString:@"/* Problem specific define statements -- */\n"];
        [buffer appendString:@"#define NUMBER_OF_ARGUEMENTS 10\n"];
        [buffer appendFormat:@"#define NUMBER_OF_RATES %lu\n",NUMBER_OF_RATES];
        [buffer appendFormat:@"#define NUMBER_OF_STATES %lu\n",NUMBER_OF_STATES];
        [buffer appendFormat:@"#define NUMBER_OF_PARAMETERS %lu\n",NUMBER_OF_PARAMETERS];
        [buffer appendFormat:@"#define NUMBER_OF_COMPARTMENTS %lu\n",NUMBER_OF_COMPARTMENTS];
        [buffer appendFormat:@"#define TOLERANCE 1e-6\n"];
        NEW_LINE;
        [buffer appendString:@"/* Function prototypes -- */\n"];
        [buffer appendString:@"static void populateGSLMatrixFromFile(const char* pFilename, gsl_matrix *pGSLMatrix);\n"];
        [buffer appendString:@"static void populateGSLVectorFromFile(const char* pFilename, gsl_vector *pGSLVector);\n"];
        [buffer appendString:@"static void populateDoubleCArraryFromFile(const char* pFilename,double *pDoubleArray);\n"];
        [buffer appendString:@"static void writeSimulationOutputRecord(FILE *output_file,double time,double *pDoubleResultsArray);\n"];
        
        NEW_LINE;
        [buffer appendString:@"int main(int argc, char* const argv[])\n"];
        [buffer appendString:@"{\n"];
        [buffer appendString:@"\t/* ====================================================== \n"];
        [buffer appendString:@"\t * Arguments list:\n"];
        [buffer appendString:@"\t * 1. Simulation output path \n"];
        [buffer appendString:@"\t * 2. Path to kinetic parameters \n"];
        [buffer appendString:@"\t * 3. Path to initial conditions \n"];
        [buffer appendString:@"\t * 4. Path to stoichiometric matrix \n"];
        [buffer appendString:@"\t * 5. Path to circulation matrix \n"];
        [buffer appendString:@"\t * 6. Simulation start time \n"];
        [buffer appendString:@"\t * 7. Simulation stop time \n"];
        [buffer appendString:@"\t * 8. Simulation step size \n"];
        [buffer appendString:@"\t ======================================================= */\n"];
        NEW_LINE;
        [buffer appendString:@"\t/* Check number of input arguments -- */\n"];
        [buffer appendString:@"\tif (argc != NUMBER_OF_ARGUEMENTS)\n"];
        [buffer appendString:@"\t{\n"];
        [buffer appendString:@"\t\tprintf(\"Incorrect number of input arguments.\\n\");\n"];
        [buffer appendString:@"\t\treturn(-1);\n"];
        [buffer appendString:@"\t}\n"];
        NEW_LINE;
        [buffer appendString:@"\t/* Initailize -- */\n"];
        [buffer appendString:@"\tstruct VLParameters parameters_object;\n"];
        [buffer appendString:@"\tdouble dblTimeStart,dblTimeStop,dblTimeStep,dblTime;\n"];
        [buffer appendString:@"\tdouble *pStateArray;\n"];
        [buffer appendString:@"\tFILE *pSimulationOutputFile;\n"];
        [buffer appendString:@"\tchar *pSimulationOutputFilePath = argv[1];\t\t// Assign data output file\n"];
        [buffer appendString:@"\tchar *pInputParametersFile = argv[2];\t\t// Get kinetics datafile path \n"];
        [buffer appendString:@"\tchar *pInputInitialConditionsFile = argv[3];\t\t\t// Get ic datafile patah\n"];
        [buffer appendString:@"\tchar *pStoichiometricMatrixFile = argv[4];\t\t\t// Get stoichiometric matrix path \n"];
        [buffer appendString:@"\tchar *pCirculationMatrixFile = argv[5];\t\t\t// Get circulation matrix path \n"];
        [buffer appendString:@"\tchar *pVolumeVectorFile = argv[6];\t\t\t// Get circulation matrix path \n"];
        [buffer appendString:@"\tsscanf(argv[7], \"%lf\", &dblTimeStart);\t\t// Start time\n"];
        [buffer appendString:@"\tsscanf(argv[8], \"%lf\", &dblTimeStop);\t\t// Stop time\n"];
        [buffer appendString:@"\tsscanf(argv[9], \"%lf\", &dblTimeStep);\t\t\t// Time step size\n\n"];
        NEW_LINE;
        [buffer appendString:@"\t/* Allocate space for the system parameters -- */\n"];
        [buffer appendString:@"\tparameters_object.pModelKineticsParameterVector = gsl_vector_alloc(NUMBER_OF_PARAMETERS);\n"];
        [buffer appendString:@"\tparameters_object.pModelVolumeVector = gsl_vector_alloc(NUMBER_OF_COMPARTMENTS);\n"];
        [buffer appendString:@"\tparameters_object.pModelCirculationMatrix = gsl_matrix_alloc(NUMBER_OF_STATES,NUMBER_OF_STATES);\n"];
        [buffer appendString:@"\tparameters_object.pModelStoichiometricMatrix = gsl_matrix_alloc(NUMBER_OF_STATES,NUMBER_OF_RATES);\n"];
        [buffer appendString:@"\tpStateArray = malloc(NUMBER_OF_STATES*sizeof(double));\n"];
        NEW_LINE;
        [buffer appendString:@"\t/* Load model parameters and matrices from disk  -- */\n"];
        [buffer appendString:@"\tpopulateGSLMatrixFromFile(pStoichiometricMatrixFile,parameters_object.pModelStoichiometricMatrix);\n"];
        [buffer appendString:@"\tpopulateGSLMatrixFromFile(pCirculationMatrixFile,parameters_object.pModelCirculationMatrix);\n"];
        [buffer appendString:@"\tpopulateGSLVectorFromFile(pInputParametersFile,parameters_object.pModelKineticsParameterVector);\n"];
        [buffer appendString:@"\tpopulateGSLVectorFromFile(pVolumeVectorFile,parameters_object.pModelVolumeVector);\n"];
        [buffer appendString:@"\tpopulateDoubleCArraryFromFile(pInputInitialConditionsFile,pStateArray);\n"];
        NEW_LINE;
        [buffer appendString:@"\t/* Setup the GSL solver  -- */\n"];
        [buffer appendString:@"\tconst gsl_odeiv2_step_type *pT = gsl_odeiv2_step_rk8pd;\n"];
        [buffer appendString:@"\tgsl_odeiv2_step *pStep = gsl_odeiv2_step_alloc(pT,NUMBER_OF_STATES);\n"];
        [buffer appendString:@"\tgsl_odeiv2_control *pControl = gsl_odeiv2_control_y_new(TOLERANCE,TOLERANCE);\n"];
        [buffer appendString:@"\tgsl_odeiv2_evolve *pEvolve = gsl_odeiv2_evolve_alloc(NUMBER_OF_STATES);\n"];
        [buffer appendString:@"\tgsl_odeiv2_system sys = {MassBalances,NULL,NUMBER_OF_STATES,&parameters_object};\n"];
        NEW_LINE;
        [buffer appendString:@"\t/* Open simulation output file  -- */\n"];
        [buffer appendString:@"\tpSimulationOutputFile = fopen(pSimulationOutputFilePath, \"w\");\n"];
        [buffer appendString:@"\tif (pSimulationOutputFile == NULL)\n"];
        [buffer appendString:@"\t{\n"];
        [buffer appendString:@"\t\tprintf(\"ERROR: Failed to open simulation output file.\\n\");\n"];
        [buffer appendString:@"\t\treturn(-1);\n"];
        [buffer appendString:@"\t}\n"];
        
        NEW_LINE;
        [buffer appendString:@"\t/* main simulation loop -- */\n"];
        [buffer appendString:@"\tdblTime = dblTimeStart;\n"];
        [buffer appendString:@"\twhile(dblTime<dblTimeStop)\n"];
        [buffer appendString:@"\t{\n"];
        [buffer appendString:@"\t\tint status = gsl_odeiv2_evolve_apply(pEvolve,pControl,pStep,&sys,&dblTime,dblTimeStop,&dblTimeStep,pStateArray);\n"];
        [buffer appendString:@"\t\tif (status != GSL_SUCCESS)\n"];
        [buffer appendString:@"\t\t{\n"];
        [buffer appendString:@"\t\t\tprintf(\"ODE Solver loop failed at t = %g\\n\", dblTime);\n"];
        [buffer appendString:@"\t\t\treturn(-1);\n"];
        [buffer appendString:@"\t\t}\n"];
        [buffer appendString:@"\t\telse\n"];
        [buffer appendString:@"\t\t{\n"];
        [buffer appendString:@"\t\t\twriteSimulationOutputRecord(pSimulationOutputFile,dblTime,pStateArray);\n"];
        [buffer appendString:@"\t\t}\n"];
        [buffer appendString:@"\t}\n"];
        NEW_LINE;
        
        // Free gsl data
        [buffer appendString:@"\t/* clean up -- */\n"];
        [buffer appendString:@"\tgsl_vector_free(parameters_object.pModelKineticsParameterVector);\n"];
        [buffer appendString:@"\tgsl_matrix_free(parameters_object.pModelCirculationMatrix);\n"];
        [buffer appendString:@"\tgsl_matrix_free(parameters_object.pModelStoichiometricMatrix);\n"];
        [buffer appendString:@"\tfree(pStateArray);\n"];
        [buffer appendString:@"\tfclose(pSimulationOutputFile);\n"];
        NEW_LINE;
        
        [buffer appendString:@"\treturn 0;\n"];
        [buffer appendString:@"}\n"];
        
        NEW_LINE;
        [buffer appendString:@"/* Helper functions -- */\n"];
        [buffer appendString:@"static void populateGSLMatrixFromFile(const char* pFilename, gsl_matrix *pGSLMatrix)\n"];
        [buffer appendString:@"{\n"];
        [buffer appendString:@"\tFILE *pFile = fopen(pFilename,\"r\");\n"];
        [buffer appendString:@"\tgsl_matrix_fscanf(pFile,pGSLMatrix);\n"];
        [buffer appendString:@"\tfclose(pFile);\n"];
        [buffer appendString:@"}\n"];
        NEW_LINE;
        
        [buffer appendString:@"static void populateGSLVectorFromFile(const char* pFilename, gsl_vector *pGSLVector)\n"];
        [buffer appendString:@"{\n"];
        [buffer appendString:@"\tFILE *pFile = fopen(pFilename,\"r\");\n"];
        [buffer appendString:@"\tgsl_vector_fscanf(pFile,pGSLVector);\n"];
        [buffer appendString:@"\tfclose(pFile);\n"];
        [buffer appendString:@"}\n"];
        NEW_LINE;
        
        [buffer appendString:@"static void populateDoubleCArraryFromFile(const char* pFilename,double *pDoubleArray)\n"];
        [buffer appendString:@"{\n"];
        [buffer appendString:@"\tgsl_vector *tmp = gsl_vector_alloc(NUMBER_OF_STATES);\n"];
        [buffer appendString:@"\tFILE *pFile = fopen(pFilename,\"r\");\n"];
        [buffer appendString:@"\tgsl_vector_fscanf(pFile, tmp);\n"];
        [buffer appendString:@"\tfclose(pFile);\n\n"];
        [buffer appendString:@"\tfor (int state_index=0; state_index<NUMBER_OF_STATES; state_index++)\n"];
        [buffer appendString:@"\t{\n"];
        [buffer appendString:@"\t\t*(pDoubleArray + state_index) = gsl_vector_get(tmp,state_index);\n"];
        [buffer appendString:@"\t}\n"];
        [buffer appendString:@"\tgsl_vector_free(tmp);\n"];
        [buffer appendString:@"}\n"];
        NEW_LINE;
        
        [buffer appendString:@"static void writeSimulationOutputRecord(FILE *output_file,double time,double *pDoubleResultsArray)\n"];
        [buffer appendString:@"{\n"];
        [buffer appendString:@"\tfprintf(output_file,\"%g \",time);\n"];
        [buffer appendString:@"\tfor (int state_index=0; state_index<NUMBER_OF_STATES; state_index++)\n"];
        [buffer appendString:@"\t{\n"];
        [buffer appendString:@"\t\tdouble tmp_state_value = *(pDoubleResultsArray + state_index);\n"];
        NEW_LINE;
        [buffer appendString:@"\t\t/* correct for negavtives */\n"];
        [buffer appendString:@"\t\tif (tmp_state_value<0)\n"];
        [buffer appendString:@"\t\t{\n"];
        [buffer appendString:@"\t\t\ttmp_state_value = 0.0;\n"];
        [buffer appendString:@"\t\t}\n"];
        NEW_LINE;
        [buffer appendString:@"\t\tfprintf(output_file,\"%g \",tmp_state_value);\n"];
        [buffer appendString:@"\t}\n"];
        [buffer appendString:@"\tfprintf(output_file,\"\\n\");\n"];
        [buffer appendString:@"}\n"];
    }
 
    
    return buffer;
}

@end
