//
//  SFNoneTableViewController.h
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/6/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilmModel.h"
#import "SFMCTableViewCell.h"
#import "UIColor+SFFilmHeatColors.h"

@protocol SFNoneTableViewControllerDelegate <NSObject>

-(void)passFilmFromNone:(FilmModel *)film forIndex:(NSInteger)index;

@end

@interface SFNoneTableViewController : UITableViewController

@property (nonatomic, unsafe_unretained) id<SFNoneTableViewControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *noneArray;

@end