//
//  SFSeenTableViewController.h
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/6/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilmModel.h"
#import "SFTheaterTableViewController.h"
#import "SFMCTableViewCell.h"
#import "UIColor+SFFilmHeatColors.h"

@protocol SFSeenTableViewControllerDelegate <NSObject>

-(void)passFilmFromSeen:(FilmModel *)film forIndex:(NSInteger)index;


@end

@interface SFSeenTableViewController : UITableViewController

@property (nonatomic, unsafe_unretained) id<SFSeenTableViewControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *seenArray;

@end
