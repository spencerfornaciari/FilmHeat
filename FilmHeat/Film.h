//
//  Film.h
//  Film Heat
//
//  Created by Spencer Fornaciari on 9/4/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Actor, Genre, User;

@interface Film : NSManagedObject

@property (nonatomic, retain) NSString * audienceRating;
@property (nonatomic, retain) NSNumber * audienceScore;
@property (nonatomic, retain) NSString * criticalConsensus;
@property (nonatomic, retain) NSString * criticRating;
@property (nonatomic, retain) NSNumber * criticScore;
@property (nonatomic, retain) NSString * findSimilarFilms;
@property (nonatomic, retain) NSString * imdbID;
@property (nonatomic, retain) NSNumber * interestStatus;
@property (nonatomic, retain) NSString * mpaaRating;
@property (nonatomic, retain) NSString * posterLocation;
@property (nonatomic, retain) NSString * posterURL;
@property (nonatomic, retain) NSNumber * ratingVariance;
@property (nonatomic, retain) NSDate * releaseDate;
@property (nonatomic, retain) NSString * rottenTomatoesID;
@property (nonatomic, retain) NSNumber * runtime;
@property (nonatomic, retain) NSString * synopsis;
@property (nonatomic, retain) NSString * thumbnailPosterLocation;
@property (nonatomic, retain) NSString * thumbnailPosterURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * userRating;
@property (nonatomic, retain) NSOrderedSet *actors;
@property (nonatomic, retain) NSOrderedSet *genres;
@property (nonatomic, retain) User *user;
@end

@interface Film (CoreDataGeneratedAccessors)

- (void)insertObject:(Actor *)value inActorsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromActorsAtIndex:(NSUInteger)idx;
- (void)insertActors:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeActorsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInActorsAtIndex:(NSUInteger)idx withObject:(Actor *)value;
- (void)replaceActorsAtIndexes:(NSIndexSet *)indexes withActors:(NSArray *)values;
- (void)addActorsObject:(Actor *)value;
- (void)removeActorsObject:(Actor *)value;
- (void)addActors:(NSOrderedSet *)values;
- (void)removeActors:(NSOrderedSet *)values;
- (void)insertObject:(Genre *)value inGenresAtIndex:(NSUInteger)idx;
- (void)removeObjectFromGenresAtIndex:(NSUInteger)idx;
- (void)insertGenres:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeGenresAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInGenresAtIndex:(NSUInteger)idx withObject:(Genre *)value;
- (void)replaceGenresAtIndexes:(NSIndexSet *)indexes withGenres:(NSArray *)values;
- (void)addGenresObject:(Genre *)value;
- (void)removeGenresObject:(Genre *)value;
- (void)addGenres:(NSOrderedSet *)values;
- (void)removeGenres:(NSOrderedSet *)values;

//My Methods
-(void)addNewGenreObject:(Genre *)value;
-(void)addNewActorObject:(Actor *)value;

@end
