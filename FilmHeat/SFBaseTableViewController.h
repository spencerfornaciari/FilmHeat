//
//  SFBaseTableViewController.h
//  Film Heat
//
//  Created by Spencer Fornaciari on 8/30/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFMovieDetailViewController.h"
#import "SFMCTableViewCell.h"
#import "CoreDataHelper.h"
#import "Film.h"
#import "NetworkController.h"
#import "UIColor+SFFilmHeatColors.h"
#import "TranslationController.h"

@interface SFBaseTableViewController : UITableViewController <UISearchBarDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *sortButton;

- (IBAction)segmentedAction:(id)sender;
- (IBAction)sortAction:(id)sender;

@end
