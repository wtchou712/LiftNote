//
//  AddNewDayViewController.h
//  FitnessApp
//
//  Created by William Chou on 7/25/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutDay.h"
#import "WorkoutProgram.h"

@interface AddNewDayViewController : UIViewController

@property WorkoutDay *workoutDay;
@property NSString *selectedProgram;


@end
