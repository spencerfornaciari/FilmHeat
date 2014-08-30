//
//  Film.m
//  Film Heat
//
//  Created by Spencer Fornaciari on 8/29/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "Film.h"
#import "Actor.h"
#import "Genre.h"
#import "User.h"


@implementation Film

@dynamic audienceRating;
@dynamic audienceScore;
@dynamic criticalConsensus;
@dynamic criticRating;
@dynamic criticScore;
@dynamic imdbID;
@dynamic interestStatus;
@dynamic mpaaRating;
@dynamic posterLocation;
@dynamic ratingVariance;
@dynamic releaseDate;
@dynamic rottenTomatoesID;
@dynamic runtime;
@dynamic synopsis;
@dynamic thumbnailPosterLocation;
@dynamic title;
@dynamic userRating;
@dynamic thumbnailPosterURL;
@dynamic posterURL;
@dynamic ratingValue;
@dynamic findSimilarFilms;
@dynamic actors;
@dynamic genres;
@dynamic user;

//My Methods
- (void)addNewGenreObject:(Genre *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.genres];
    [tempSet addObject:value];
    self.genres = tempSet;
}

- (void)addNewActorObject:(Actor *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.actors];
    [tempSet addObject:value];
    self.actors = tempSet;
}

@end
