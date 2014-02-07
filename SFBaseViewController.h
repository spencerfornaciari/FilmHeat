//
//  SFBaseViewController.h
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/6/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFTheaterTableViewController.h"
#import "SFSeenTableViewController.h"
#import "SFWantedTableViewController.h"
#import "SFNoneTableViewController.h"

@interface SFBaseViewController : UIViewController <SFTheaterTableViewControllerDelegate, SFSeenTableViewControllerDelegate>

@end
