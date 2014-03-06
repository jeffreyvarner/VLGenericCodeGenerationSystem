//
//  VLSahredUtilitiesOutputHandler.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/25/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLSharedUtilitiesOutputHandler.h"

@implementation VLSharedUtilitiesOutputHandler

static const NSString *kStoichiometricCoefficient = @"STOICHIOMETRIC_COEFFICIENT";

-(id)generateStoichiometricMatrixActionWithOptions:(NSDictionary *)options
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
    
    // What is my model encoding?
    NSString *model_source_encoding = [[[input_tree nodesForXPath:@".//model/@source_encoding" error:nil] lastObject] stringValue];
    
    if ([model_source_encoding isEqualToString:kSourceEncodingVFF] == YES)
    {
        // need to build the stm array -
        // ok, so we have to write *each* balance equation out by hand (not the compact form) -
        NSString *xpathString = @"//species";
        NSArray *list_of_species = [input_tree nodesForXPath:xpathString error:nil];
        for (NSXMLElement *species_node in list_of_species)
        {
            // get the symbol -
            NSString *raw_symbol = [[species_node attributeForName:@"symbol"] stringValue];
            if ([raw_symbol isEqualToString:@"[]"] == NO)
            {
                // get my list of interactions -
                NSArray *reaction_array = [input_tree nodesForXPath:@".//interaction" error:nil];
                for (NSXMLElement *reaction_node in reaction_array)
                {
                    // Get the reactant and product strings -
                    NSString *reactant_string = [[[reaction_node nodesForXPath:@"./interaction_input/@reaction_string" error:nil] lastObject] stringValue];
                    NSString *product_string = [[[reaction_node nodesForXPath:@"./interaction_output/@reaction_string" error:nil] lastObject] stringValue];
                    
                    // is this species a involved in this reaction as a reactant?
                    NSDictionary *reactant_dictionary = [self evaluateSpeciesSymbol:raw_symbol inReactionString:reactant_string];
                    NSDictionary *product_dictionary = [self evaluateSpeciesSymbol:raw_symbol inProductString:product_string];
                    
                    // if *both* the reactant and product dictionaries are nil, then *not* involved in this reaction
                    if (reactant_dictionary == nil && product_dictionary == nil)
                    {
                        [buffer appendString:@" 0.0 "];
                    }
                    else if (reactant_dictionary !=nil && product_dictionary == nil)
                    {
                        NSString *stcoeff = [reactant_dictionary objectForKey:kStoichiometricCoefficient];
                        [buffer appendFormat:@" %@ ",stcoeff];
                    }
                    else if (reactant_dictionary == nil && product_dictionary != nil)
                    {
                        NSString *stcoeff = [product_dictionary objectForKey:kStoichiometricCoefficient];
                        [buffer appendFormat:@" %@ ",stcoeff];
                    }
                }
                
                // next row -
                [buffer appendString:@"\n"];
            }
        }
    }
    else if ([model_source_encoding isEqualToString:kSourceEncodingSBML] == YES)
    {
        NSString *xpathString = @".//species";
        NSArray *list_of_species = [input_tree nodesForXPath:xpathString error:nil];
        for (NSXMLElement *species_node in list_of_species)
        {
            // get the symbol -
            NSString *raw_symbol = [[species_node attributeForName:@"id"] stringValue];
            if ([raw_symbol isEqualToString:@"[]"] == NO)
            {
                // Get the reactant products -
                NSArray *reaction_array = [input_tree nodesForXPath:@".//reaction" error:nil];
                for (NSXMLElement *reaction_node in reaction_array)
                {
                    // for this reaction - what are the reactants?
                    NSString *xpath_reactant = [NSString stringWithFormat:@"./listOfReactants/speciesReference[@species='%@']/@stoichiometry",raw_symbol];
                    NSString *stcoeff_reactant = [[[reaction_node nodesForXPath:xpath_reactant error:nil] lastObject] stringValue];
                    
                    // for this reaction - what are the products?
                    NSString *xpath_product = [NSString stringWithFormat:@"./listOfProducts/speciesReference[@species='%@']/@stoichiometry",raw_symbol];
                    NSString *stcoeff_product = [[[reaction_node nodesForXPath:xpath_product error:nil] lastObject] stringValue];

                    // ok - if we have *no* stcoeff, then 0.0
                    if (stcoeff_reactant == nil &&
                        stcoeff_product == nil)
                    {
                        [buffer appendString:@" 0.0 "];
                    }
                    else if (stcoeff_reactant != nil &&
                             stcoeff_product == nil)
                    {
                        [buffer appendFormat:@" -%@ ",stcoeff_reactant];
                    }
                    else if (stcoeff_reactant == nil &&
                             stcoeff_product != nil)
                    {
                        [buffer appendFormat:@" %@ ",stcoeff_product];
                    }
                    else if (stcoeff_reactant == nil &&
                             stcoeff_product != nil)
                    {
                        // ok - would this ever happen?
                        // ...
                    }
                }
            }
            
            // next row -
            [buffer appendString:@"\n"];
        }
    }
    
    // write -
    [self writeCodeGenerationOutput:buffer toFileWithOptions:options];
    
    // return -
    return buffer;
}

