//
//  VLOctaveCBalanceEquationsMassActionModelStrategy.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/25/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLOctaveCBalanceEquationsMassActionModelStrategy.h"

@implementation VLOctaveCBalanceEquationsMassActionModelStrategy

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
    
    // What is my model type?
    NSString *model_type_xpath = @"./Model/@type";
    NSString *typeString = [[[input_tree nodesForXPath:model_type_xpath error:nil] lastObject] stringValue];
    
    // What is my function name?
    NSString *fname_xpath = @"./output_handler/transformation_property[@type=\"FUNCTION_NAME\"]/@value";
    NSString *tmpFunctionName = [[[transformation nodesForXPath:fname_xpath error:nil] lastObject] stringValue];
    
    // add the copyright statement -
    NSString *copyright_xpath = @".//properties/property[@symbol=\"COPYRIGHT_TEXT\"]/@value";
    NSString *copyright_file_path = [[[transformation_tree nodesForXPath:copyright_xpath error:nil] lastObject] stringValue];
    NSArray *copyright_buffer = [VLCoreUtilitiesLib loadCopyrightFileAtPath:copyright_file_path];

    [self addCopyrightStatement:copyright_buffer toBuffer:buffer];
    
    // Build the prototype and import buffer -
    NSString *tmpPrototype = [self formulateFunctionPrototypeBufferWithOptions:options];
    [buffer appendString:tmpPrototype];
    [buffer appendString:@"\n"];
    
    // Build the main block -
    NSString *tmpMainBlock = [self formulateMainBlockBufferWithOptions:options];
    [buffer appendString:tmpMainBlock];
    [buffer appendString:@"\n"];
    
    // alias the species -
    NSString *kinetics_block = [self formulateKineticsBlockWithOptions:options];
    [buffer appendString:kinetics_block];
    [buffer appendString:@"\n"];
    
    // mass balances -
    NSString *balances_block = [self formulateMassBalanceEquationsBlockWithOptions:options];
    [buffer appendString:balances_block];
    [buffer appendString:@"\n"];
    
    // return the buffer --
    return buffer;
}


#pragma mark - private helper methods
-(NSString *)formulateFunctionPrototypeBufferWithOptions:(NSDictionary *)dictionary
{
    // Initialize -
    NSMutableString *tmpBuffer = [NSMutableString string];
    
    // Inlcude statements --
    [tmpBuffer appendString:@"#include <octave/oct.h>\n"];
    [tmpBuffer appendString:@"#include <ov-struct.h>\n"];
    [tmpBuffer appendString:@"#include <iostream>\n"];
    [tmpBuffer appendString:@"#include <math.h>\n"];
    [tmpBuffer appendString:@"\n"];
    
    // Function prototypes -
    [tmpBuffer appendString:@"// Function prototypes - \n"];
    [tmpBuffer appendString:@"void calculateKinetics(ColumnVector&,ColumnVector&,ColumnVector&);\n"];
    [tmpBuffer appendString:@"void calculateMassBalances(int,int,Matrix&,ColumnVector&,ColumnVector&);\n"];
    [tmpBuffer appendString:@"\n"];
    
    // return -
    return tmpBuffer;
}

-(NSString *)formulateMainBlockBufferWithOptions:(NSDictionary *)options
{
    // Initialize -
    NSMutableString *tmpBuffer = [NSMutableString string];
    
    // Get our trees from the dictionary -
    NSXMLDocument *transformation_tree = [options objectForKey:@"TRANSFORMATION_TREE"];
    NSXMLElement *transformation = [options objectForKey:@"TRANSFORMATION_XML_ELEMENT"];
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:@"INPUT_DATA_TREE"];
    
    // What is my model type?
    NSString *model_type_xpath = @"./Model/@type";
    NSString *typeString = [[[input_tree nodesForXPath:model_type_xpath error:nil] lastObject] stringValue];
    
    // What is my function name?
    NSString *fname_xpath = @"./output_handler/transformation_property[@type=\"FUNCTION_NAME\"]/@value";
    NSString *tmpFunctionName = [[[transformation nodesForXPath:fname_xpath error:nil] lastObject] stringValue];
    
    // Main block -
    [tmpBuffer appendFormat:@"DEFUN_DLD(%@,args,nargout,\"Calculate the mass balances.\")\n",tmpFunctionName];
    [tmpBuffer appendString:@"{\n"];
    [tmpBuffer appendString:@"\t// Initialize variables --\n"];
    [tmpBuffer appendString:@"\tColumnVector xV(args(0).vector_value());        // Get the state vector (index 0);\n"];
    [tmpBuffer appendString:@"\tMatrix STMATRIX(args(2).matrix_value());        // Get the stoichiometric matrix;\n"];
    [tmpBuffer appendString:@"\tColumnVector kVM(args(3).vector_value());		// Rate constant vector;\n"];
    [tmpBuffer appendString:@"\tconst int NRATES = args(4).int_value();         // Number of rates\n"];
    [tmpBuffer appendString:@"\tconst int NSTATES = args(5).int_value();        // Number of states\n"];
    [tmpBuffer appendString:@"\tColumnVector rV=ColumnVector(NRATES);           // Setup the rate vector;\n"];
    [tmpBuffer appendString:@"\tColumnVector dx = ColumnVector(NSTATES);        // dxdt vector;\n"];
    [tmpBuffer appendString:@"\n"];
    [tmpBuffer appendString:@"\t// Calculate the kinetics -- \n"];
    [tmpBuffer appendString:@"\tcalculateKinetics(kVM,xV,rV);\n"];
    [tmpBuffer appendString:@"\n"];
    [tmpBuffer appendString:@"\t// Calculate the mass balance equations --\n"];
    [tmpBuffer appendString:@"\tcalculateMassBalances(NRATES,NSTATES,STMATRIX,rV,dx);\n"];
    [tmpBuffer appendString:@"\n"];
    [tmpBuffer appendString:@"\t// return the mass balances --\n"];
    [tmpBuffer appendString:@"\treturn octave_value(dx);\n"];
    [tmpBuffer appendString:@"};\n"];
    
    // return -
    return tmpBuffer;
}

