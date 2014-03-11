//
//  VLCoreUtilitiesLib.m
//  CFLGenerator
//
//  Created by Jeffrey Varner on 5/7/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import "VLCoreUtilitiesLib.h"

@implementation VLCoreUtilitiesLib


#pragma mark - load/parse file methods
+(NSXMLDocument *)createXMLDocumentFromFile:(NSURL *)fileURL
{
    // Make sure we have a URL -
    if (fileURL==nil)
    {
        NSLog(@"ERROR: Blueprint file URL is nil.");
        return nil;
    }
    
    // Create error instance -
	NSError *errObject = nil;
	
    // Set the NSXMLDocument reference on the tree model
	NSXMLDocument *tmpDocument = [[NSXMLDocument alloc] initWithContentsOfURL:fileURL
                                                                      options:NSXMLNodeOptionsNone error:&errObject];
    
    // Check to make sure all is ok -
    if (errObject==nil)
    {
        // return -
        return tmpDocument;
    }
    else
    {
        NSLog(@"ERROR in createXMLDocumentFromFile: = %@",[errObject description]);
        return nil;
    }
}

+(NSArray *)loadCopyrightFileAtPath:(NSString *)filePath
{
    // major problem?
    if (filePath == nil)
    {
        return nil;
    }
    
    // Method attributes -
    NSError *error = nil;
    NSMutableArray *tmpArray = [NSMutableArray array];
    NSString *record_delim = @"\n";
    
    // Load the file -
    NSURL *tmpFileURL = [NSURL fileURLWithPath:filePath isDirectory:NO];
    
    // Load the file -
    NSString *fileString = [NSString stringWithContentsOfURL:tmpFileURL encoding:NSUTF8StringEncoding error:&error];
    
    // Ok, we need to walk through this file, and put it an array -
    NSScanner *scanner = [NSScanner scannerWithString:fileString];
    while (![scanner isAtEnd])
    {
        // Ok, let'd grab a row -
        NSString *tmpString;
        [scanner scanUpToString:record_delim intoString:&tmpString];
        
        if ([tmpString length] == 0)
        {
            [tmpArray addObject:@"\n"];
        }
        else
        {
            // Load the row -
            [tmpArray addObject:tmpString];
        }
        
        // dedug -
        NSLog(@"Processed - %@",tmpString);
    }
    
    // return -
    return [NSArray arrayWithArray:tmpArray];
}

