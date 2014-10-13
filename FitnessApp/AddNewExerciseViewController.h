//
//  AddNewExerciseViewController.h
//  FitnessApp
//
//  Created by William Chou on 8/8/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutExercise.h"

@interface AddNewExerciseViewController : UIViewController

@property WorkoutExercise *workoutExercise;
@property int *inputSets;
@property int *inputReps; 

@end
