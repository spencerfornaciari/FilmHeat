//
//  SFFilmModelDataController.m
//  FilmHeat
//
//  Created by Spencer Fornaciari on 1/22/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFFilmModelDataController.h"
#import "SFMovieDetailViewController.h"

#define ROTTEN_TOMATOES_API_KEY @"sxqdwkta4vvwcggqmm5ggja7"
#define TMS_API_KEY @"7f4sgppp533ecxvutkaqg243"

@interface SFFilmModelDataController () <UIScrollViewDelegate>


@end

@implementation SFFilmModelDataController

- (void)populateFilmData:(NSString *)zipCode
{
    _downloadQueue = [NSOperationQueue new];
    
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSString *filmHeatPath = [documentsURL path];
    self.seenItPath = [filmHeatPath stringByAppendingPathComponent:SEEN_IT_FILE];
    self.wantedPath = [filmHeatPath stringByAppendingPathComponent:WANT_TO_FILE];
    self.noInterestPath = [filmHeatPath stringByAppendingPathComponent:DONT_WANT_IT_FILE];
    
    if ([self doesArrayExist:SEEN_IT_FILE]) {
        self.seenItArray = [NSKeyedUnarchiver unarchiveObjectWithFile:self.seenItPath];
    } else {
        self.seenItArray = [NSMutableArray new];
    }
    
    if ([self doesArrayExist:WANT_TO_FILE]) {
        self.wantedArray = [NSKeyedUnarchiver unarchiveObjectWithFile:self.wantedPath];
    } else {
        self.wantedArray = [NSMutableArray new];
    }

    if ([self doesArrayExist:DONT_WANT_IT_FILE]) {
        self.noInterestArray = [NSKeyedUnarchiver unarchiveObjectWithFile:self.noInterestPath];
    } else {
        self.noInterestArray = [NSMutableArray new];
    }
    
    NSDateFormatter *apiDateFormatter = [NSDateFormatter new];
    [apiDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *apiDateString = [apiDateFormatter stringFromDate:[NSDate date]];
    
    NSString *tmsString = [NSString stringWithFormat:@"http://data.tmsapi.com/v1/movies/showings?startDate=%@&zip=%@&imageSize=Sm&imageText=false&api_key=%@", apiDateString, zipCode, TMS_API_KEY];
    
    NSURL *tmsURL = [NSURL URLWithString:tmsString];
    
    NSData *tmsData = [NSData dataWithContentsOfURL:tmsURL];
    
    NSError *error;
    
    NSArray *tmsArray = [NSJSONSerialization JSONObjectWithData:tmsData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    
    
    NSMutableArray *rottenInstance = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in tmsArray)
    {
        FilmModel *film = [FilmModel new];
        
        film.downloadQueue = self.downloadQueue;
        //film.isDownloading = NO;
        
        film.title = dictionary[@"title"];
        
        film.synopsis = dictionary[@"shortDescription"];
        
        //Set the film's MPAA rating
        
        NSString *rating = [NSString stringWithFormat:@"%@", [dictionary valueForKeyPath:@"ratings.code"]];
        
        if (rating) {
            film.mpaaRating = [dictionary valueForKeyPath:@"ratings.code"];
            //NSLog(@"TRUE");
            //NSLog(@"%@", [dictionary valueForKeyPath:@"ratings.code"]);
        } else {
            //NSLog(@"FALSE");
            film.mpaaRating = @"NR";
        }
        
        BOOL doesExist = [self doesFilmExist:film];
        
        
        

        
//        film.mpaaRating = [dictionary valueForKeyPath:@"ratings.code"];
//        NSLog(@"%@", film.mpaaRating);
        
        //Grab the URL for the thumbnail of the film's poster
        NSString *poster = [dictionary valueForKeyPath:@"preferredImage.uri"];
        film.thumbnailPoster = [NSString stringWithFormat:@"http://developer.tmsimg.com/%@?api_key=%@", poster, TMS_API_KEY];
        //NSLog(@"%@", film.thumbnailPoster);
        
        //[film.showtimes =
        
        //NSLog(@"%@", [dictionary valueForKeyPath:@"showtimes.theatre.name"]);
//        NSString *thisDate = [dictionary valueForKeyPath:@"showtimes.dateTime"];
        
//        NSDateFormatter *newForm = [NSDateFormatter new];
//        [newForm setDateFormat:@"yyyy-MM-dd"];
//        NSLog(@"%@", thisDate);

        film.genres = [dictionary valueForKey:@"genres"];
        
        film.runtime = [film runTimeConverter:[dictionary valueForKey:@"runTime"]];
//
        film.releaseDate = [film releaseDateConverter:[dictionary valueForKey:@"releaseDate"]];
    
//        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
//        [dateFormatter2 setDateStyle:NSDateFormatterShortStyle];
//        NSLog(@"%@", [dateFormatter2 stringFromDate:film.releaseDate]);

//        if ([self doesSeenItArrayExist])
//        {
//            if ([self.seenItArray containsObject:film.title]) {
//                NSLog(@"Got it!");
//            } else {
//            }
//        }
        
        if (!doesExist) {
            [rottenInstance addObject:film];
        }
       
    }
    

//    


    
   // NSArray *myArray = [[NSArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.seenItPath]];
    
    
//    for (int i=0; i<5; i++) {
//        FilmModel *film = self.seenItArray[i];
//        film.wantsToSee = YES;
//    }

//    if ([self doesSeenItArrayExist]) {
//        
//        
//        self.seenItArray = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.seenItPath]];
//        NSLog(@"%@", self.seenItArray);
//    } else {
//        
//        NSPredicate *wantedPredicate = [NSPredicate predicateWithFormat:@"hasSeen = TRUE"];
//        self.seenItArray = [_rottenTomatoesArray filteredArrayUsingPredicate:wantedPredicate];
//    }

    
    _rottenTomatoesArray = rottenInstance;
    [self.tableView reloadData];
}

#pragma mark - Checking if the film already exists

- (BOOL)doesFilmExist:(FilmModel *)film
{
    if ([self doesArrayExist:SEEN_IT_FILE]) {
        NSArray *ratingCheck = [NSKeyedUnarchiver unarchiveObjectWithFile:self.seenItPath];
        for (FilmModel *check in ratingCheck) {
            if ([check.title isEqualToString:film.title]) {
                return YES;
            }
        }
    }
    return NO;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (_selectedSegment) {
        case 0: // Seen It
            return self.seenItArray.count;
        case 1: // All Movies
            return self.rottenTomatoesArray.count;
        case 2: // Want To See It
            return self.wantedArray.count;
        case 3:
            return self.noInterestArray.count;
    }

    return 0;
    //NSLog(@"%lu", (unsigned long)_rottenTomatoesArray.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFFilmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...    
    switch (_selectedSegment) {
        case 0: // Seen It
            [cell setFilm:[self.seenItArray objectAtIndex:indexPath.row]];
            break;
        case 1: // All Movies
            [cell setFilm:[self.rottenTomatoesArray objectAtIndex:indexPath.row]];
            break;
        case 2: // Want To See It
            [cell setFilm:[self.wantedArray objectAtIndex:indexPath.row]];
            break;
        case 3:
            [cell setFilm:[self.noInterestArray objectAtIndex:indexPath.row]];
            break;
    }
    
    return cell;
}



- (void)setSelectedSegment:(NSInteger)selectedSegment
{    
    _selectedSegment = selectedSegment;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedSegment == 0) {
        [self.delegate selectedFilm:self.seenItArray[indexPath.row]];
    } else if (_selectedSegment == 1) {
        [self.delegate selectedFilm:self.rottenTomatoesArray[indexPath.row]];
    } else if (_selectedSegment)
    {
        [self.delegate selectedFilm:self.wantedArray[indexPath.row]];
    }
//    if ([self doesSeenItArrayExist]) {
//        //[self.delegate selectedFilm:self.seenItArray[indexPath.row]];
//        NSLog(@"TRUE");
//        [self.delegate selectedFilm:self.rottenTomatoesArray[indexPath.row]];
//    } else {
//        [self.delegate selectedFilm:self.rottenTomatoesArray[indexPath.row]];
//
//    }
    //[self.delegate selectedFilm:self.rottenTomatoesArray[indexPath.row]];
    
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        NSDictionary *repoDict = _searchResults[indexPath.row];
//        self.detailViewController.detailItem = repoDict;
//    }
    
  //  [myArray addObject:self.rottenTomatoesArray[indexPath.row]];
  //  NSLog(@"%@", [self.rottenTomatoesArray[indexPath.row] title]);
  //  [self.rottenTomatoesArray removeObjectAtIndex:indexPath.row];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:nil userInfo:nil];
     //[[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadedImage" object:nil userInfo:@{@"user": self}];
    //[self.rottenTomatoesArray ]
    //
    
}

