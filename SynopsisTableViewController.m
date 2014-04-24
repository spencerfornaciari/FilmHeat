//
//  SynopsisTableViewController.m
//  Film Heat
//
//  Created by Spencer Fornaciari on 4/7/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SynopsisTableViewController.h"

@interface SynopsisTableViewController ()

@end

@implementation SynopsisTableViewController

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
    
    self.title = @"Synopsis";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Synopsis View"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SynopsisTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SynopsisCell" forIndexPath:indexPath];
    

    cell.synopsisLabel.text = self.synopsisString;
    cell.synopsisLabel.numberOfLines = 0;
    [cell.synopsisLabel sizeToFit];
    
    return cell;
}


#pragma mark - Setting up dynamic sell heights

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIFont *fontText = [UIFont fontWithName:@"HelveticaNeue" size:17];
    CGSize maximumLabelSize = CGSizeMake(280, CGFLOAT_MAX);
    CGRect textRect = [self.synopsisString boundingRectWithSize:maximumLabelSize
                                             options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                     attributes:@{NSFontAttributeName:fontText}
                                             context:nil];
    
    CGSize requiredSize = textRect.size;
    
    return requiredSize.height + 15;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

@end
