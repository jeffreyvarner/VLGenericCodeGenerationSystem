//
//  VLOctaveCGenericDriverSolveBalancesEquationsStrategy.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/27/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLOctaveCGenericDriverSolveBalancesEquationsStrategy.h"

@implementation VLOctaveCGenericDriverSolveBalancesEquationsStrategy

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
    
    // Get some specific stuff from the trees -
    // What is my function name?
    NSString *fname_xpath = @"./output_handler/transformation_property[@type=\"FUNCTION_NAME\"]/@value";
    NSString *tmpFunctionName = [[[transformation nodesForXPath:fname_xpath error:nil] lastObject] stringValue];
    
    // I need to load the copyright block -
    NSString *copyright_xpath = @".//properties/property[@symbol=\"COPYRIGHT_TEXT\"]/@value";
    NSString *copyright_file_path = [[[transformation_tree nodesForXPath:copyright_xpath error:nil] lastObject] stringValue];
    NSArray *copyright_buffer = [VLCoreUtilitiesLib loadCopyrightFileAtPath:copyright_file_path];
    
    // build the buffer -
    [self addCopyrightStatement:copyright_buffer toBuffer:buffer];
    
    // Write the function block -
    [buffer appendFormat:@"function [TSIM,X,OUTPUT] = %@(pDataFile,TSTART,TSTOP,Ts,DFIN)",tmpFunctionName];
    [buffer appendString:@"\n"];
    
    // Add the DF check -
    NSString *tmpDFCheck = [self formulateDataFileCheckWithDictionary:options];
    [buffer appendString:tmpDFCheck];
    [buffer appendString:@"\n"];
    
    // Formulate the input block -
    NSString *tmpInputBlock = [self formulateInputBlockWithDictionary:options];
    [buffer appendString:tmpInputBlock];
    [buffer appendString:@"\n"];
    
    // Write the solver block -
    NSString *tmpSolverBlock = [self formulateSolverBlockWithDictionary:options];
    [buffer appendString:tmpSolverBlock];
    [buffer appendString:@"\n"];
    
    // write the return block -
    [buffer appendString:@"% return to caller -- \n"];
    [buffer appendString:@"return;\n"];
    
    return buffer;
}

#pragma mark - private
-(NSString *)formulateInputBlockWithDictionary:(NSDictionary *)dictionary
{
    // Initialize -
    NSMutableString *tmpBuffer = [NSMutableString string];
    
    // Formulat the block where we get stuff from the DF -
    [tmpBuffer appendString:@"% Get reqd stuff from data struct -- \n"];
    [tmpBuffer appendString:@"IC = DF.INITIAL_CONDITION_VECTOR;\n"];
    [tmpBuffer appendString:@"TSIM = TSTART:Ts:TSTOP;\n"];
    [tmpBuffer appendString:@"S = DF.STOICHIOMETRIC_MATRIX;\n"];
    [tmpBuffer appendString:@"kV = DF.PARAMETER_VECTOR;\n"];
    [tmpBuffer appendString:@"NUMBER_OF_RATES = DF.NUMBER_OF_RATES;\n"];
    [tmpBuffer appendString:@"NUMBER_OF_STATES = DF.NUMBER_OF_STATES;\n"];
    [tmpBuffer appendString:@"MEASUREMENT_INDEX_VECTOR = DF.MEASUREMENT_SELECTION_VECTOR;\n"];
    
    // return -
    return tmpBuffer;
}

-(NSString *)formulateDataFileCheckWithDictionary:(NSDictionary *)dictionary
{
    // Initialize -
    NSMutableString *tmpBuffer = [NSMutableString string];
    
    // Formulate the check -
    [tmpBuffer appendString:@"% Check to see if I need to load the datafile -- \n"];
    [tmpBuffer appendString:@"if (~isempty(DFIN))\n"];
    [tmpBuffer appendString:@"\tDF = DFIN;\n"];
    [tmpBuffer appendString:@"else\n"];
    [tmpBuffer appendString:@"\tDF = feval(pDataFile,TSTART,TSTOP,Ts,[]);\n"];
    [tmpBuffer appendString:@"end;\n"];
    
    // return -
    return tmpBuffer;
}

-(NSString *)formulateSolverBlockWithDictionary:(NSDictionary *)dictionary
{
    // Initialize -
    NSMutableString *tmpBuffer = [NSMutableString string];
    
    [tmpBuffer appendString:@"% Solve the mass balances using LSODE -- \n"];
    [tmpBuffer appendString:@"pBalanceEquations = @(x,t)BalanceEquations(x,t,S,kV,NUMBER_OF_RATES,NUMBER_OF_STATES);\n"];
	[tmpBuffer appendString:@"X = lsode(pBalanceEquations,IC,TSIM);\n"];
    [tmpBuffer appendString:@"\n"];
    [tmpBuffer appendString:@"% make sure all is positive - \n"];
    [tmpBuffer appendString:@"X = abs(X);\n"];
    [tmpBuffer appendString:@"\n"];
    [tmpBuffer appendString:@"% Calculate the output - \n"];
    [tmpBuffer appendString:@"OUTPUT = X(:,MEASUREMENT_INDEX_VECTOR);\n"];
    
    // return -
    return tmpBuffer;
}

#pragma mark - override the copyright statement
-(void)addCopyrightStatement:(NSArray *)statement toBuffer:(NSMutableString *)buffer
{
    // first line -
    [buffer appendString:@"% ------------------------------------------------------------------------------------ %\n"];
    
    for (NSString *line in statement)
    {
        [buffer appendFormat:@"\%% %@ \n",line];
    }
    
    // close -
    [buffer appendString:@"% ------------------------------------------------------------------------------------ %\n"];
}


@end
