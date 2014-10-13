//
//  ViewWeightRepTableViewController.h
//  FitnessApp
//
//  Created by William Chou on 8/14/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutExercise.h"

@interface ViewWeightRepTableViewController : UITableViewController


@property NSMutableArray *workoutSets;
@property WorkoutExercise *selectedExercise;


@end