+(NSArray *)loadGenericFlatFile:(NSString *)filePath
                 withRecordDeliminator:(NSString *)recordDeliminator
                  withFieldDeliminator:(NSString *)fieldDeliminator
{
    // Method attributes -
    NSError *error = nil;
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    // Load the file -
    NSURL *tmpFileURL = [NSURL fileURLWithPath:filePath isDirectory:NO];
    
    // Load the file -
    NSString *fileString = [NSString stringWithContentsOfURL:tmpFileURL encoding:NSUTF8StringEncoding error:&error];
    
    // Ok, we need to walk through this file, and put it an array -
    NSScanner *scanner = [NSScanner scannerWithString:fileString];
    while (![scanner isAtEnd])
    {
        // Ok, let'd grab a row -
        NSString *tmpString;
        [scanner scanUpToString:recordDeliminator intoString:&tmpString];
        
        // replace - w _
        NSString *new_string = [tmpString stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
        
        // Skip comments -
        NSRange range = [new_string rangeOfString:@"//" options:NSCaseInsensitiveSearch];
        if(range.location == NSNotFound)
        {
            // Ok, so let's cut around the tabs -
            NSArray *chunks = [new_string componentsSeparatedByString:fieldDeliminator];
            
            // Load the row -
            [tmpArray addObject:chunks];
        }
        
        NSLog(@"Processed - %@",new_string);
    }
    
    // return -
    return [NSArray arrayWithArray:tmpArray];
}


+(void)writeBuffer:(NSString *)buffer
             toURL:(NSURL *)fileURL
{
    // if no buffer -or- no url then exit
    if (buffer == nil || fileURL == nil)
    {
        return;
    }
    
    
    // write -
    NSError *error = nil;
    
    // ok, so we need to check to see if the directory exists -
    // Get the directory from the URL -
    NSURL *output_directory = [fileURL URLByDeletingLastPathComponent];
    NSFileManager *filesystem_manager = [NSFileManager defaultManager];
    BOOL isDirectory;
    if ([filesystem_manager fileExistsAtPath:[output_directory path] isDirectory:&isDirectory] == NO)
    {
        // build new directory -
        [filesystem_manager createDirectoryAtURL:output_directory withIntermediateDirectories:YES
                                      attributes:nil error:nil];
    }
    
    
    [buffer writeToFile:[fileURL path]
             atomically:YES
               encoding:NSUTF8StringEncoding
                  error:&error];
    
    if (error!=nil)
    {
        NSLog(@"ERROR: There is an issue writing the simulations results to disk - %@",[error description]);
    }
}


#pragma mark - xpath methods
+(NSArray *)executeXPathQuery:(NSString *)xpath withXMLTree:(NSXMLDocument *)document
{
    // Check for null args
    if (xpath==nil || document==nil)
    {
        NSLog(@"ERROR: Either the xpath string or the document was nil");
        return nil;
    }
    
    // Execute -
    NSError *error = nil;
    NSArray *tmpArray = [document nodesForXPath:xpath error:&error];
    
    // Check -
    if (error!=nil)
    {
        NSLog(@"ERROR - xpath = %@ did not complete",[error description]);
    }
    else
    {
        return tmpArray;
    }
    
    // return -
    return nil;
}

+(NSString *)lookupInputPathForTransformationWithName:(NSString *)transformName
                                               inTree:(NSXMLDocument *)blueprintTree
{
    // Formulate the xpath -
    NSString *xpath = [NSString stringWithFormat:@"//Transformation[@name='%@']/property[@key='INPUT_FILE_PATH']/@value",transformName];
    NSArray *resultArray = [VLCoreUtilitiesLib executeXPathQuery:xpath withXMLTree:blueprintTree];
    if (resultArray!=nil)
    {
        NSXMLElement *pathElment = [resultArray lastObject];
        return [pathElment stringValue];
    }
    else
    {
        return nil;
    }
}


+(NSString *)lookupOutputPathForTransformationWithName:(NSString *)transformName
                                                inTree:(NSXMLDocument *)blueprintTree
{
    // Formulate the xpath -
    NSString *xpath = [NSString stringWithFormat:@"//Transformation[@name='%@']/property[@key='OUTPUT_FILE_PATH']/@value",transformName];
    NSArray *resultArray = [VLCoreUtilitiesLib executeXPathQuery:xpath withXMLTree:blueprintTree];
    if (resultArray!=nil)
    {
        NSXMLElement *pathElment = [resultArray lastObject];
        return [pathElment stringValue];
    }
    else
    {
        return nil;
    }
}

+(float)generateRandomFloatingPointNumber
{
    float value = ((float)arc4random()/RAND_MAX);
    return value;
}

+(NSArray *)generateStoichiometricMatrixArrayActionWithOptions:(NSDictionary *)options
{
    if (options == nil)
    {
        return nil;
    }
    
    // array -
    NSMutableArray *row_array = [[NSMutableArray alloc] init];
    
    // Get our trees from the dictionary -
    __unused NSXMLDocument *transformation_tree = [options objectForKey:kXMLTransformationTree];
    __unused NSXMLElement *transformation = [options objectForKey:kXMLTransformationElement];
    NSXMLDocument *input_tree = (NSXMLDocument *)[options objectForKey:kXMLModelInputTree];
    
    // What is my model encoding?
    NSString *model_source_encoding = [[[input_tree nodesForXPath:@".//model/@source_encoding" error:nil] lastObject] stringValue];
    
    if ([model_source_encoding isEqualToString:kSourceEncodingVFF] == YES)
    {
    }
    else if ([model_source_encoding isEqualToString:kSourceEncodingSBML] == YES)
    {
        NSString *xpathString = @".//species";
        NSArray *list_of_species = [input_tree nodesForXPath:xpathString error:nil];
        for (NSXMLElement *species_node in list_of_species)
        {
            // Build the row array -
            NSMutableArray *col_array = [[NSMutableArray alloc] init];
            
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
                        [col_array addObject:@"0.0"];
                    }
                    else if (stcoeff_reactant != nil &&
                             stcoeff_product == nil)
                    {
                        NSString *tmp = [NSString stringWithFormat:@"-%@",stcoeff_reactant];
                        [col_array addObject:tmp];
                    }
                    else if (stcoeff_reactant == nil &&
                             stcoeff_product != nil)
                    {
                        NSString *tmp = [NSString stringWithFormat:@"+%@",stcoeff_product];
                        [col_array addObject:tmp];
                    }
                    else if (stcoeff_reactant == nil &&
                             stcoeff_product != nil)
                    {
                        // ok - would this ever happen?
                        // ...
                    }
                }
                
                // add the col_arr to the row_array -
                [row_array addObject:col_array];
            }
        }
    }
    
    // return -
    return [[NSArray alloc] initWithArray:row_array];
}


@end
