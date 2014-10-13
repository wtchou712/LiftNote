//
//  WorkoutProgram.h
//  FitnessApp
//
//  Created by William Chou on 7/9/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkoutDay.h"


@interface WorkoutProgram : NSObject


@property NSString *programName; //the programs name
@property BOOL currProgram; //which program you are currently working on
@property (readonly) NSDate *creationDate; //the creation date of the program
@property NSMutableArray *workoutDays; //the workout days of the program


                      

//WorkoutProgram class stores the workoutDays that will be shown on the WorkoutDayListTableViewController


@end
