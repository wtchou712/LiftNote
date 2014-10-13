//
//  AddNewExerciseViewController.m
//  FitnessApp
//
//  Created by William Chou on 8/8/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import "AddNewExerciseViewController.h"

@interface AddNewExerciseViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITextField *exerciseTextField;
@property (weak, nonatomic) IBOutlet UITextField *setTextField;
@property (weak, nonatomic) IBOutlet UITextField *repsTextField;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



@end

@implementation AddNewExerciseViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //if the done button isnt pressed, return without doing anything
    if(sender != self.doneButton) return;
    
    //if there's text, create a new WorkoutExercise
    if(self.exerciseTextField.text.length >0 && self.setTextField.text.length >0 && self.repsTextField.text.length>0)
    {
        //get the exercise name
        self.workoutExercise = [[WorkoutExercise alloc] init];
        self.workoutExercise.exerciseName = self.exerciseTextField.text;
        
        //get the inputted set count
        self.workoutExercise.setCount = self.setTextField.text;
        
        //get the inputted rep count
        self.workoutExercise.repCount = self.repsTextField.text;
    }
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)colorNavigationStatusBar
{
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x5A84E5);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self colorNavigationStatusBar];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
