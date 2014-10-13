//
//  ExercisesTableViewController.m
//  FitnessApp
//
//  Created by William Chou on 8/8/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import "ExercisesTableViewController.h"
#import "WorkoutExercise.h"
#import "AddNewExerciseViewController.h"
#import "ViewWeightRepTableViewController.h"
#import "WorkoutSet.h"
#import "ExercisesTableViewCell.h"
#import "NewLogViewController.h"
#import <Parse/Parse.h>

@interface ExercisesTableViewController ()

@property NSInteger testCount;
@property WorkoutExercise *selectedExercise;
@property NSMutableArray *selectedReps;
@property NSMutableArray *selectedWeights;
@property NSMutableArray *selectedSets;
@property NSMutableArray *temporarySets;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



@end

@implementation ExercisesTableViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segueFromExercisesToSetWeight"])
    {
        //get the index path that is selected
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell*)sender];
        
        //get the exercise that was selected
        self.selectedExercise = [self.exercises objectAtIndex:indexPath.row];
        
        //with the exercise that was selected, get the corresponding sets
        self.selectedSets = [[NSMutableArray alloc] init];
        self.selectedSets = [NSMutableArray arrayWithArray:self.selectedExercise.workoutSets];
        
        //UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        
        //send the appropriate workout weights and reps to the ViewWeightRepTableViewController
        //ViewWeightRepTableViewController *controller = (ViewWeightRepTableViewController *)navController.topViewController;
        
        ViewWeightRepTableViewController *controller = (ViewWeightRepTableViewController *)segue.destinationViewController;
        controller.workoutSets = self.selectedSets;
        controller.selectedExercise = self.selectedExercise;
    }
    if([segue.identifier isEqualToString:@"segueToNewLog"])
    {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        
        //send the list of workouts to the NewLogViewController
        NewLogViewController *controller = (NewLogViewController *)navController.topViewController;
        controller.workoutExercises = [NSMutableArray arrayWithArray:self.exercises];
    }
}

/*
- (IBAction)returnToDays:(id)sender {
    [self performSegueWithIdentifier:@"unwindToDayListFromExercises" sender:self];
}
 */



- (IBAction)unwindToExercisesfromWeightRep:(UIStoryboardSegue *)segue
{
    //retrieve the source viewc controller
    ViewWeightRepTableViewController *source = [segue sourceViewController];
    
    //initialize the array to retrieve the WorkoutSets from the source view controller
    NSMutableArray *tempSets = source.workoutSets;
    
    //store the sets in a temporary global array
    self.temporarySets = [[NSMutableArray alloc] init];
    self.temporarySets = tempSets;
    
    //store the sets in the selected day
    self.selectedExercise.workoutSets = [NSMutableArray arrayWithArray:self.temporarySets];
}

- (IBAction)unwindToExercisesFromAddExercises:(UIStoryboardSegue *)segue
{
    //get the source view controller
    AddNewExerciseViewController *source = [segue sourceViewController];
    WorkoutExercise *exercise = source.workoutExercise;
    
    //check if cancel button was pressed, or if no text was entered
    if(exercise!=nil)
    {
        //add the newly workout exercise
        [self.exercises addObject:exercise];
        
        //refresh the table
        [self.tableView reloadData];
        
        
        
        //----------begin query here----------
        //update the exercise for the specific WorkoutDay Class
        //first get the day name without spaces
        NSString *dayNameWithoutSpaces = [self.selectedDay.dayName stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        //find that class with that particular day name
        PFQuery *query = [PFQuery queryWithClassName:dayNameWithoutSpaces];
        [query whereKey:@"createdBy" equalTo:[PFUser currentUser]];
        //[query whereKey:@"exerciseNames" equalTo:exercise.exerciseName];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error)
            {
                //successful find
                NSLog(@"Successfully retrieved the workout day");
                [object addObject:exercise.exerciseName forKey:@"exerciseNames"];
                [object saveInBackground];
            }
            else
            {
                NSLog(@"Error");
            }
        }];
    
        //----------end query----------
        
        
        //----build new class based on new exercise----
        //get the exercise name without spaces
        NSString *exerciseNameWithoutSpaces = [exercise.exerciseName stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        //also create a new WorkoutExercise class in parse
        PFObject *newExercise = [PFObject objectWithClassName:exerciseNameWithoutSpaces];
        [newExercise setObject:[PFUser currentUser] forKey:@"createdBy"];
        newExercise[@"setCount"] = exercise.setCount;
        newExercise[@"repCount"] = exercise.repCount;
        newExercise[@"repArray"] = [[NSMutableArray alloc] init];
        newExercise[@"weightArray"] = [[NSMutableArray alloc] init];
        newExercise[@"dateCompleted"] = @"N/A";
        [newExercise saveInBackground];
        //----------finish build----------
    }
}

