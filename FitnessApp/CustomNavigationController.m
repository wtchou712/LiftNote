//
//  CustomNavigationController.m
//  FitnessApp
//
//  Created by William Chou on 9/30/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import "CustomNavigationController.h"
#import "UnwindLeftToRightSegue.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController
                                      fromViewController:(UIViewController *)fromViewController
                                              identifier:(NSString *)identifier {
    
    // Check the identifier and return the custom unwind segue if this is an
    // unwind we're interested in
    if ([identifier isEqualToString:@"unwindToProgramFromDay"] || [identifier isEqualToString:@"unwindToDayListFromExercises"]
        || [identifier isEqualToString:@"unwindToExercisesFromWeightRep"])
    {
        UnwindLeftToRightSegue *segue = [[UnwindLeftToRightSegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
        return segue;
    }
    return [super segueForUnwindingToViewController:toViewController fromViewController:fromViewController identifier:identifier];
    
    NSLog(@"unwind segue is caled");
}

@end
