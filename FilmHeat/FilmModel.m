//
//  FilmModel.m
//  FilmHeat
//
//  Created by Spencer Fornaciari on 1/20/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "FilmModel.h"

@implementation FilmModel

-(id)init
{
    self = [super init];
    _isDownloading = FALSE;
    _myRating = [[NSNumber numberWithInt:40] stringValue];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        self.title = [decoder decodeObjectForKey:@"title"];
        self.mpaaRating = [decoder decodeObjectForKey:@"mpaaRating"];
        self.runtime = [decoder decodeObjectForKey:@"runtime"];
        self.genres = [decoder decodeObjectForKey:@"genres"];
        self.thumbnailPoster = [decoder decodeObjectForKey:@"thumbnailPoster"];
        self.releaseDate = [decoder decodeObjectForKey:@"releaseDate"];
        self.synopsis = [decoder decodeObjectForKey:@"synopsis"];
        self.myRating = [decoder decodeObjectForKey:@"myRating"];
        
        return self;
    }
    
    return nil;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.mpaaRating forKey:@"mpaaRating"];
    [encoder encodeObject:self.runtime forKey:@"runtime"];
    [encoder encodeObject:self.genres forKey:@"genres"];
    [encoder encodeObject:self.thumbnailPoster forKey:@"thumbnailPoster"];
    [encoder encodeObject:self.releaseDate forKey:@"releaseDate"];
    [encoder encodeObject:self.synopsis forKey:@"synopsis"];
    [encoder encodeObject:self.myRating forKey:@"myRating"];
}

-(void)downloadPoster
{
    _isDownloading = TRUE;
    
    [_downloadQueue addOperationWithBlock:^{
        NSURL *posterURL = [NSURL URLWithString:self.thumbnailPoster];
        NSLog(@"%@", posterURL);
        NSData *posterData = [NSData dataWithContentsOfURL:posterURL];
        self.posterImage = [UIImage imageWithData:posterData];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //_isDownloading = FALSE;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:nil userInfo:@{@"film": self}];
        }];
    }];
    
}

-(NSDate *)releaseDateConverter:(NSString *)releaseDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *formattedDateString = releaseDateString;
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:formattedDateString];
    
    return dateFromString;
}

-(NSNumber *)runTimeConverter:(NSString *)runTimeString
{
    NSArray *runTimeRawCharacters = [runTimeString componentsSeparatedByCharactersInSet:
                        [NSCharacterSet characterSetWithCharactersInString:@"THM"]];
    NSMutableArray *runTimeParsedCharacters = [NSMutableArray arrayWithArray:runTimeRawCharacters];
    [runTimeParsedCharacters removeLastObject];

    int filmRuntime = 0;

    for (int i = 1; i < runTimeParsedCharacters.count; i++)
    {
        if (![runTimeParsedCharacters[i] isEqualToString:@""]) {
            if (i == 1) {
                filmRuntime = [runTimeParsedCharacters[i] integerValue] * 60;
            } else {
                filmRuntime = filmRuntime + [runTimeParsedCharacters[i] integerValue];
            }
        }
    }

    return [NSNumber numberWithInteger:filmRuntime];
}

-(NSArray *)setShowTimes:(NSArray *)tmsShowtimeArray;
{
    NSMutableArray *showtimesMutable = [NSMutableArray new];
    
    for (NSDictionary *dictionary in tmsShowtimeArray)
    {
        ShowtimeModel *model = [ShowtimeModel new];
        model.theaterName = [dictionary valueForKeyPath:@"showtimes.theatre.name"];
        model.screeningDate = [dictionary valueForKeyPath:@"showtimes.theatre.dateTime"];
        model.ticketURL = [dictionary valueForKeyPath:@"showtimes.ticketURI"];
        
        [showtimesMutable addObject:model];
    }
    
    return nil;
}

@end