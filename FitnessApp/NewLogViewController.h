//
//  NewLogViewController.h
//  FitnessApp
//
//  Created by William Chou on 9/2/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutExercise.h"

@interface NewLogViewController : UIViewController

@property NSMutableArray *workoutExercises;
@property NSMutableArray *exercisesCopy;

- (IBAction)nextButtonPress:(id)sender;


@end