#pragma mark - private helper methods
-(NSDictionary *)evaluateSpeciesSymbol:(NSString *)symbol inReactionString:(NSString *)reactionString
{
    // dictionary -
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    
    // process each string -
    // is the symbol a reactant?
    NSArray *plus_components_array = [reactionString componentsSeparatedByString:@"+"];
    for (NSString *component in plus_components_array)
    {
        // ok, do we have a *?
        NSArray *star_components_array = [component componentsSeparatedByString:@"*"];
        if ([star_components_array count] == 1)
        {
            // ok, we have *only* the species - no stcoeff
            // if this matches with symbol, then we a match -
            NSString *test_symbol = [star_components_array lastObject];
            if ([symbol isEqualToString:test_symbol] == YES)
            {
                // ok, we have a match -
                [dictionary setObject:@"-1.0" forKey:kStoichiometricCoefficient];
                
                // return -
                return [NSDictionary dictionaryWithDictionary:dictionary];
            }
        }
        else
        {
            // ok, we have x*symbol structure -
            // Before we grab the coefficient, we need to see if this is the correct species -
            NSString *test_symbol = [star_components_array lastObject];
            if ([symbol isEqualToString:test_symbol] == YES)
            {
                // ok, we have the correct species -
                NSString *stcoeff = [star_components_array objectAtIndex:0];
                NSString *direction_stcoeff = [NSString stringWithFormat:@"-%@",stcoeff];
                
                // ok, we have a match -
                [dictionary setObject:direction_stcoeff forKey:kStoichiometricCoefficient];
                
                // return -
                return [NSDictionary dictionaryWithDictionary:dictionary];
            }
        }
    }
    
    // return -
    return nil;
}

-(NSDictionary *)evaluateSpeciesSymbol:(NSString *)symbol inProductString:(NSString *)productString
{
    // dictionary -
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    
    // process each string -
    // is the symbol a reactant?
    NSArray *plus_components_array = [productString componentsSeparatedByString:@"+"];
    for (NSString *component in plus_components_array)
    {
        // ok, do we have a *?
        NSArray *star_components_array = [component componentsSeparatedByString:@"*"];
        if ([star_components_array count] == 1)
        {
            // ok, we have *only* the species - no stcoeff
            // if this matches with symbol, then we a match -
            NSString *test_symbol = [star_components_array lastObject];
            if ([symbol isEqualToString:test_symbol] == YES)
            {
                // ok, we have a match -
                [dictionary setObject:@"1.0" forKey:kStoichiometricCoefficient];
                
                // return -
                return [NSDictionary dictionaryWithDictionary:dictionary];
            }
        }
        else
        {
            // ok, we have x*symbol structure -
            // Before we grab the coefficient, we need to see if this is the correct species -
            NSString *test_symbol = [star_components_array lastObject];
            if ([symbol isEqualToString:test_symbol] == YES)
            {
                // ok, we have the correct species -
                NSString *stcoeff = [star_components_array objectAtIndex:0];
                
                // ok, we have a match -
                [dictionary setObject:stcoeff forKey:kStoichiometricCoefficient];
                
                // return -
                return [NSDictionary dictionaryWithDictionary:dictionary];
            }
        }
    }
    
    // return -
    return nil;
}


@end
