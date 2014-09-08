//
//  Film.m
//  Film Heat
//
//  Created by Spencer Fornaciari on 9/7/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "Film.h"
#import "Actor.h"
#import "Director.h"
#import "Genre.h"
#import "User.h"


@implementation Film

@dynamic audienceRating;
@dynamic audienceScore;
@dynamic criticalConsensus;
@dynamic criticRating;
@dynamic criticScore;
@dynamic findSimilarFilms;
@dynamic imdbID;
@dynamic interestStatus;
@dynamic mpaaRating;
@dynamic posterAvailable;
@dynamic posterLocation;
@dynamic posterURL;
@dynamic ratingValue;
@dynamic ratingVariance;
@dynamic releaseDate;
@dynamic rottenTomatoesID;
@dynamic runtime;
@dynamic synopsis;
@dynamic thumbnailAvailable;
@dynamic thumbnailPosterLocation;
@dynamic thumbnailPosterURL;
@dynamic title;
@dynamic userRating;
@dynamic studio;
@dynamic actors;
@dynamic genres;
@dynamic user;
@dynamic directors;

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

-(void)addNewDirectorObject:(Director *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.directors];
    [tempSet addObject:value];
    self.directors = tempSet;
}

@end
