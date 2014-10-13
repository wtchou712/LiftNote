//
//  DayTableViewCell.h
//  FitnessApp
//
//  Created by William Chou on 8/28/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastCompletedLabel;


@end