//- (NSArray *)wantedArray
//{
//    NSPredicate *wantedPredicate = [NSPredicate predicateWithFormat:@"wantsToSee = TRUE"];
//    return [_rottenTomatoesArray filteredArrayUsingPredicate:wantedPredicate];
//}

//- (NSArray *)seenItArray
//{
////    NSMutableArray *seenFilmsArray = [NSMutableArray new];
////    for (FilmModel *film in _rottenTomatoesArray) {
////        if (film.hasSeen) {
////            [seenFilmsArray addObject:film];
////        }
////    }
////    
////    return seenFilmsArray;
//    
//    
//
//    
//    
//}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TRUE;
}




- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode
//    if (self.editing)
//    {
//        return UITableViewCellEditingStyleDelete;
//    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)addSwipeViewTo:(SFFilmTableViewCell *)cell direction:(UISwipeGestureRecognizerDirection)direction
{

    [UIView animateWithDuration:.2 animations:^{
        cell.frame = CGRectMake(direction == UISwipeGestureRecognizerDirectionRight ? cell.frame.size.width : -cell.frame.size.width, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];

}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   // NSLog(@"Did Scroll");
    [self.delegate scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"Did End");
    [self.delegate scrollViewDidEndDecelerating:scrollView];
}

-(BOOL)doesArrayExist:(NSString *)arrayNameString
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSString *documentsPath = [documentsURL path];
    documentsPath = [documentsPath stringByAppendingPathComponent:arrayNameString];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        NSLog(@"FALSE");
        return FALSE;
    } else {
        NSLog(@"TRUE");
        return TRUE;
    }
}

@end