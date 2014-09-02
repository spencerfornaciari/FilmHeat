//
//  SFTSettingsTableViewController.m
//  Film Heat
//
//  Created by Spencer Fornaciari on 4/3/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFSettingsTableViewController.h"

@interface SFSettingsTableViewController ()

@end

@implementation SFSettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.tableView setAllowsSelection:NO];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"mpaaRatingThreshold"] >= 0) {
        NSNumber *defaultNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"mpaaRatingThreshold"];
        
        NSInteger threshold = [defaultNumber integerValue];
        self.mpaaRatingThresholdSliderOutlet.value = threshold / 5.f;
        [self setRatingThresholdLabel:threshold];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"criticThreshold"]) {
        NSNumber *defaultNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"criticThreshold"];
        float flo =  [defaultNumber floatValue] / 100.f;
        self.criticsRatingThresholdSliderOutlet.value = flo;
        int threshold = self.criticsRatingThresholdSliderOutlet.value * 100;
        self.criticsRatingThresholdLabel.text = [[NSNumber numberWithInt:threshold] stringValue];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"audienceThreshold"]) {
        NSNumber *defaultNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"audienceThreshold"];

        float flo =  [defaultNumber floatValue] / 100.f;
        self.audienceRatingThresholdSliderOutlet.value = flo;
        int threshold = self.audienceRatingThresholdSliderOutlet.value * 100;
        self.audienceRatingThresholdLabel.text = [[NSNumber numberWithInt:threshold] stringValue];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"varianceThreshold"]) {
        NSNumber *defaultNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"varianceThreshold"];

        float flo =  [defaultNumber floatValue] / 100.f;
        self.ratingVarianceSliderOutlet.value = flo;
        int threshold = self.ratingVarianceSliderOutlet.value * 100;
        self.ratingVarianceLabel.text = [[NSNumber numberWithInt:threshold] stringValue];
    }

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"Settings Page"
                                                      forKey:kGAIScreenName] build]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
//    return 50;
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 10;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    if (indexPath.section == 0) {
//        NSLog(@"1");
//    }
//    
//    if (indexPath.section == 1) {
//        NSLog(@"2");
//    }
//    
//    if (indexPath.section == 2) {
//        NSLog(@"3");
//    }
//    
//    if (indexPath.section == 3) {
//        NSLog(@"4");
//    }
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)mpaaRatingThresholdSliderAction:(id)sender {
    int threshold = [self.mpaaRatingThresholdSliderOutlet value] * 5;
    [self setRatingThresholdLabel:threshold];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:threshold] forKey:@"mpaaRatingThreshold"];
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


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 5) ? NO : YES;
}

- (IBAction)criticsRatingThresholdSliderAction:(id)sender {
    int threshold = self.criticsRatingThresholdSliderOutlet.value * 100;
    self.criticsRatingThresholdLabel.text = [[NSNumber numberWithInt:threshold] stringValue];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:threshold] forKey:@"criticThreshold"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)audienceRatingThresholdSliderAction:(id)sender {
    int threshold = self.audienceRatingThresholdSliderOutlet.value * 100;
    self.audienceRatingThresholdLabel.text = [[NSNumber numberWithInt:threshold] stringValue];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:threshold] forKey:@"audienceThreshold"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)ratingVarianceSliderAction:(id)sender {
    int threshold = self.ratingVarianceSliderOutlet.value * 100;
    self.ratingVarianceLabel.text = [[NSNumber numberWithInt:threshold] stringValue];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:threshold] forKey:@"varianceThreshold"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
