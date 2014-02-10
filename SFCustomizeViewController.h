//
//  SFCustomizeViewController.h
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/3/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol SFCustomizeViewControllerDelegate <NSObject>

-(void)repopulateData;

@end

@interface SFCustomizeViewController : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate>

@property (nonatomic, unsafe_unretained) id<SFCustomizeViewControllerDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *mpaaRatingThresholdLabel;
@property (weak, nonatomic) IBOutlet UISlider *mpaaRatingThresholdSliderOutlet;

@property (weak, nonatomic) IBOutlet UILabel *criticsRatingThresholdLabel;
@property (weak, nonatomic) IBOutlet UISlider *criticsRatingThresholdSliderOutlet;
- (IBAction)criticsRatingThresholdSliderAction:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *audienceRatingThresholdLabel;
@property (weak, nonatomic) IBOutlet UISlider *audienceRatingThresholdSliderOutlet;
- (IBAction)audienceRatingThresholdSliderAction:(id)sender;






- (IBAction)mpaaRatingThresholdSliderAction:(id)sender;


@end
