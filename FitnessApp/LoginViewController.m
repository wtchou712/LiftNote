//
//  LoginViewController.m
//  FitnessApp
//
//  Created by William Chou on 10/7/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import "LoginViewController.h"
#import "WorkoutProgramListTableViewController.h"
#import <Parse/Parse.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController


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
