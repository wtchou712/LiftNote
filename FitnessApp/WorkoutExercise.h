//
//  WorkoutExercise.h
//  FitnessApp
//
//  Created by William Chou on 8/8/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkoutSet.h"

@interface WorkoutExercise : NSObject

@property NSString *exerciseName; //name of the exercise
//@property NSString *lastweekWeight; //weight that was used last week
@property NSMutableArray *workoutSets;
@property NSString *setCount;
@property NSString *repCount;
@property NSNumber *maxWeight;



@end