-(NSString *)formulateMassBalanceEquationsBlockWithOptions:(NSDictionary *)options
{
    // Initialize the buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // Get our trees from the dictionary -
    __unused NSXMLDocument *transformation_tree = [options objectForKey:@"TRANSFORMATION_TREE"];
    __unused NSXMLElement *transformation = [options objectForKey:@"TRANSFORMATION_XML_ELEMENT"];
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:@"INPUT_DATA_TREE"];
    
    // Are we generating sparse balances?
    NSString *compact_balances_xpath = @"./output_handler/transformation_property[@type=\"COMPACT_BALANCE_MODE\"]/@value";
    NSString *compact_form = [[[transformation nodesForXPath:compact_balances_xpath error:nil] lastObject] stringValue];
    
    // build the buffer -
    [buffer appendString:@"void calculateMassBalances(int NRATES,int NSTATES,Matrix& STMATRIX,ColumnVector& rV,ColumnVector& dx)\n"];
    [buffer appendString:@"{\n"];
    
    
    if ([compact_form isLike:@"TRUE"] == YES)
    {
        [buffer appendString:@"\t// Write the mass balance equations (compact form) -- \n"];
        [buffer appendFormat:@"\tdx=STMATRIX*rV;\n"];
        [buffer appendFormat:@"\n"];
    }
    else
    {
        // ok, so we have to write *each* balance equation out by hand (not the compact form) -
        NSString *xpathString = @"//species";
        NSArray *list_of_species = [input_tree nodesForXPath:xpathString error:nil];
        NSUInteger counter = 0;
        for (NSXMLElement *species_node in list_of_species)
        {
            // get the symbol -
            NSString *raw_symbol = [[species_node attributeForName:@"symbol"] stringValue];
            if ([raw_symbol isEqualToString:@"[]"] == NO)
            {
                // start -
                [buffer appendFormat:@"\tdx(%lu,0) = ",counter++];
                
                // consumption fragment -
                NSString *consumption_fragment = [self formulateConsumptionReactionsForSpecies:raw_symbol withOptions:options];
                NSString *production_fragment = [self formulateProductReactionsForSpecies:raw_symbol withOptions:options];
                [buffer appendFormat:@"%@%@;\t// %@ \n",production_fragment,consumption_fragment,raw_symbol];
            }
        }
    }
    
    [buffer appendString:@"}\n"];

    return buffer;
}

