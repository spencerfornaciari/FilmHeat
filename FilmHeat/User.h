//
//  User.h
//  Film Heat
//
//  Created by Spencer Fornaciari on 8/29/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSString * facebook;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSOrderedSet *films;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)insertObject:(NSManagedObject *)value inFilmsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFilmsAtIndex:(NSUInteger)idx;
- (void)insertFilms:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFilmsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFilmsAtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
- (void)replaceFilmsAtIndexes:(NSIndexSet *)indexes withFilms:(NSArray *)values;
- (void)addFilmsObject:(NSManagedObject *)value;
- (void)removeFilmsObject:(NSManagedObject *)value;
- (void)addFilms:(NSOrderedSet *)values;
- (void)removeFilms:(NSOrderedSet *)values;


@end
