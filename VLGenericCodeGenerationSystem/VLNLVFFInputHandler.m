//
//  VLNLVFFInputHandler.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 4/27/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLNLVFFInputHandler.h"

#define NEW_LINE [buffer appendString:@"\n"]

@implementation VLNLVFFInputHandler

#pragma mark - override this
-(id)performVLGenericCodeGenerationInputActionWithOptions:(NSDictionary *)options
{
    
    
    // Get tree's from dictionary -
    NSXMLDocument *transformation_tree = [options objectForKey:kXMLTransformationTree];
    NSXMLElement *transformation = [options objectForKey:kXMLTransformationElement];
    
    // Lookup global properties -
    NSString *working_directory = [[[transformation_tree nodesForXPath:@".//property[@symbol='WORKING_DIRECTORY']/@value" error:nil] lastObject] stringValue];
    NSString *model_type = [[[transformation_tree nodesForXPath:@"/Model/@type" error:nil] lastObject] stringValue];
    
    
    // What is the file name?
    NSString *file_path_fragment = [[[transformation nodesForXPath:@"./input_handler/transformation_property[@type='PATH']/@value" error:nil] lastObject] stringValue];
    
    // build full path -
    NSString *path_to_vff_file = nil;
    if (working_directory == nil)
    {
        path_to_vff_file = [NSString stringWithFormat:@"%@",file_path_fragment];
    }
    else
    {
        path_to_vff_file = [NSString stringWithFormat:@"%@%@",working_directory,file_path_fragment];
    }
    
    // Loads the VFF as an array of arrays -
    NSArray *vff_components_array = [VLCoreUtilitiesLib loadGenericFlatFile:path_to_vff_file
                                                      withRecordDeliminator:@"\n"
                                                       withFieldDeliminator:@"="];

    
    // ok, we've loaded the file -
    NSXMLDocument *document = [self convertNLVFFToCannonicalTree:vff_components_array
                                                    forModelType:model_type];
    
    // return -
    return document;
}

