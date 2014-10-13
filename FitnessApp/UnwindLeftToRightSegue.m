//
//  UnwindLeftToRightSegue.m
//  FitnessApp
//
//  Created by William Chou on 9/30/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import "UnwindLeftToRightSegue.h"

@implementation UnwindLeftToRightSegue

-(void)perform
{
    UIView *sourceView = ((UIViewController *)self.sourceViewController).view;
    UIView *destinationView = ((UIViewController *)self.destinationViewController).view;
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    destinationView.center = CGPointMake(sourceView.center.x - sourceView.frame.size.width, destinationView.center.y);
    [window insertSubview:destinationView belowSubview:sourceView];
    
    [UIView animateWithDuration:0.1
                     animations:^{
                         destinationView.center = CGPointMake(sourceView.center.x, destinationView.center.y);
                         sourceView.center = CGPointMake(sourceView.center.x + sourceView.frame.size.width, destinationView.center.y);
                     }
                     completion:^(BOOL finished){
                         [[self destinationViewController] dismissViewControllerAnimated:NO completion:nil];
                     }];
}

@end
