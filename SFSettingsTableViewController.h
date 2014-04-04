//
//  SFTSettingsTableViewController.h
//  Film Heat
//
//  Created by Spencer Fornaciari on 4/3/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFSettingsTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *mpaaRatingThresholdLabel;
@property (weak, nonatomic) IBOutlet UISlider *mpaaRatingThresholdSliderOutlet;
- (IBAction)mpaaRatingThresholdSliderAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *criticsRatingThresholdLabel;
@property (weak, nonatomic) IBOutlet UISlider *criticsRatingThresholdSliderOutlet;
- (IBAction)criticsRatingThresholdSliderAction:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *audienceRatingThresholdLabel;
@property (weak, nonatomic) IBOutlet UISlider *audienceRatingThresholdSliderOutlet;
- (IBAction)audienceRatingThresholdSliderAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *ratingVarianceLabel;
@property (weak, nonatomic) IBOutlet UISlider *ratingVarianceSliderOutlet;
- (IBAction)ratingVarianceSliderAction:(id)sender;




@end