-(NSXMLDocument *)convertNLVFFToCannonicalTree:(NSArray *)componentArray forModelType:(NSString *)modelType
{
    // build XML string buffer, create document and return -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // header -
    [buffer appendString:@"<?xml version=\"1.0\" standalone=\"yes\"?>\n"];
    [buffer appendFormat:@"<model type='%@' source_encoding='NLVFF'>\n",modelType];
    
    // build list of species -
    [buffer appendString:@"\t<listOfSpecies>\n"];
    
    NSMutableArray *speciesArray = [[NSMutableArray alloc] init];
    for (NSArray *array in componentArray)
    {
        NSString *raw_species = [[array lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        // first, we need to skip []
        if ([raw_species isEqualToString:@"[]"] == NO)
        {
            // Strip any parenthesis -
            NSString *raw_species_2 = [raw_species stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];
            
            // Is this a compound species?
            NSArray *compound_species_list = [raw_species_2 componentsSeparatedByString:@","];
            for (NSString *species_symbol in compound_species_list)
            {
                
                if ([speciesArray containsObject:species_symbol] == NO)
                {
                    [speciesArray addObject:species_symbol];
                }
            }
        }
    }
    
    // read back out -
    for (NSString *species in speciesArray)
    {
        [buffer appendFormat:@"<species id='%@' name='%@' compartment='MODEL' initialAmount='0.0'/>\n",species,species];
    }
    [buffer appendString:@"\t</listOfSpecies>\n"];
    NEW_LINE;
    
    // build list of reactions -
    [buffer appendString:@"\t<listOfReactions>\n"];
    NSArray *reaction_array = [self constructListOfReactionsFromVFFComponents:componentArray];
    for (NSString *reaction_string in reaction_array)
    {
        [buffer appendString:reaction_string];
    }
    [buffer appendString:@"\t</listOfReactions>\n"];
    
    // close -
    [buffer appendString:@"</model>\n"];
    
    // Build document -
    NSXMLDocument *document = [[NSXMLDocument alloc] initWithXMLString:[NSString stringWithString:buffer]
                                                               options:NSXMLDocumentValidate
                                                                 error:nil];
    return document;
}

-(NSArray *)constructListOfReactionsFromVFFComponents:(NSArray *)componentArray
{
    // reaction set -
    NSMutableArray *reaction_set = [NSMutableArray array];
    
    // array of verbs -
    NSArray *verb_array = @[@"binds",
                            @"auto",
                            @"transcribes",
                            @"translates",
                            @"activates",
                            @"phosphorylates",
                            @"dephosphorylates",
                            @"degrades",
                            @"flux_inputs",
                            @"disassociates",
                            @"converts"];
    
    // ok - go through my array -
    NSInteger reaction_counter = 0;
    for (NSArray *reaction_array in componentArray)
    {
        // Transformation -
        NSString *transformation_string = [reaction_array objectAtIndex:0];
        NSString *output_string = [reaction_array objectAtIndex:1];
        
        // Buffer -
        NSMutableString *buffer = [[NSMutableString alloc] init];
        
        // ok, which action word do we have?
        NSString *reaction_block;
        for (NSString *verb in verb_array)
        {
            NSRange match = [transformation_string rangeOfString:verb options:NSLiteralSearch];
            if (match.location != NSNotFound)
            {
                NSString *verb_fragment = [transformation_string substringWithRange:match];
                
                if ([verb_fragment isEqualToString:@"binds"] == YES)
                {
                    NSArray *split = [transformation_string componentsSeparatedByString:verb];
                    reaction_block = [self processBindsInteractionWithInputArray:split andOutputString:output_string atReactionIndex:&reaction_counter];
                    [buffer appendString:reaction_block];
                }
                else if ([verb_fragment isEqualToString:@"degrades"] == YES)
                {
                    NSArray *split = [transformation_string componentsSeparatedByString:verb];
                    reaction_block = [self processDegradesInteractionWithInputArray:split andOutputString:output_string atReactionIndex:&reaction_counter];
                    [buffer appendString:reaction_block];
                }
                else if ([verb_fragment isEqualToString:@"auto"] == YES)
                {
                    NSArray *split = [transformation_string componentsSeparatedByString:verb];
                    reaction_block = [self processAutoactivationInteractionWithInputArray:split andOutputString:output_string atReactionIndex:&reaction_counter];
                    [buffer appendString:reaction_block];
                }
                else if ([verb_fragment isEqualToString:@"transcribes"] == YES)
                {
                    NSArray *split = [transformation_string componentsSeparatedByString:verb];
                    reaction_block = [self processTranscribesInteractionWithInputArray:split andOutputString:output_string atReactionIndex:&reaction_counter];
                    [buffer appendString:reaction_block];
                }
                else if ([verb_fragment isEqualToString:@"translates"] == YES)
                {
                    NSArray *split = [transformation_string componentsSeparatedByString:verb];
                    reaction_block = [self processTranslatesInteractionWithInputArray:split andOutputString:output_string atReactionIndex:&reaction_counter];
                    [buffer appendString:reaction_block];
                }
                else if ([verb_fragment isEqualToString:@"phosphorylates"] == YES &&
                         [verb_fragment isEqualToString:verb] == YES)
                {
                    // we are getting false +'s => make sure *not* dephosphorylates
                    NSRange local_range = [transformation_string rangeOfString:@"dephosphorylates"];
                    if (local_range.location == NSNotFound)
                    {
                        NSArray *split = [transformation_string componentsSeparatedByString:verb];
                        reaction_block = [self processPhosphorylatesInteractionWithInputArray:split andOutputString:output_string atReactionIndex:&reaction_counter];
                        [buffer appendString:reaction_block];
                    }
                }
                else if ([verb_fragment isEqualToString:@"dephosphorylates"] == YES)
                {
                    NSLog(@"%@",transformation_string);
                    
                    // we are getting false +'s => make sure *not* phosphorylates
                    NSRange local_range = [transformation_string rangeOfString:@"phosphorylates"];
                    NSString *tmp = @"dephosphorylates";
                    if (local_range.length != [tmp length])
                    {
                        NSArray *split = [transformation_string componentsSeparatedByString:verb];
                        reaction_block = [self processDephosphorylatesInteractionWithInputArray:split andOutputString:output_string atReactionIndex:&reaction_counter];
                        [buffer appendString:reaction_block];
                    }
                }
                else if ([verb_fragment isEqualToString:@"activates"] == YES)
                {
                    NSArray *split = [transformation_string componentsSeparatedByString:verb];
                    reaction_block = [self processActivatesInteractionWithInputArray:split andOutputString:output_string atReactionIndex:&reaction_counter];
                    [buffer appendString:reaction_block];
                }
                else if ([verb_fragment isEqualToString:@"flux_inputs"] == YES)
                {
                    NSArray *split = [transformation_string componentsSeparatedByString:verb];
                    reaction_block = [self processFluxInputsInteractionWithInputArray:split andOutputString:output_string atReactionIndex:&reaction_counter];
                    [buffer appendString:reaction_block];
                }
                else if ([verb_fragment isEqualToString:@"disassociates"] == YES)
                {
                    NSArray *split = [transformation_string componentsSeparatedByString:verb];
                    reaction_block = [self processDisassociatesInteractionWithInputArray:split andOutputString:output_string atReactionIndex:&reaction_counter];
                    [buffer appendString:reaction_block];
                }
                else if ([verb_fragment isEqualToString:@"converts"] == YES)
                {
                    NSArray *split = [transformation_string componentsSeparatedByString:verb];
                    reaction_block = [self processConvertsInteractionWithInputArray:split andOutputString:output_string atReactionIndex:&reaction_counter];
                    [buffer appendString:reaction_block];
                }
            }
        }
        
        
        // grab the buffer -
        [reaction_set addObject:buffer];
        
        // update -
        //reaction_counter++;
    }
    
    return reaction_set;
}

-(NSString *)processConvertsInteractionWithInputArray:(NSArray *)reactantArray andOutputString:(NSString *)outputString atReactionIndex:(NSInteger *)reactionIndex
{
    // Buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // do we have compound reactants?
    NSString *reactant_1 = [[reactantArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    NSString *reactant_2 = [[reactantArray objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    NSString *productString = [outputString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    
    NSArray *major_reactant_array = [reactant_1 componentsSeparatedByString:@","];
    NSArray *minor_reactant_array = [reactant_2 componentsSeparatedByString:@","];
    NSArray *product_array = [productString componentsSeparatedByString:@","];
    
    // forward -
    NSInteger local_counter = 0;
    for (NSString *major_species in major_reactant_array)
    {
        for (NSString *minor_species in minor_reactant_array)
        {
            [buffer appendFormat:@"\t\t<reaction id='R_%lu' name='R_CONVERTS_R%lu' reversible='false'>\n",*reactionIndex,*reactionIndex];
            [buffer appendString:@"\t\t\t<listOfReactants>\n"];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[major_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[minor_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendString:@"\t\t\t</listOfReactants>\n"];
            
            [buffer appendString:@"\t\t\t<listOfProducts>\n"];
            for (NSString *product_species in product_array)
            {
                [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[product_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            }
            
            [buffer appendString:@"\t\t\t</listOfProducts>\n"];
            [buffer appendString:@"\t\t</reaction>\n"];
            
            // update counter -
            local_counter++;
            
            // update reaction counter -
            (*reactionIndex)++;
        }
    }
    
    return buffer;
}


-(NSString *)processDisassociatesInteractionWithInputArray:(NSArray *)reactantArray andOutputString:(NSString *)outputString atReactionIndex:(NSInteger *)reactionIndex
{
    // Buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // do we have compound reactants?
    NSString *reactant_1 = [[reactantArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    NSString *reactant_2 = [[reactantArray objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    NSString *productString = [outputString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    
    NSArray *major_reactant_array = [reactant_1 componentsSeparatedByString:@","];
    __unused NSArray *minor_reactant_array = [reactant_2 componentsSeparatedByString:@","];
    NSArray *product_array = [productString componentsSeparatedByString:@","];
    
    for (NSString *major_species in major_reactant_array)
    {
        [buffer appendFormat:@"\t\t<reaction id='R_%lu' name='R_DISASSOCIATES_R%lu' reversible='false'>\n",*reactionIndex,*reactionIndex];
        [buffer appendString:@"\t\t\t<listOfReactants>\n"];
        [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[major_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        [buffer appendString:@"\t\t\t</listOfReactants>\n"];
        
        [buffer appendString:@"\t\t\t<listOfProducts>\n"];
        for (NSString *product_species in product_array)
        {
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[product_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        }
        [buffer appendString:@"\t\t\t</listOfProducts>\n"];
        [buffer appendString:@"\t\t</reaction>\n"];
    }
    
    return buffer;
}

-(NSString *)processFluxInputsInteractionWithInputArray:(NSArray *)reactantArray andOutputString:(NSString *)outputString atReactionIndex:(NSInteger *)reactionIndex
{
    // Buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // do we have compound reactants?
    NSString *reactant_1 = [[reactantArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    NSString *reactant_2 = [[reactantArray objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    NSString *productString = [outputString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    
    __unused NSArray *major_reactant_array = [reactant_1 componentsSeparatedByString:@","];
    __unused NSArray *minor_reactant_array = [reactant_2 componentsSeparatedByString:@","];
    NSArray *product_array = [productString componentsSeparatedByString:@","];
    
    // forward -
    // NSInteger local_counter = 0;
    for (NSString *major_species in product_array)
    {
        [buffer appendFormat:@"\t\t<reaction id='R_%lu' name='R_INPUT_R%lu' reversible='false'>\n",*reactionIndex,*reactionIndex];
        [buffer appendString:@"\t\t\t<listOfReactants>\n"];
        [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",@"[]"];
        [buffer appendString:@"\t\t\t</listOfReactants>\n"];
        
        [buffer appendString:@"\t\t\t<listOfProducts>\n"];
        [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[major_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        [buffer appendString:@"\t\t\t</listOfProducts>\n"];
        [buffer appendString:@"\t\t</reaction>\n"];
        
        // update reaction counter -
        (*reactionIndex)++;
    }
    
    // return -
    return buffer;
}


-(NSString *)processAutoactivationInteractionWithInputArray:(NSArray *)reactantArray andOutputString:(NSString *)outputString atReactionIndex:(NSInteger *)reactionIndex
{
    // Buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // do we have compound reactants?
    NSString *reactant_1 = [[reactantArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    NSString *reactant_2 = [[reactantArray objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    NSString *productString = [outputString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    
    NSArray *major_reactant_array = [reactant_1 componentsSeparatedByString:@","];
    __unused NSArray *minor_reactant_array = [reactant_2 componentsSeparatedByString:@","];
    NSArray *product_array = [productString componentsSeparatedByString:@","];
    
    // forward -
    NSInteger local_counter = 0;
    for (NSString *major_species in major_reactant_array)
    {
        [buffer appendFormat:@"\t\t<reaction id='R_%lu' name='R_AUTOACTIVATION_R%lu' reversible='false'>\n",*reactionIndex,*reactionIndex];
        [buffer appendString:@"\t\t\t<listOfReactants>\n"];
        [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[major_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        [buffer appendString:@"\t\t\t</listOfReactants>\n"];
        
        [buffer appendString:@"\t\t\t<listOfProducts>\n"];
        NSString *product_species = [product_array objectAtIndex:local_counter];
        [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",product_species];
        [buffer appendString:@"\t\t\t</listOfProducts>\n"];
        [buffer appendString:@"\t\t</reaction>\n"];
        
        // update reaction counter -
        (*reactionIndex)++;
    }
    
    // return -
    return buffer;
}


-(NSString *)processDegradesInteractionWithInputArray:(NSArray *)reactantArray andOutputString:(NSString *)outputString atReactionIndex:(NSInteger *)reactionIndex
{
    // Buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // do we have compound reactants?
    NSString *reactant_1 = [[reactantArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    NSString *reactant_2 = [[reactantArray objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    NSString *productString = [outputString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    
    NSArray *major_reactant_array = [reactant_1 componentsSeparatedByString:@","];
    __unused NSArray *minor_reactant_array = [reactant_2 componentsSeparatedByString:@","];
    __unused NSArray *product_array = [productString componentsSeparatedByString:@","];
    
    // forward -
    // NSInteger local_counter = 0;
    for (NSString *major_species in major_reactant_array)
    {
        [buffer appendFormat:@"\t\t<reaction id='R_%lu' name='R_DEGRADES_R%lu' reversible='false'>\n",*reactionIndex,*reactionIndex];
        [buffer appendString:@"\t\t\t<listOfReactants>\n"];
        [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[major_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        [buffer appendString:@"\t\t\t</listOfReactants>\n"];
        
        [buffer appendString:@"\t\t\t<listOfProducts>\n"];
        [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",@"[]"];
        [buffer appendString:@"\t\t\t</listOfProducts>\n"];
        [buffer appendString:@"\t\t</reaction>\n"];
        
        // update reaction counter -
        (*reactionIndex)++;
    }
    
    // return -
    return buffer;
}

-(NSString *)processActivatesInteractionWithInputArray:(NSArray *)reactantArray andOutputString:(NSString *)outputString atReactionIndex:(NSInteger *)reactionIndex
{
    // Buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // do we have compound reactants?
    NSString *reactant_1 = [[reactantArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    NSString *reactant_2 = [[reactantArray objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    NSString *productString = [outputString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    
    NSArray *major_reactant_array = [reactant_1 componentsSeparatedByString:@","];
    NSArray *minor_reactant_array = [reactant_2 componentsSeparatedByString:@","];
    NSArray *product_array = [productString componentsSeparatedByString:@","];
    
    // forward -
    NSInteger local_counter = 0;
    for (NSString *major_species in major_reactant_array)
    {
        for (NSString *minor_species in minor_reactant_array)
        {
            [buffer appendFormat:@"\t\t<reaction id='R_%lu' name='R_ACTIVATES_R%lu' reversible='false'>\n",*reactionIndex,*reactionIndex];
            [buffer appendString:@"\t\t\t<listOfReactants>\n"];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[major_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[minor_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            
            [buffer appendString:@"\t\t\t</listOfReactants>\n"];
            
            [buffer appendString:@"\t\t\t<listOfProducts>\n"];
            NSString *product_species = [product_array objectAtIndex:local_counter];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[product_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[major_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendString:@"\t\t\t</listOfProducts>\n"];
            [buffer appendString:@"\t\t</reaction>\n"];
            
            // update counter -
            local_counter++;
            
            // update reaction counter -
            (*reactionIndex)++;
        }
    }
    
    return buffer;
}


-(NSString *)processPhosphorylatesInteractionWithInputArray:(NSArray *)reactantArray andOutputString:(NSString *)outputString atReactionIndex:(NSInteger *)reactionIndex
{
    // Buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // do we have compound reactants?
    NSString *reactant_1 = [[reactantArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    NSString *reactant_2 = [[reactantArray objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    NSString *productString = [outputString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    
    NSArray *major_reactant_array = [reactant_1 componentsSeparatedByString:@","];
    NSArray *minor_reactant_array = [reactant_2 componentsSeparatedByString:@","];
    NSArray *product_array = [productString componentsSeparatedByString:@","];
    
    // forward -
    NSInteger local_counter = 0;
    for (NSString *major_species in major_reactant_array)
    {
        for (NSString *minor_species in minor_reactant_array)
        {
            [buffer appendFormat:@"\t\t<reaction id='R_%lu' name='R_PHOSPHORYLATES_R%lu' reversible='false'>\n",*reactionIndex,*reactionIndex];
            [buffer appendString:@"\t\t\t<listOfReactants>\n"];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[major_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[minor_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            
            [buffer appendString:@"\t\t\t</listOfReactants>\n"];
            
            [buffer appendString:@"\t\t\t<listOfProducts>\n"];
            NSString *product_species = [product_array objectAtIndex:local_counter];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[product_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[major_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendString:@"\t\t\t</listOfProducts>\n"];
            [buffer appendString:@"\t\t</reaction>\n"];
            
            // update counter -
            local_counter++;
            
            // update reaction counter -
            (*reactionIndex)++;
        }
    }
    
    return buffer;
}


-(NSString *)processDephosphorylatesInteractionWithInputArray:(NSArray *)reactantArray andOutputString:(NSString *)outputString atReactionIndex:(NSInteger *)reactionIndex
{
    // Buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // do we have compound reactants?
    NSString *reactant_1 = [[reactantArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    NSString *reactant_2 = [[reactantArray objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    NSString *productString = [outputString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    
    NSArray *major_reactant_array = [reactant_1 componentsSeparatedByString:@","];
    NSArray *minor_reactant_array = [reactant_2 componentsSeparatedByString:@","];
    NSArray *product_array = [productString componentsSeparatedByString:@","];
    
    // forward -
    NSInteger local_counter = 0;
    for (NSString *major_species in major_reactant_array)
    {
        for (NSString *minor_species in minor_reactant_array)
        {
            [buffer appendFormat:@"\t\t<reaction id='R_%lu' name='R_DEPHOSPHORYLATES_R%lu' reversible='false'>\n",*reactionIndex,*reactionIndex];
            [buffer appendString:@"\t\t\t<listOfReactants>\n"];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[major_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[minor_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            
            [buffer appendString:@"\t\t\t</listOfReactants>\n"];
            
            [buffer appendString:@"\t\t\t<listOfProducts>\n"];
            NSString *product_species = [product_array objectAtIndex:local_counter];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[product_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[major_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendString:@"\t\t\t</listOfProducts>\n"];
            [buffer appendString:@"\t\t</reaction>\n"];
            
            // update counter -
            local_counter++;
            
            // update reaction counter -
            (*reactionIndex)++;
        }
    }
    
    return buffer;
}

-(NSString *)processTranslatesInteractionWithInputArray:(NSArray *)reactantArray andOutputString:(NSString *)outputString atReactionIndex:(NSInteger *)reactionIndex
{
    // Buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // do we have compound reactants?
    NSString *reactant_1 = [[reactantArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    NSString *reactant_2 = [[reactantArray objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    NSString *productString = [outputString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    
    NSArray *major_reactant_array = [reactant_1 componentsSeparatedByString:@","];
    NSArray *minor_reactant_array = [reactant_2 componentsSeparatedByString:@","];
    NSArray *product_array = [productString componentsSeparatedByString:@","];
    
    // forward -
    NSInteger local_counter = 0;
    for (NSString *major_species in major_reactant_array)
    {
        for (NSString *minor_species in minor_reactant_array)
        {
            [buffer appendFormat:@"\t\t<reaction id='R_%lu' name='R_TRANSLATES_R%lu' reversible='false'>\n",*reactionIndex,*reactionIndex];
            [buffer appendString:@"\t\t\t<listOfReactants>\n"];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[major_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[minor_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            
            [buffer appendString:@"\t\t\t</listOfReactants>\n"];
            
            [buffer appendString:@"\t\t\t<listOfProducts>\n"];
            NSString *product_species = [product_array objectAtIndex:local_counter];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[product_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[major_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[minor_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendString:@"\t\t\t</listOfProducts>\n"];
            [buffer appendString:@"\t\t</reaction>\n"];
            
            // update counter -
            local_counter++;
            
            // update reaction counter -
            (*reactionIndex)++;
        }
    }
    
    return buffer;

}

-(NSString *)processTranscribesInteractionWithInputArray:(NSArray *)reactantArray andOutputString:(NSString *)outputString atReactionIndex:(NSInteger *)reactionIndex
{
    // Buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // do we have compound reactants?
    NSString *reactant_1 = [[reactantArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    NSString *reactant_2 = [[reactantArray objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    NSString *productString = [outputString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    
    NSArray *major_reactant_array = [reactant_1 componentsSeparatedByString:@","];
    NSArray *minor_reactant_array = [reactant_2 componentsSeparatedByString:@","];
    NSArray *product_array = [productString componentsSeparatedByString:@","];

    // forward -
    NSInteger local_counter = 0;
    for (NSString *major_species in major_reactant_array)
    {
        for (NSString *minor_species in minor_reactant_array)
        {
            [buffer appendFormat:@"\t\t<reaction id='R_%lu' name='R_TRANSCRIBES_R%lu' reversible='false'>\n",*reactionIndex,*reactionIndex];
            [buffer appendString:@"\t\t\t<listOfReactants>\n"];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[major_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[minor_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            
            [buffer appendString:@"\t\t\t</listOfReactants>\n"];
            
            [buffer appendString:@"\t\t\t<listOfProducts>\n"];
            NSString *product_species = [product_array objectAtIndex:local_counter];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[product_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[major_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[minor_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendString:@"\t\t\t</listOfProducts>\n"];
            [buffer appendString:@"\t\t</reaction>\n"];
            
            // update counter -
            local_counter++;
            
            // update reaction counter -
            (*reactionIndex)++;
        }
    }
    
    return buffer;
}

-(NSString *)processBindsInteractionWithInputArray:(NSArray *)reactantArray andOutputString:(NSString *)outputString atReactionIndex:(NSInteger *)reactionIndex
{
    // Buffer -
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    // do we have compound reactants?
    NSString *reactant_1 = [[reactantArray objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    NSString *reactant_2 = [[reactantArray objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    NSString *productString = [outputString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"( )"]];
    
    NSArray *major_reactant_array = [reactant_1 componentsSeparatedByString:@","];
    NSArray *minor_reactant_array = [reactant_2 componentsSeparatedByString:@","];
    NSArray *product_array = [productString componentsSeparatedByString:@","];
    
    // this has different behavior - depending upon the number of major and minor species
    if ([major_reactant_array count] == 1)
    {
        // Get the major species -
        NSString *major_species = [major_reactant_array lastObject];
        NSInteger local_counter = 0;
        for (NSString *minor_species in minor_reactant_array)
        {
            [buffer appendFormat:@"\t\t<reaction id='R_%lu' name='R_BINDS_R%lu' reversible='false'>\n",*reactionIndex,*reactionIndex];
            [buffer appendString:@"\t\t\t<listOfReactants>\n"];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[major_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[minor_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendString:@"\t\t\t</listOfReactants>\n"];
            [buffer appendString:@"\t\t\t<listOfProducts>\n"];
            NSString *product_species = [product_array objectAtIndex:local_counter];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[product_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendString:@"\t\t\t</listOfProducts>\n"];
            [buffer appendString:@"\t\t</reaction>\n"];
            
            // update counter -
            local_counter++;
            
            // update reaction counter -
            (*reactionIndex)++;
        }
    }
    else
    {
        // forward -
        NSInteger local_counter = 0;
        for (NSString *major_species in major_reactant_array)
        {
            [buffer appendFormat:@"\t\t<reaction id='R_%lu' name='R_BINDS_R%lu' reversible='false'>\n",*reactionIndex,*reactionIndex];
            [buffer appendString:@"\t\t\t<listOfReactants>\n"];
            for (NSString *minor_species in minor_reactant_array)
            {
                [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[major_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[minor_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            }
            [buffer appendString:@"\t\t\t</listOfReactants>\n"];
            
            [buffer appendString:@"\t\t\t<listOfProducts>\n"];
            NSString *product_species = [product_array objectAtIndex:local_counter];
            [buffer appendFormat:@"\t\t\t\t<speciesReference species='%@' stoichiometry='1.0'/>\n",[product_species stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [buffer appendString:@"\t\t\t</listOfProducts>\n"];
            [buffer appendString:@"\t\t</reaction>\n"];
            
            // update counter -
            local_counter++;
            
            // update reaction counter -
            (*reactionIndex)++;
        }
    }
    
    // return -
    return buffer;
}

@end
