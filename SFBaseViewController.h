//
//  SFBaseViewController.h
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/6/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "SFTheaterTableViewController.h"
#import "SFSeenTableViewController.h"
#import "SFWantedTableViewController.h"
#import "SFNoneTableViewController.h"
#import "SFCustomizeViewController.h"

@interface SFBaseViewController : UIViewController <SFTheaterTableViewControllerDelegate, SFSeenTableViewControllerDelegate, SFWantedTableViewControllerDelegate, SFNoneTableViewControllerDelegate, UIActionSheetDelegate, UISearchBarDelegate>

@end
