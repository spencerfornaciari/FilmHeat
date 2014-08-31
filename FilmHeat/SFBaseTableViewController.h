//
//  SFBaseTableViewController.h
//  Film Heat
//
//  Created by Spencer Fornaciari on 8/30/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFMCTableViewCell.h"
#import "CoreDataHelper.h"
#import "Film.h"
#import "NetworkController.h"

@interface SFBaseTableViewController : UITableViewController <UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;


- (IBAction)segmentedAction:(id)sender;

@end
