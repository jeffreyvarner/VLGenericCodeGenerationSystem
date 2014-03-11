//
//  VLCoreUtilitiesLib.h
//  CFLGenerator
//
//  Created by Jeffrey Varner on 5/7/13.
//  Copyright (c) 2013 Varnerlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stdlib.h>

@interface VLCoreUtilitiesLib : NSObject
{
    
}

// low level methods -
+(NSXMLDocument *)createXMLDocumentFromFile:(NSURL *)url;
+(NSArray *)executeXPathQuery:(NSString *)xpath withXMLTree:(NSXMLDocument *)document;
+(void)writeBuffer:(NSString *)buffer
             toURL:(NSURL *)fileURL;
+(NSArray *)loadGenericFlatFile:(NSString *)filePath
                 withRecordDeliminator:(NSString *)recordDeliminator
                  withFieldDeliminator:(NSString *)fieldDeliminator;

+(NSArray *)loadCopyrightFileAtPath:(NSString *)filePath;
+(NSString *)lookupInputPathForTransformationWithName:(NSString *)transformName inTree:(NSXMLDocument *)blueprintTree;
+(NSString *)lookupOutputPathForTransformationWithName:(NSString *)transformName inTree:(NSXMLDocument *)blueprintTree;
+(float)generateRandomFloatingPointNumber;
+(NSArray *)generateStoichiometricMatrixArrayActionWithOptions:(NSDictionary *)options;


@end
