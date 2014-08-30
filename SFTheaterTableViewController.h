//
//  SFTheaterTableViewController.h
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/6/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilmModel.h"
#import "Constants.h"
#import "UIColor+SFFilmHeatColors.h"

@protocol SFTheaterTableViewControllerDelegate <NSObject>

-(void)passFilmFromTheater:(FilmModel *)film forIndex:(NSInteger)index;

@end

@interface SFTheaterTableViewController : UITableViewController

@property (nonatomic, unsafe_unretained) id<SFTheaterTableViewControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *theaterArray;
@property (nonatomic, strong) NSMutableArray *strongArray;

@end
