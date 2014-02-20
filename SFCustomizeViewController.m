//
//  SFCustomizeViewController.m
//  FilmHeat
//
//  Created by Spencer Fornaciari on 2/3/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFCustomizeViewController.h"

@interface SFCustomizeViewController ()

- (IBAction)dismissViewController:(id)sender;

@end

@implementation SFCustomizeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"mpaaRatingThreshold"] >= 0) {
        NSInteger threshold = [[NSUserDefaults standardUserDefaults] integerForKey:@"mpaaRatingThreshold"];
        self.mpaaRatingThresholdSliderOutlet.value = threshold / 5.f;
        [self setRatingThresholdLabel:threshold];
    }

    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"criticThreshold"]) {
        float flo =  [[NSUserDefaults standardUserDefaults] integerForKey:@"criticThreshold"] / 100.f;
        self.criticsRatingThresholdSliderOutlet.value = flo;
        int threshold = self.criticsRatingThresholdSliderOutlet.value * 100;
        self.criticsRatingThresholdLabel.text = [[NSNumber numberWithInt:threshold] stringValue];
    }
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"audienceThreshold"]) {
        float flo =  [[NSUserDefaults standardUserDefaults] integerForKey:@"audienceThreshold"] / 100.f;
        self.audienceRatingThresholdSliderOutlet.value = flo;
        int threshold = self.audienceRatingThresholdSliderOutlet.value * 100;
        self.audienceRatingThresholdLabel.text = [[NSNumber numberWithInt:threshold] stringValue];
    }
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"varianceThreshold"]) {
        float flo =  [[NSUserDefaults standardUserDefaults] integerForKey:@"varianceThreshold"] / 100.f;
        self.ratingVarianceSliderOutlet.value = flo;
        int threshold = self.ratingVarianceSliderOutlet.value * 100;
        self.ratingVarianceLabel.text = [[NSNumber numberWithInt:threshold] stringValue];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)mpaaRatingThresholdSliderAction:(id)sender {
    int threshold = [self.mpaaRatingThresholdSliderOutlet value] * 5;
    [self setRatingThresholdLabel:threshold];
    
    [[NSUserDefaults standardUserDefaults] setInteger:threshold forKey:@"mpaaRatingThreshold"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setRatingThresholdLabel:(NSInteger)index
{
    if (index == 5) {
        self.mpaaRatingThresholdLabel.text = @"NC-17";
    } else if (index == 4) {
        self.mpaaRatingThresholdLabel.text = @"R";
    }else if (index == 3) {
        self.mpaaRatingThresholdLabel.text = @"PG-13";
    } else if (index == 2) {
        self.mpaaRatingThresholdLabel.text = @"PG";
    } else if (index == 1) {
        self.mpaaRatingThresholdLabel.text = @"G";
    } else {
        self.mpaaRatingThresholdLabel.text = @"NR";
    }
}


- (IBAction)dismissViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 5) ? NO : YES;
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}



- (IBAction)criticsRatingThresholdSliderAction:(id)sender {
    int threshold = self.criticsRatingThresholdSliderOutlet.value * 100;
    self.criticsRatingThresholdLabel.text = [[NSNumber numberWithInt:threshold] stringValue];
    [[NSUserDefaults standardUserDefaults] setInteger:threshold forKey:@"criticThreshold"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)audienceRatingThresholdSliderAction:(id)sender {
    int threshold = self.audienceRatingThresholdSliderOutlet.value * 100;
    self.audienceRatingThresholdLabel.text = [[NSNumber numberWithInt:threshold] stringValue];
    [[NSUserDefaults standardUserDefaults] setInteger:threshold forKey:@"audienceThreshold"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)ratingVarianceSliderAction:(id)sender {
    int threshold = self.ratingVarianceSliderOutlet.value * 100;
    self.ratingVarianceLabel.text = [[NSNumber numberWithInt:threshold] stringValue];
    [[NSUserDefaults standardUserDefaults] setInteger:threshold forKey:@"varianceThreshold"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UI Status Bar Style

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