-(NSString *)formulateProductReactionsForSpecies:(NSString *)raw_symbol withOptions:(NSDictionary *)options
{
    
    // get my input tree -
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:@"INPUT_DATA_TREE"];
    
    // Initialize the buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // Next, check products -
    NSString *xpath_products = [NSString stringWithFormat:@".//interaction/interaction_output[contains(@reaction_string, '%@')]",raw_symbol];
    NSArray *reaction_node_array = [input_tree nodesForXPath:xpath_products error:nil];
    for (NSXMLElement *reaction_node in reaction_node_array)
    {
        // What is my parent node?
        NSXMLElement *parent_node = (NSXMLElement *)[reaction_node parent];
        
        // What index do I have?
        NSString *reaction_index = [[parent_node attributeForName:@"index"] stringValue];
        
        // ok, do we have a +?
        NSString *raw_reactant_string = [[reaction_node attributeForName:@"reaction_string"] stringValue];
        NSArray *plus_fragments = [raw_reactant_string componentsSeparatedByString:@"+"];
        if ([plus_fragments count] == 1 &&
            [raw_reactant_string isEqualToString:raw_symbol] == YES)
        {
            // if this array is empty, then we are *first* order -
            // Do we have a *?
            NSArray *star_fragments = [raw_reactant_string componentsSeparatedByString:@"*"];
            if ([star_fragments count] == 1)
            {
                // no st coeff -
                [buffer appendFormat:@"+1.0*rV(%@,0) ",reaction_index];
            }
            else
            {
                // we have a st coeff -
                NSString *stcoeff = [star_fragments objectAtIndex:0];
                [buffer appendFormat:@"+%@*rV(%@,0) ",stcoeff,reaction_index];
            }
        }
        else
        {
            // if this array is *not* empty, then we have at least *second* order -
            for (NSString *local_raw_species_symbol in plus_fragments)
            {
                // Do we have a *?
                NSArray *star_fragments = [local_raw_species_symbol componentsSeparatedByString:@"*"];
                if ([star_fragments count] == 1)
                {
                    // nope - just a straight up symbol. Is this me?
                    if ([local_raw_species_symbol isEqualToString:raw_symbol] == YES)
                    {
                        // no st coeff -
                        [buffer appendFormat:@"+1.0*rV(%@,0) ",reaction_index];
                    }
                }
                else
                {
                    // ok, so this symbol had a * - cut it off, and then do the test -
                    if ([[star_fragments lastObject] isEqualToString:raw_symbol] == YES)
                    {
                        // we have a st coeff -
                        NSString *stcoeff = [star_fragments objectAtIndex:0];
                        [buffer appendFormat:@"+%@*rV(%@,0) ",stcoeff,reaction_index];
                    }
                }
            }
        }
    }

    return buffer;
}

-(NSString *)formulateConsumptionReactionsForSpecies:(NSString *)raw_symbol withOptions:(NSDictionary *)options
{
    // get my input tree -
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:@"INPUT_DATA_TREE"];
    
    // Initialize the buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // What reactions does this symbol participate in?
    // First check *reactants* -
    NSString *xpath_reactants = [NSString stringWithFormat:@".//interaction/interaction_input[contains(@reaction_string, '%@')]",raw_symbol];
    NSArray *reaction_node_array = [input_tree nodesForXPath:xpath_reactants error:nil];
    for (NSXMLElement *reaction_node in reaction_node_array)
    {
        // What is my parent node?
        NSXMLElement *parent_node = (NSXMLElement *)[reaction_node parent];
        
        // What index do I have?
        NSString *reaction_index = [[parent_node attributeForName:@"index"] stringValue];
        
        // ok, do we have a +?
        NSString *raw_reactant_string = [[reaction_node attributeForName:@"reaction_string"] stringValue];
        NSArray *plus_fragments = [raw_reactant_string componentsSeparatedByString:@"+"];
        if ([plus_fragments count] == 1 &&
            [raw_reactant_string isEqualToString:raw_symbol])
        {
            // if this array has *one* item, then we are *first* order -
            // Do we have a *?
            NSArray *star_fragments = [raw_reactant_string componentsSeparatedByString:@"*"];
            if ([star_fragments count] == 1 )
            {
                // no st coeff -
                [buffer appendFormat:@"-1.0*rV(%@,0) ",reaction_index];
            }
            else
            {
                // we have a st coeff -
                NSString *stcoeff = [star_fragments objectAtIndex:0];
                [buffer appendFormat:@"-%@*rV(%@,0) ",stcoeff,reaction_index];
            }
        }
        else
        {
            // if this array is *not* empty, then we have at least *second* order -
            for (NSString *local_raw_species_symbol in plus_fragments)
            {
                // Do we have a *?
                NSArray *star_fragments = [local_raw_species_symbol componentsSeparatedByString:@"*"];
                if ([star_fragments count] == 1)
                {
                    // nope - just a straight up symbol. Is this me?
                    if ([local_raw_species_symbol isEqualToString:raw_symbol] == YES)
                    {
                        // no st coeff -
                        [buffer appendFormat:@"-1.0*rV(%@,0) ",reaction_index];
                    }
                }
                else
                {
                    // ok, so this symbol had a * - cut it off, and then do the test -
                    if ([[star_fragments lastObject] isEqualToString:raw_symbol] == YES)
                    {
                        // we have a st coeff -
                        NSString *stcoeff = [star_fragments objectAtIndex:0];
                        [buffer appendFormat:@"-%@*rV(%@,0) ",stcoeff,reaction_index];
                    }
                }
            }
        }
    }
    
    return buffer;
}

