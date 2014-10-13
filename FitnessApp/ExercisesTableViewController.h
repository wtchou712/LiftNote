//
//  ExercisesTableViewController.h
//  FitnessApp
//
//  Created by William Chou on 8/8/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutExercise.h"
#import "WorkoutDay.h"

@interface ExercisesTableViewController : UITableViewController

- (IBAction)unwindToExercisesfromWeightRep:(UIStoryboardSegue *)segue;
- (IBAction)unwindToExercisesFromAddExercises:(UIStoryboardSegue *)segue;
- (IBAction)unwindToExercisesFromNewLog:(UIStoryboardSegue *)segue;

@property(nonatomic) NSMutableArray *exercises; //array of the exercises to be displayed
@property(nonatomic) WorkoutDay *selectedDay;


@end
