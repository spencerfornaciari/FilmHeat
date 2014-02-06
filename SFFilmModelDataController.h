//
//  SFFilmModelDataController.h
//  FilmHeat
//
//  Created by Spencer Fornaciari on 1/22/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilmModel.h"
#import "ShowtimeModel.h"
#import "SFMCTableViewCell.h"
#import "SFMovieDetailViewController.h"

@protocol SFFilmModelDataControllerDelegate <NSObject>

@required
-(void)selectedFilm:(FilmModel *)film;

@optional
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

@interface SFFilmModelDataController : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, unsafe_unretained) id<SFFilmModelDataControllerDelegate>delegate;

@property (nonatomic) NSMutableArray *rottenTomatoesArray, *seenItArray, *wantedArray, *noInterestArray;
@property (nonatomic, strong) NSOperationQueue *downloadQueue;
@property (nonatomic) SFMovieDetailViewController *detailController;
@property (nonatomic, readwrite) NSInteger selectedSegment;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic) NSString *seenItPath, *wantedPath, *noInterestPath;

- (void)populateFilmData:(NSString *)zipCode;

@end