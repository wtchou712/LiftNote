//
//  WorkoutProgramListTableViewController.h
//  FitnessApp
//
//  Created by William Chou on 7/8/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutDayListTableViewController.h"




@interface WorkoutProgramListTableViewController : UITableViewController 


- (IBAction)unwindToProgramListFromAddProgram:(UIStoryboardSegue *) segue;
- (IBAction)unwindToProgramFromDayList:(UIStoryboardSegue *) segue;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;


@end
