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
