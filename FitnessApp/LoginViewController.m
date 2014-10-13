//
//  LoginViewController.m
//  FitnessApp
//
//  Created by William Chou on 10/7/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import "LoginViewController.h"
#import "WorkoutProgramListTableViewController.h"
#import "WorkoutProgram.h"
#import "WorkoutDay.h"
#import "WorkoutExercise.h"
#import "WorkoutSet.h"
#import <Parse/Parse.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface LoginViewController ()

@property NSMutableArray *WorkoutPrograms;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation LoginViewController


- (void)loadUserData
{
    //query for the WorkoutPrograms by the current user
    PFQuery *query = [PFQuery queryWithClassName:@"WorkoutPrograms"];
    [query whereKey:@"createdBy" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *programs, NSError *error) {
        if (!error)
        {
            //create all the WorkoutPrograms from the data pulled from parse
            for (int i = 0; i < [programs count]; i++)
            {
                PFObject *currProgram = [programs objectAtIndex:i];
                
                //create the current program
                WorkoutProgram *addedProgram = [[WorkoutProgram alloc] init];
                addedProgram.programName = currProgram[@"programName"];
                
                //get the days for that program from arse
                NSMutableArray *programDays = [[NSMutableArray alloc] init];
                programDays = [currProgram objectForKey:@"workoutDayNames"];
                
                //initialize the array for the workout days of the program
                addedProgram.workoutDays = [[NSMutableArray alloc]init];
                
                //create the workout days for each Program
                for(int k = 0 ; k < [programDays count]; k++)
                {
                    //make the WorkoutDay
                    WorkoutDay *addedDay = [[WorkoutDay alloc]init];
                    addedDay.dayName = [programDays objectAtIndex:k];
                    
                    //add the WorkoutDay to the program
                    [addedProgram.workoutDays addObject:addedDay];
                }
                
                //add the program to the array of programs
                [self.WorkoutPrograms addObject:addedProgram];
                
            }
        }
        else
        {
            NSLog(@"Error");
        }
    }];

}


- (IBAction)loginAction:(id)sender
{
    NSString *enteredUsername = self.usernameTextField.text;
    NSString *enteredPassword = self.passwordTextField.text;
    
    [PFUser logInWithUsernameInBackground:enteredUsername password:enteredPassword
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            NSLog(@"successful login");
                                            [self performSegueWithIdentifier:@"loginToProgram" sender:self];
                                        } else {
                                            // The login failed. Check error to see why.
                                            NSLog(@"login failed");
                                        }
                                    }];
}

- (IBAction)logoutUser:(UIStoryboardSegue *) segue
{
    [PFUser logOut];
}

- (IBAction)unwindToLoginFromCreateAccount:(UIStoryboardSegue *) segue
{
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.borderWidth = 1;
    self.loginButton.layer.borderColor = UIColorFromRGB(0x305BAB).CGColor;
    
    self.usernameTextField.layer.cornerRadius = 2;
    self.usernameTextField.layer.borderWidth = 1;
    self.usernameTextField.layer.borderColor = UIColorFromRGB(0xEEEEEE).CGColor;
    
    self.passwordTextField.layer.cornerRadius = 2;
    self.passwordTextField.layer.borderWidth = 1;
    self.passwordTextField.layer.borderColor = UIColorFromRGB(0xEEEEEE).CGColor;
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    
    
    //if the user is already logged in, move to new program view controller
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser)
    {
        NSLog(@"user is logged in");
        NSLog(@"%@", currentUser.username);
        
        //hide the textfields and buttons, if the user is already logged in
        //show activity indicator and begin querying all data
        [self.usernameTextField setHidden:YES];
        [self.passwordTextField setHidden:YES];
        [self.loginButton setHidden:YES];
        [self.createAccountButton setHidden:YES];
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];
        
        
        
        
        [self performSegueWithIdentifier:@"loginToProgram" sender:self];
        
    } else {
        // show the signup or login screen
    }
     
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //set background image
    /*
    UIImage *backgroundImage = [UIImage imageNamed:@"weightwallpaper2.png"];
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
     */
    
    //UIImage *buttonImage = [[UIImage imageNamed:@"blueButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    //UIImage *buttonImageHighlight = [[UIImage imageNamed:@"greyButtonHighlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    //[self.loginButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    //[self.loginButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
