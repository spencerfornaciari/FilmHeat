//
//  FilmModel.h
//  FilmHeat
//
//  Created by Spencer Fornaciari on 1/20/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilmModel : NSObject

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *thumbnailPoster;
@property (strong, nonatomic) UIImage *posterImage;
@property (strong, nonatomic) NSNumber *criticsRating;
@property (strong, nonatomic) NSNumber *audienceRating;
@property (strong, nonatomic) NSNumber *ratingVariance;
@property (strong, nonatomic) NSString *posterFilePath;
@property (strong, nonatomic) NSNumber *runtime;
@property (strong, nonatomic) NSString *synopsis;
@property (strong, nonatomic) NSString *mpaaRating;
@property (strong, nonatomic) NSNumber *ratingValue;
@property (strong, nonatomic) NSNumber *releaseYear;
@property (strong, nonatomic) NSDate *releaseDate;

@property (strong, nonatomic) NSString *rottenID;
@property (strong, nonatomic) NSString *imdbID;

@property (nonatomic) NSArray *genres;
@property (nonatomic) NSArray *showtimes;

@property (nonatomic, readwrite) BOOL hasSeen, wantsToSee;

@property (nonatomic) NSString *myRating;

@property (nonatomic) BOOL isDownloading;
@property (nonatomic, weak) NSOperationQueue *downloadQueue;

-(void)downloadPoster;
-(NSDate *)releaseDateConverter:(NSString *)releaseDateString;
-(NSNumber *)runTimeConverter:(NSString *)runTimeString;

@end