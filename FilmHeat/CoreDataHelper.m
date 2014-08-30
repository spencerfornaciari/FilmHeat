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
    NSArray *array = [[CoreDataHelper managedContext] executeFetchRequest:request error:&error];
    
//    NS *worker = array[0];
//    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"title" ascending:YES];
    
    return [array sortedArrayUsingDescriptors:@[sortDescriptor]];
}

//Fetchs the connections of the current user
+(NSArray *)findCategoryArray:(NSNumber *)category {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Film" inManagedObjectContext:[CoreDataHelper managedContext]];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    
    NSPredicate *categoryPredicate = [NSPredicate predicateWithFormat:@"interestStatus == %@", category];
    
    NSPredicate *criticPredicate = [NSPredicate predicateWithFormat:@"criticScore >= %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"criticThreshold"]];
    
//    NSPredicate *audiencePredicate = [NSPredicate predicateWithFormat:@"audienceScore >= %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"audienceThreshold"]];
//    
//    NSPredicate *variancePredicate = [NSPredicate predicateWithFormat:@"ratingVariance <= %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"varianceThreshold"]];
//    
    NSPredicate *customPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[categoryPredicate, criticPredicate]];
    
    [request setPredicate:categoryPredicate];

    NSError *error;
    NSArray *array = [[CoreDataHelper managedContext] executeFetchRequest:request error:&error];
    
    NSLog(@"Array count: %li", (long)array.count);
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"title" ascending:YES];
    
    return [array sortedArrayUsingDescriptors:@[sortDescriptor]];
}


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