- (IBAction)unwindToExercisesFromNewLog:(UIStoryboardSegue *)segue
{
    //get the source view controller
    NewLogViewController *source = [segue sourceViewController];
    
    //get the new log of exercises and sets
    self.exercises = [NSMutableArray arrayWithArray:source.workoutExercises];
    
    //print the exercises to see if it worked
    //[self printAllExercises];
}


-(void)printAllExercises
{
    for(int i = 0; i < [self.exercises count]; i++)
    {
        WorkoutExercise *currExercise = [self.exercises objectAtIndex:i];
        
        for(int j = 0; j < [currExercise.setCount intValue]; j++)
        {
            NSString *exerciseMessage = [@"Current exercise: " stringByAppendingString:currExercise.exerciseName];
            NSLog(@"%@", exerciseMessage);
            
            //NSLog(@"%d", [currExercise.setCount intValue]);
            
            WorkoutSet *currSet = [currExercise.workoutSets objectAtIndex:j];
            
            NSLog(@"%@", currSet.weight);
            NSString *weightMessage = [@"weight : " stringByAppendingString:currSet.weight];
            NSLog(@"%@", weightMessage);
            
            NSString *repMessage = [@"rep: " stringByAppendingString:currSet.rep];
            NSLog(@"%@",repMessage);
         
        }
    }
}




- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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


-(void) loadInitialData
{
    //get the selected Day
    //retrieve the exercises for that Day
    //create WorkoutExercises from the query result
    //add the exercises to the array of exercises for that day
    
    NSString *selectedDayWithoutSpaces = [self.selectedDay.dayName stringByReplacingOccurrencesOfString:@" " withString:@""];
    PFQuery *query = [PFQuery queryWithClassName:selectedDayWithoutSpaces];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *day, NSError *error) {
        if (!error)
        {
            //successful find
            NSLog(@"Successfully retrieved the exercises");
            
            //get all the exercises names for the day from parse
            NSMutableArray *dayExercises = [[NSMutableArray alloc] init];
            dayExercises = [day objectForKey:@"exerciseNames"];
            
            //initialize the array for the workout exercises of the day
            self.selectedDay.workoutExercises = [[NSMutableArray alloc] init];
            
            //create the workout exercises for each Program
            for(int k = 0 ; k < [dayExercises count]; k++)
            {
                //make the WorkoutExercises
                WorkoutExercise *addedExercise = [[WorkoutExercise alloc]init];
                addedExercise.exerciseName = [dayExercises objectAtIndex:k];
                addedExercise.repCount = @"";
                addedExercise.setCount = @"";
                
                //get the repCount and setCount from
                //-----query for the exercise class-----
                NSString *exerciseNameWithoutSpaces = [addedExercise.exerciseName stringByReplacingOccurrencesOfString:@" " withString:@""];
                PFQuery *repsetQuery = [PFQuery queryWithClassName:exerciseNameWithoutSpaces];
                
                [repsetQuery getFirstObjectInBackgroundWithBlock:^(PFObject *exercise, NSError *error) {
                    if(!error)
                    {
                        NSLog(@"Successfully retrieved the set and rep counts");
                        addedExercise.repCount = exercise[@"repCount"];
                        addedExercise.setCount = exercise[@"setCount"];
                    }
                    else
                    {
                        NSLog(@"Error");
                    }
                    [self.tableView reloadData];
                    
                }];
                //-----finish query for the exercise class-----
                
                
                //add the WorkoutExercise to the program
                [self.selectedDay.workoutExercises addObject:addedExercise];
            }
            self.exercises = [NSMutableArray arrayWithArray:self.selectedDay.workoutExercises];
            //[self.tableView reloadData];
        }
        else
        {
            NSLog(@"Error");
        }
    }];
}


- (void)viewDidLoad
{
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [super viewDidLoad];
    
    //set the title of the navigation bar
    self.navigationItem.title = self.selectedDay.dayName;
    
    //[self colorNavigationStatusBar];
    [self loadInitialData];
}

//allow the toolbar to appear
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:YES];
}

//allow the toolbar to disappear when the view is not loaded
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.exercises count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    
    ExercisesTableViewCell *cell = (ExercisesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ExercisesCell" forIndexPath:indexPath];
    
    /*
    //set the cell that should be displayed
    WorkoutExercise *currExercise = [self.exercises objectAtIndex:indexPath.row];
    cell.textLabel.text = currExercise.exerciseName;
    cell.imageView.image = [UIImage imageNamed:@"dumbbellthumbnail.jpeg"];
     */
    
    WorkoutExercise *currExercise = [self.exercises objectAtIndex:indexPath.row];
    
    //set the exercise name label
    cell.exerciseNameLabel.text = currExercise.exerciseName;
    

    //set the sets label text
    cell.setsLabel.text = [@"Sets: " stringByAppendingString:currExercise.setCount];
    
    //set the reps label text
    cell.repsLabel.text = [@"Reps: " stringByAppendingString:currExercise.repCount];
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
