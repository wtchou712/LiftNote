//
//  WorkoutDayListTableViewController.h
//  FitnessApp
//
//  Created by William Chou on 7/24/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExercisesTableViewController.h"


@interface WorkoutDayListTableViewController : UITableViewController

- (IBAction)unwindToDayListFromAddDay:(UIStoryboardSegue *)segue;
- (IBAction)unwindToDayListFromExercises:(UIStoryboardSegue *)segue;


@property(nonatomic) NSMutableArray *workoutDays;//the workout days of the selected program
@property(nonatomic) NSString *selectedProgram; //the selected program
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

@end
