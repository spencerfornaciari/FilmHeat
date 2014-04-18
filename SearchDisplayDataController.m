//
//  SearchDisplayDataController.m
//  Film Heat
//
//  Created by Spencer Fornaciari on 4/18/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SearchDisplayDataController.h"
#import "SFMCTableViewCell.h"

@implementation SearchDisplayDataController

-(id)init
{
    if (self = [super init]) {
        self.searchArray = [NSMutableArray new];
    }
    return self;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView registerClass:[SFMCTableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    SFMCTableViewCell *cell = [[SFMCTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    NSString *title = [self.searchArray[indexPath.row] title];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

@end
