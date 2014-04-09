//
//  VLGenericCodeGenerationServiceStringsAndBlocks.m
//  VLGenericCodeGenerationSystem
//
//  Created by Jeffrey Varner on 2/28/14.
//  Copyright (c) 2014 Varnerlab. All rights reserved.
//

#import "VLGenericCodeGenerationServiceStringsAndBlocks.h"

// keys -
NSString *const kXMLModelInputTree = @"INPUT_DATA_TREE";
NSString *const kXMLTransformationTree = @"TRANSFORMATION_TREE";
NSString *const kXMLTransformationElement = @"TRANSFORMATION_XML_ELEMENT";


// Model source encodings -
NSString *const kSourceEncodingVFF = @"VFF";
NSString *const kSourceEncodingSBML = @"SBML";
NSString *const kSourceEncodingCFLML = @"CFLML";

// Model types -
NSString *const kModelTypeMassActionModel = @"MASS_ACTION_MODEL";
NSString *const kModelTypeCellFreeModel = @"CELL_FREE_MODEL";
NSString *const kModelTypeHybridCFLModel = @"HYBRID_CFL_MODEL";
NSString *const kModelTypeMetabolicModel = @"METABOLIC_MODEL";