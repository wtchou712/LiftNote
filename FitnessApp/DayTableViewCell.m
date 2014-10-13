//
//  DayTableViewCell.m
//  FitnessApp
//
//  Created by William Chou on 8/28/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import "DayTableViewCell.h"

@implementation DayTableViewCell

@synthesize dayLabel;
@synthesize lastCompletedLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
