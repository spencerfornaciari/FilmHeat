//
//  CoreDataHelper.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 7/21/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "CoreDataHelper.h"
#import "SFAppDelegate.h"

@implementation CoreDataHelper

//Return managed object context
+(NSManagedObjectContext *)managedContext {
    SFAppDelegate *appDelegate = (SFAppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.managedObjectContext;
}
//Return managed object model
+(NSManagedObjectModel *)managedModel {
    SFAppDelegate *appDelegate = (SFAppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.managedObjectModel;
}

//Saves the current context of the database
+(void)saveContext {
    NSError *error = nil;
    if (! [[CoreDataHelper managedContext] save:&error]) {
        // Uh, oh. An error happened. :(
        NSLog(@"%@", error.localizedDescription);
    } else {
        NSLog(@"Context Saved");
    }
}

//Fetchs the connections of the current user
+(NSArray *)filmsArray {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Film" inManagedObjectContext:[CoreDataHelper managedContext]];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    
    NSError *error;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"title" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSArray *array = [[CoreDataHelper managedContext] executeFetchRequest:request error:&error];

    return array;
}

+(NSArray *)titleSearchWithString:(NSString *)title {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Film" inManagedObjectContext:[CoreDataHelper managedContext]];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    
    NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"(title CONTAINS[cd] %@) AND (interestStatus != %@)", title, @5];
    
    [request setPredicate:titlePredicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"title" ascending:YES];

    [request setSortDescriptors:@[sortDescriptor]];
    
    
    NSError *error;
    NSArray *array = [[CoreDataHelper managedContext] executeFetchRequest:request error:&error];
    
    return array;
}

//Fetchs the connections of the current user
+(NSArray *)findCategoryArray:(NSNumber *)category {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Film" inManagedObjectContext:[CoreDataHelper managedContext]];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(interestStatus == %@) AND (ratingValue >= %@) AND (criticScore >= %@) AND (audienceScore >= %@) AND (ratingVariance <= %@)", category, [[NSUserDefaults standardUserDefaults] objectForKey:@"mpaaRatingThreshold"], [[NSUserDefaults standardUserDefaults] objectForKey:@"criticThreshold"], [[NSUserDefaults standardUserDefaults] objectForKey:@"audienceThreshold"], [[NSUserDefaults standardUserDefaults] objectForKey:@"varianceThreshold"]];
    
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"releaseDate" ascending:NO];

    [request setSortDescriptors:@[sortDescriptor]];

    NSError *error;
    NSArray *array = [[CoreDataHelper managedContext] executeFetchRequest:request error:&error];
    
    return array;
}

+(BOOL)doesFilmExist:(NSString *)filmID {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Film" inManagedObjectContext:[CoreDataHelper managedContext]];
    
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"rottenTomatoesID == %@", filmID]];

    NSError *error;
    NSArray *filmArray = [[CoreDataHelper managedContext] executeFetchRequest:request error:&error];
    
    if (filmArray.count > 0) {
        return TRUE;
    } else {
        return FALSE;
    }
}

+(Film *)getFilmInfo:(NSString *)filmID {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Film" inManagedObjectContext:[CoreDataHelper managedContext]];
    
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"rottenTomatoesID == %@", filmID]];
    
    NSError *error;
    NSArray *filmArray = [[CoreDataHelper managedContext] executeFetchRequest:request error:&error];
    
    if (filmArray.count > 0) {
        return filmArray[0];
    } else {
        return nil;
    }
}

+(BOOL)doesCoreDataExist {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Film" inManagedObjectContext:[CoreDataHelper managedContext]];
    
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    [request setFetchLimit:1];
    
    NSError *error;
    NSArray *results = [[CoreDataHelper managedContext] executeFetchRequest:request error:&error];
    
    if (results.count == 0) {
        return NO;
    } else {
        return YES;
    }
}

@end
