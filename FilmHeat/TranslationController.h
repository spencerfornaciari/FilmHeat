//
//  TranslationController.h
//  Film Heat
//
//  Created by Spencer Fornaciari on 9/2/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataHelper.h"
#import "Film.h"
#import "Actor.h"
#import "Character.h"

@interface TranslationController : NSObject

+(Film *)convertDictionaryToFilm:(NSDictionary *)dictionary;

+(NSArray *)convertDictionaryArrayToFilmArray:(NSArray *)dictionaryArray;

+(void)convertFilmArray:(NSArray *)dictionaryArray;

@end