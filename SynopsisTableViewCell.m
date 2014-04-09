//
//  SynopsisTableViewCell.m
//  Film Heat
//
//  Created by Spencer Fornaciari on 4/7/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SynopsisTableViewCell.h"

@implementation SynopsisTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