-(NSString *)formulateKineticsBlockWithOptions:(NSDictionary *)options
{
    // Initialize the buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // Get our trees from the dictionary -
    __unused NSXMLDocument *transformation_tree = [options objectForKey:@"TRANSFORMATION_TREE"];
    __unused NSXMLElement *transformation = [options objectForKey:@"TRANSFORMATION_XML_ELEMENT"];
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:@"INPUT_DATA_TREE"];
    
    // build the buffer -
    [buffer appendString:@"void calculateKinetics(ColumnVector& kV,ColumnVector& xV,ColumnVector& rV)\n"];
    [buffer appendString:@"{\n"];
    [buffer appendString:@"\t// Formulate the kinetics - \n"];
    [buffer appendString:@"\t// First alias the species symbols (helps with debugging)\n"];
    
    // Get the list of species from the tree -
    NSError *err = nil;
    NSString *xpathString = @"//species";
    NSArray *list_of_species = [input_tree nodesForXPath:xpathString error:&err];
    NSUInteger counter = 0;
    for (NSXMLElement *species_node in list_of_species)
    {
        // get the symbol -
        NSString *raw_symbol = [[species_node attributeForName:@"symbol"] stringValue];
        if ([raw_symbol isEqualToString:@"[]"] == NO)
        {
            NSString *symbol = [raw_symbol stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
            
            // alias species -
            [buffer appendFormat:@"\tfloat %@ = xV(%ld,0);\t// compartment: %@\n",symbol,counter,@"MODEL"];
            
            // update the counter
            counter = counter + 1;
        }
    }
    
    [buffer appendString:@"\n"];
    
    // rates -
    [buffer appendString:@"\t// Next calculate the rates - \n"];
    NSArray *reactionArray = [input_tree nodesForXPath:@".//interaction" error:nil];
    counter = 0;
    for (NSXMLElement *reaction_node in reactionArray)
    {
        NSString *raw_reactant_string = [[[reaction_node nodesForXPath:@"./interaction_input/@reaction_string" error:nil] lastObject] stringValue];
        
        // split the string around +
        NSMutableArray *local_species_array = [[NSMutableArray alloc] init];
        NSMutableArray *local_order_array = [[NSMutableArray alloc] init];
        [local_species_array addObjectsFromArray:[raw_reactant_string componentsSeparatedByString:@"+"]];
        
        // go through the array -
        for (NSString *species in local_species_array)
        {
            if ([species isEqualToString:@"[]"] == NO)
            {
                // do we have a stoichiometric coefficient?
                NSRange range = [species rangeOfString:@"*" options:NSCaseInsensitiveSearch];
                if (range.location != NSNotFound)
                {
                    // ok, so we have a stoichiometric coefficient -
                    NSArray *split_components = [species componentsSeparatedByString:@"*"];
                    
                    // the species symbol will be the *last* object in the array -
                    [local_order_array addObject:[split_components lastObject]];
                }
                else
                {
                    // no stoichometric coefficients -
                    [local_order_array addObject:species];
                }
            }
        }
        
        // ok, build the line -
        [buffer appendFormat:@"\trV(%lu,0) = kV(%lu,0)",counter,counter];
        
        // process the species -
        if ([local_order_array count] == 0)
        {
            // *no* species - zero order - we are done;
            [buffer appendString:@";\n"];
        }
        else
        {
            NSInteger MAX_LOCAL_SPECIES_COUNT = [local_order_array count];
            for (NSInteger local_species_index = 0;local_species_index<MAX_LOCAL_SPECIES_COUNT;local_species_index++)
            {
                NSString *raw_species_symbol = [local_order_array objectAtIndex:local_species_index];
                NSString *species_symbol = [raw_species_symbol stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
                [buffer appendFormat:@"*%@",species_symbol];
                
                if (local_species_index == (MAX_LOCAL_SPECIES_COUNT - 1))
                {
                    [buffer appendString:@";\n"];
                }
            }
        }
        
        // update counter -
        counter++;
    }
    
    [buffer appendString:@"\n"];
    [buffer appendString:@"}\n"];
    
    // return -
    return buffer;
}

#pragma mark - override the copyright statement
-(void)addCopyrightStatement:(NSArray *)statement toBuffer:(NSMutableString *)buffer
{
    // first line -
    [buffer appendString:@"// ------------------------------------------------------------------------------------ %\n"];
    
    for (NSString *line in statement)
    {
        [buffer appendFormat:@"// %@ \n",line];
    }
    
    // close -
    [buffer appendString:@"// ------------------------------------------------------------------------------------ %\n"];
}


@end
