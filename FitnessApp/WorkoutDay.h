//
//  WorkoutDay.h
//  FitnessApp
//
//  Created by William Chou on 7/24/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkoutExercise.h"



@interface WorkoutDay : NSObject

@property NSString *dayName; //name of the workout day
@property NSMutableArray *workoutExercises; //array of what will be all the exercises for one workout day


@end
