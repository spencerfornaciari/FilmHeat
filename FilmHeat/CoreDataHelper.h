//
//  CoreDataHelper.h
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/21/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Film.h"

@interface CoreDataHelper : NSObject

//Manage Context
+(NSManagedObjectContext *)managedContext;
+(NSManagedObjectModel *)managedModel;

//Film Search Methods
+(NSArray *)titleSearchWithString:(NSString *)title;
+(NSArray *)filmsArray;
+(NSArray *)findCategoryArray:(NSNumber *)category;
+(BOOL)doesFilmExist:(NSString *)filmID;
+(BOOL)doesCoreDataExist;

//Save Context
+(void)saveContext;

@end
