//
//  LoginViewController.h
//  FitnessApp
//
//  Created by William Chou on 10/7/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController


- (IBAction)unwindToLoginFromCreateAccount:(UIStoryboardSegue *) segue;
- (IBAction)logoutUser:(UIStoryboardSegue *) segue;


@end
