//
//  AddNewProgramViewController.m
//  FitnessApp
//
//  Created by William Chou on 7/8/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import "AddNewProgramViewController.h"


@interface AddNewProgramViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



@end

@implementation AddNewProgramViewController

//create a new program after tapping the Done button
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //see if done button was tapped
    if (sender!= self.doneButton) return;
    
    //see if there's text in the text field
    if (self.textField.text.length > 0)
    {
        //remember newProgram was declared in the header file
        self.addedProgram = [[WorkoutProgram alloc] init];
        self.addedProgram.programName = self.textField.text;
        self.addedProgram.currProgram = NO;
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
