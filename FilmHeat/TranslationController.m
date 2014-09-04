//
//  TranslationController.m
//  Film Heat
//
//  Created by Spencer Fornaciari on 9/2/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "TranslationController.h"

@implementation TranslationController

+(Film *)convertDictionaryToFilm:(NSDictionary *)dictionary {
    Film *film = [NSEntityDescription insertNewObjectForEntityForName:@"Film" inManagedObjectContext:[CoreDataHelper managedContext]];
    
    //Getting ID information
    film.rottenTomatoesID = [dictionary objectForKey:@"id"];
    
    film.imdbID = [NSString stringWithFormat:@"http://www.imdb.com/title/tt%@/",[dictionary valueForKeyPath:@"alternate_ids.imdb"]];
    
    //Set the film title
    film.title = [dictionary objectForKey:@"title"];
    
    //Set the critics rating of the film according to Rotten Tomatoes
    film.criticScore = [dictionary valueForKeyPath:@"ratings.critics_score"];
    film.criticRating = [dictionary valueForKeyPath:@"ratings.critics_rating"];
    
    //Set the audience rating of the film according to Rotten Tomatoes
    film.audienceScore = [dictionary valueForKeyPath:@"ratings.audience_score"];
    film.audienceRating = [dictionary valueForKeyPath:@"ratings.audience_rating"];
    
    NSInteger critics = [film.criticScore integerValue];
    NSInteger audience = [film.audienceScore integerValue];
    long variance = ABS(critics - audience);
    
    film.ratingVariance = [NSNumber numberWithLong:variance];
    
    //Grab the URL for the thumbnail of the film's poster
    film.thumbnailPosterURL = [dictionary valueForKeyPath:@"posters.detailed"];
    film.posterURL = [dictionary valueForKeyPath:@"posters.original"];
    
    //Set the film runtime
    film.runtime = [dictionary valueForKeyPath:@"runtime"];
    
    //Set the film's MPAA rating
    NSString *rating = [dictionary valueForKeyPath:@"mpaa_rating"];
    
    if (rating) {
        film.mpaaRating = rating;
//        film.ratingValue = [NSNumber numberWithLong:[self setRatingValue:film.mpaaRating]];
    } else {
        film.mpaaRating = @"NR";
//        film.ratingValue = [NSNumber numberWithInt:0];
    }
    
    //Set film's release date
    NSDictionary *releaseDictionary = [dictionary valueForKeyPath:@"release_dates"];
    NSString *releaseDate = [releaseDictionary objectForKey:@"theater"];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    film.releaseDate = [df dateFromString:releaseDate];
    
    //Set the film's synopsis
    film.synopsis = [dictionary valueForKeyPath:@"synopsis"];
    film.criticalConsensus = [dictionary valueForKeyPath:@"critics_consensus"];
    
    film.interestStatus = @0;
    
    NSArray *castArray = [dictionary valueForKey:@"abridged_cast"];
    
    for (NSDictionary *castMember in castArray) {
        Actor *actor = [NSEntityDescription insertNewObjectForEntityForName:@"Actor" inManagedObjectContext:[CoreDataHelper managedContext]];
        
        actor.name = [castMember valueForKey:@"name"];
        NSArray *characterArray = [castMember valueForKey:@"characters"];
        actor.character = characterArray[0];
        
        [film addNewActorObject:actor];
    }
    
    film.findSimilarFilms = [dictionary valueForKeyPath:@"links.similar"];
    
    return film;
}

+(NSArray *)convertDictionaryArrayToFilmArray:(NSArray *)dictionaryArray {
    NSMutableArray *array = [NSMutableArray new];
    
    for (NSDictionary *dictionary in dictionaryArray) {
        Film *film = [NSEntityDescription insertNewObjectForEntityForName:@"Film" inManagedObjectContext:[CoreDataHelper managedContext]];
        
        //Getting ID information
        film.rottenTomatoesID = [dictionary objectForKey:@"id"];
        
        film.imdbID = [NSString stringWithFormat:@"http://www.imdb.com/title/tt%@/",[dictionary valueForKeyPath:@"alternate_ids.imdb"]];
        
        //Set the film title
        film.title = [dictionary objectForKey:@"title"];
        
        //Set the critics rating of the film according to Rotten Tomatoes
        film.criticScore = [dictionary valueForKeyPath:@"ratings.critics_score"];
        film.criticRating = [dictionary valueForKeyPath:@"ratings.critics_rating"];
        
        //Set the audience rating of the film according to Rotten Tomatoes
        film.audienceScore = [dictionary valueForKeyPath:@"ratings.audience_score"];
        film.audienceRating = [dictionary valueForKeyPath:@"ratings.audience_rating"];
        
        NSInteger critics = [film.criticScore integerValue];
        NSInteger audience = [film.audienceScore integerValue];
        long variance = ABS(critics - audience);
        
        film.ratingVariance = [NSNumber numberWithLong:variance];
        
        //Grab the URL for the thumbnail of the film's poster
        film.thumbnailPosterURL = [dictionary valueForKeyPath:@"posters.detailed"];
        film.posterURL = [dictionary valueForKeyPath:@"posters.original"];
        
        //Set the film runtime
        film.runtime = [dictionary valueForKeyPath:@"runtime"];
        
        //Set the film's MPAA rating
        NSString *rating = [dictionary valueForKeyPath:@"mpaa_rating"];
        
        if (rating) {
            film.mpaaRating = rating;
        } else {
            film.mpaaRating = @"NR";
        }
        
        //Set film's release date
        NSDictionary *releaseDictionary = [dictionary valueForKeyPath:@"release_dates"];
        NSString *releaseDate = [releaseDictionary objectForKey:@"theater"];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        film.releaseDate = [df dateFromString:releaseDate];
        
        //Set the film's synopsis
        film.synopsis = [dictionary valueForKeyPath:@"synopsis"];
        film.criticalConsensus = [dictionary valueForKeyPath:@"critics_consensus"];
        
        film.interestStatus = @5;
        
        NSArray *castArray = [dictionary valueForKey:@"abridged_cast"];
        
        for (NSDictionary *castMember in castArray) {
            Actor *actor = [NSEntityDescription insertNewObjectForEntityForName:@"Actor" inManagedObjectContext:[CoreDataHelper managedContext]];
            
            actor.name = [castMember valueForKey:@"name"];
            NSArray *characterArray = [castMember valueForKey:@"characters"];
            actor.character = characterArray[0];
            
            [film addNewActorObject:actor];
        }
        
        film.findSimilarFilms = [dictionary valueForKeyPath:@"links.similar"];
        [array addObject:film];
    }

    return [array copy];
}

//-(NSInteger)setRatingValue:(NSString *)mpaaRating
//{
//    if ([mpaaRating isEqualToString:@"G"]) {
//        return 1;
//    } else if ([mpaaRating isEqualToString:@"PG"]){
//        return 2;
//    } else if ([mpaaRating isEqualToString:@"PG-13"]) {
//        return 3;
//    } else if ([mpaaRating isEqualToString:@"R"]) {
//        return 4;
//    } else {
//        return 5;
//    }
//}

@end
