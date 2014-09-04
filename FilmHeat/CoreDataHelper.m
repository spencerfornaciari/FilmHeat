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

//Returns the current user of the database
//+(Worker *)currentUser {
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Worker" inManagedObjectContext:[CoreDataHelper managedContext]];
//    NSFetchRequest *request = [NSFetchRequest new];
//    [request setEntity:entity];
//    
//    NSError *error;
//    NSArray *array = [[CoreDataHelper managedContext] executeFetchRequest:request error:&error];
//    
//    Worker *worker = array[0];
//    
//    return worker;
//}

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
    
    NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"title BEGINSWITH[cd] %@", title];
    
    [request setPredicate:titlePredicate];
    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
//                                        initWithKey:@"title" ascending:YES];
//
//    [request setSortDescriptors:@[sortDescriptor]];
    
    
    NSError *error;
    NSArray *array = [[CoreDataHelper managedContext] executeFetchRequest:request error:&error];
    
    //
    
    return array;
}

//Fetchs the connections of the current user
+(NSArray *)findCategoryArray:(NSNumber *)category {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Film" inManagedObjectContext:[CoreDataHelper managedContext]];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    
//    NSPredicate *categoryPredicate = [NSPredicate predicateWithFormat:@"interestStatus == %@", category];
//    
//    NSPredicate *ratingPredicate = [NSPredicate predicateWithFormat:@"ratingValue >= %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"mpaaRatingThreshold"]];
//    
//    NSPredicate *criticPredicate = [NSPredicate predicateWithFormat:@"criticScore >= %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"criticThreshold"]];
//    
//    NSLog(@"Threshold: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"criticThreshold"]);
//    
//    NSPredicate *audiencePredicate = [NSPredicate predicateWithFormat:@"audienceScore >= %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"audienceThreshold"]];
////
//    NSPredicate *variancePredicate = [NSPredicate predicateWithFormat:@"ratingVariance <= %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"varianceThreshold"]];
////
//    NSPredicate *customPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[categoryPredicate, criticPredicate]];
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:
//                              @"(interestStatus == %@) AND (ratingValue >= %@) AND (criticScore >= %@) AND (audienceScore >= %@) AND (ratingVariance <= %@)", category, [[NSUserDefaults standardUserDefaults] objectForKey:@"mpaaRatingThreshold"], [[NSUserDefaults standardUserDefaults] objectForKey:@"criticThreshold"], [[NSUserDefaults standardUserDefaults] objectForKey:@"audienceThreshold"], [[NSUserDefaults standardUserDefaults] objectForKey:@"varianceThreshold"]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"interestStatus == %@", category];
    
    [request setPredicate:predicate];
    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
//                                        initWithKey:@"releaseDate" ascending:NO];
//    [request setSortDescriptors:@[sortDescriptor]];

    NSError *error;
    NSArray *array = [[CoreDataHelper managedContext] executeFetchRequest:request error:&error];
    
    NSLog(@"Count: %i", array.count);
    
    return array;
}

//+(BOOL)theaterFilms


//    for (FilmModel *film in self.strongArray) {
//        if ([film.ratingValue integerValue] >= [[NSUserDefaults standardUserDefaults] integerForKey:@"mpaaRatingThreshold"] && [film.criticsRating integerValue] >= [[NSUserDefaults standardUserDefaults] integerForKey:@"criticThreshold"] && [film.audienceRating integerValue] >= [[NSUserDefaults standardUserDefaults] integerForKey:@"audienceThreshold"] && [film.ratingVariance integerValue] <= [[NSUserDefaults standardUserDefaults] integerForKey:@"varianceThreshold"]) {
//            [ratingFilterArray addObject:film];
//        }
//    }


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

@end
