//
//  NewLogViewController.m
//  FitnessApp
//
//  Created by William Chou on 9/2/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import "NewLogViewController.h"
#import "WorkoutExercise.h"
#import "WorkoutSet.h"
#import <Parse/Parse.h>

@interface NewLogViewController ()

@property (weak, nonatomic) IBOutlet UILabel *exerciseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *setLabel;
@property (weak, nonatomic) IBOutlet UILabel *repsLabel;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UITextField *repsTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property int setCount;
@property int exerciseCount;
@property NSDate *todayDate;
@property NSString *todayDateString;
@property PFObject *savedExercise;


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



@end

@implementation NewLogViewController

- (IBAction)nextButtonPress:(id)sender
{
    if ([sender tag]==1)
    {
        //get current exercise
        WorkoutExercise *currExercise = [self.workoutExercises objectAtIndex:self.exerciseCount];
        
        //create the new set and store the appropriate data
        WorkoutSet *enteredSet = [[WorkoutSet alloc] init];
        enteredSet.rep = self.repsTextField.text; //get the entered rep
        enteredSet.weight = self.weightTextField.text; //get the entered weight
        enteredSet.dateCompleted = self.todayDateString;
        //check if the entered weight is a new PR
        if(currExercise.maxWeight == nil)
        {
            
        }
        
        
        NSLog(@"weight: ");
        NSLog(@"%@", enteredSet.weight);
        NSLog(@"rep: ");
        NSLog(@"%@", enteredSet.rep);
        
        if (self.setCount ==0)  //&& currExercise.workoutSets != nil)
        {
            currExercise.workoutSets = [[NSMutableArray alloc]init];
        }
        
        [currExercise.workoutSets addObject:enteredSet];
        //[currExercise.workoutSets insertObject:enteredSet atIndex:0];
        self.setCount++;
        
        //make a new PFObject for each exercise
        //store the inputted reps and weight for each set
        //save to Parse
        //----------add the WorkoutSet to Parse----------
        //store the inputted reps, weight and date completed for the set
        [self.savedExercise addObject:enteredSet.rep forKey:@"repArray"];
        [self.savedExercise addObject:enteredSet.weight forKey:@"weightArray"];
        [self.savedExercise setObject:[PFUser currentUser] forKey:@"createdBy"];
        self.savedExercise[@"dateCompleted"] = enteredSet.dateCompleted;
        //----------finish update----------
        
        
        //if the last set is the next set, hide the next button
        if(self.setCount+1 >=[currExercise.setCount intValue] && self.exerciseCount + 1 >= [self.workoutExercises count] )
        {
            self.nextButton.hidden = YES;
        }
        
        //if the last set for the current exercise was entered, move to next exercise
        if (self.setCount >= [currExercise.setCount intValue])
        {
            //move to the next exercise
            self.exerciseCount++;
            self.setCount = 0;
            
            //change the labels
            currExercise = [self.workoutExercises objectAtIndex:self.exerciseCount];
            self.exerciseNameLabel.text = currExercise.exerciseName;
            self.repsLabel.text = [@"Recommended Reps: " stringByAppendingString:currExercise.repCount];
            
            //==========save finished exercise to parse==========
            //save finished exercise to parse
            [self.savedExercise saveInBackground];
            
            //create a new PFObject for the next exercise
            NSString *exerciseNameWithoutSpaces = [currExercise.exerciseName stringByReplacingOccurrencesOfString:@" " withString:@""];
            self.savedExercise = [PFObject objectWithClassName:exerciseNameWithoutSpaces];
            self.savedExercise[@"repCount"] = currExercise.repCount;
            self.savedExercise[@"setCount"] = currExercise.setCount;
            //==================================================
        }
        
        //change the set label
        NSString *setCountString = [NSString stringWithFormat:@"%d",self.setCount+1];
        NSString *stringForSetLabel = [@"Set " stringByAppendingString:setCountString];
        stringForSetLabel = [stringForSetLabel stringByAppendingString:@" of "];
        stringForSetLabel = [stringForSetLabel stringByAppendingString:currExercise.setCount];
        self.setLabel.text = stringForSetLabel;
        self.repsTextField.text = @"";
        self.weightTextField.text = @"";
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WorkoutExercise *currExercise = [self.workoutExercises objectAtIndex:self.exerciseCount];
    WorkoutSet *enteredSet = [[WorkoutSet alloc]init];
    if (self.repsTextField.text.length > 0 && self.weightTextField.text.length > 0 )
    {
        enteredSet.rep = self.repsTextField.text;
        enteredSet.weight = self.weightTextField.text;
        enteredSet.dateCompleted = self.todayDateString;
        [currExercise.workoutSets addObject:enteredSet];
        
        /*
        //--------store the WorkoutSet to the appropriate exercise class--------
        //first get the exercise name without spaces
        NSString *exerciseNameWithoutSpaces = [currExercise.exerciseName stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        //find that class with that particular exercise name
        PFQuery *query = [PFQuery queryWithClassName:exerciseNameWithoutSpaces];
        
        //get the PFObject of that exercise class
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error)
            {
                //successful find
                NSLog(@"Successfully retrieved the exercise");
                //add the weight, rep, and date completed
                [object addObject:enteredSet.rep forKey:@"repArray"];
                [object addObject:enteredSet.weight forKey:@"weightArray"];
                object[@"dateCompleted"] = enteredSet.dateCompleted;
                [object saveInBackground];
            }
            else
            {
                NSLog(@"Error");
            }
        }];
        //----------finish query update----------
        */
        
        
        //----------add the WorkoutSet to parse ----------
        //store the inputted reps, weight and date completed for the set
        [self.savedExercise addObject:enteredSet.rep forKey:@"repArray"];
        [self.savedExercise addObject:enteredSet.weight forKey:@"weightArray"];
        [self.savedExercise setObject:[PFUser currentUser] forKey:@"createdBy"];
        self.savedExercise[@"dateCompleted"] = enteredSet.dateCompleted;
        [self.savedExercise saveInBackground];
        //----------finish update----------
         
         
    }
    
}

-(void)loadInitialData
{
    //change shape of button
    self.nextButton.layer.cornerRadius = 5;
    self.nextButton.layer.borderWidth = 1;
    self.nextButton.layer.borderColor = UIColorFromRGB(0x007AFF).CGColor;
    
    if([self.workoutExercises count] > 0)
    {
        WorkoutExercise *currExercise = [self.workoutExercises objectAtIndex:0];
        self.exerciseNameLabel.text = currExercise.exerciseName;
        
        self.setLabel.text = [@"Set 1 of " stringByAppendingString:currExercise.setCount];
        self.repsLabel.text = [@"Recommended Reps: " stringByAppendingString:currExercise.repCount];
        self.exerciseCount = 0;
        self.setCount = 0;
        
        //get the current date
        self.todayDate = [NSDate date];
        
        //formate it
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMM dd, yyyy"];
        
        //convert to string
        self.todayDateString = [dateFormat stringFromDate:self.todayDate];
        
        //update the PFObject to refer to the appropriate exercise
        NSString *exerciseNameWithoutSpaces = [currExercise.exerciseName stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        //ceate the PFObject that will store the first set
        self.savedExercise = [PFObject objectWithClassName:exerciseNameWithoutSpaces];
        [self.savedExercise setObject:[PFUser currentUser] forKey:@"createdBy"];
        self.savedExercise[@"repCount"] = currExercise.repCount;
        self.savedExercise[@"setCount"] = currExercise.setCount;
        
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

- (void)modifyNavigationBar
{
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x5A84E5);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.title = self.todayDateString;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    
    [self modifyNavigationBar];
    
    //load the initial data
    [self loadInitialData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
