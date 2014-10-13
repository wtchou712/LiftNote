//
//  WeightRepTableViewCell.m
//  FitnessApp
//
//  Created by William Chou on 8/26/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import "WeightRepTableViewCell.h"

@implementation WeightRepTableViewCell

@synthesize dateLabel;
@synthesize weightRepLabel;

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
