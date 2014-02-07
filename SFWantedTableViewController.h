//
//  SFWantedTableViewController.h
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/6/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilmModel.h"
#import "Constants.h"
#import "SFMCTableViewCell.h"
#import "UIColor+SFFilmHeatColors.h"

@protocol SFWantedTableViewControllerDelegate <NSObject>

-(void)passFilmFromWanted:(FilmModel *)film forIndex:(NSInteger)index;

@end

@interface SFWantedTableViewController : UITableViewController

@property (nonatomic, unsafe_unretained) id<SFWantedTableViewControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *wantedArray;

@end
