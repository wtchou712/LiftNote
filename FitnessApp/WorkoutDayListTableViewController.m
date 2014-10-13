//
//  WorkoutDayListTableViewController.m
//  FitnessApp
//
//  Created by William Chou on 7/24/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//



//CONCEPT: when a program is tapped, that is the program that is currently selected. The table view will then show all the WorkoutDays for that program.

#import "WorkoutDayListTableViewController.h"
#import "WorkoutDay.h"
#import "AddNewDayViewController.h"
#import "ExercisesTableViewController.h"
#import "DayTableViewCell.h"
#import <Parse/Parse.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface WorkoutDayListTableViewController ()

//@property NSMutableArray *workoutDays;
@property NSInteger loadCount;
@property NSMutableArray *temporaryExercises;
@property WorkoutDay *selectedDay;
@property NSMutableArray *selectedExercises;
@property NSInteger testCount;
@property NSDate *currDate;

@end

@implementation WorkoutDayListTableViewController

-(void)getExercisesForSelectedDay
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
                //NSLog(@"Added Exercise: ");
                //NSLog(@"%@", addedExercise.exerciseName);
                
                
                
                //add the WorkoutExercise to the program
                [self.selectedDay.workoutExercises addObject:addedExercise];
            }
            //[self.tableView reloadData];
        }
        else
        {
            NSLog(@"Error");
        }
    }];

    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //identify the proper segue and send the data
    if([segue.identifier isEqualToString:@"segueFromDaysToExercises"])
    {
        //get the index path taht is selected
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell*)sender];
        
        //get the day that was selected
        self.selectedDay = [self.workoutDays objectAtIndex:indexPath.row];
        //[self getExercisesForSelectedDay];
        
        //with the day that was selected, get the corresponding exercises
        self.selectedExercises = [[NSMutableArray alloc] init];
        self.selectedExercises = [NSMutableArray arrayWithArray:self.selectedDay.workoutExercises];
    
        //UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        
        //send the appropriate workout exercises to the ExercisesTableViewController
        //ExercisesTableViewController *controller = (ExercisesTableViewController *)navController.topViewController;
        
        ExercisesTableViewController *controller = (ExercisesTableViewController *)segue.destinationViewController;
        controller.exercises = self.selectedExercises;
        controller.selectedDay = self.selectedDay;
    }
    
}

/*
//return to the ProgramViewController when the back button is pressed
- (IBAction)returnToProgram:(id)sender {
    [self performSegueWithIdentifier:@"unwindToProgramFromDay" sender:self];
}
 */


- (IBAction)unwindToDayListFromExercises:(UIStoryboardSegue *)segue;
{
    //retrieve the source view controller
    ExercisesTableViewController *source = [segue sourceViewController];
    
    //initialize the array and retrieve from ExercisesTableViewController
    NSMutableArray *tempExercises = source.exercises;
    
    //store the exercises in a temp array
    self.temporaryExercises = [[NSMutableArray alloc] init];
    self.temporaryExercises = tempExercises;
    
    //store the exercises in the selected day
    //[self.selectedDay.workoutExercises removeAllObjects];
    self.selectedDay.workoutExercises = [NSMutableArray arrayWithArray:self.temporaryExercises];

    
    //test that the exercises are sent back
    //FOR TESTING PURPOSES
    /*
    for (int x = 0; x < [self.temproraryExercises count]; x++)
    {
        WorkoutExercise *currExercise = [self.temproraryExercises objectAtIndex:x];
        NSString *exerciseLabel = currExercise.exerciseName;
        NSLog(exerciseLabel);
    }
     */
}


- (IBAction)unwindToDayListFromAddDay:(UIStoryboardSegue *)segue
{
    
    //get the source view controller
    AddNewDayViewController *source = [segue sourceViewController];
    WorkoutDay *day = source.workoutDay;
    
    if (day!= nil)//check if the cancel button is closed or if no text was entered
    {
        //add the object
        [self.workoutDays addObject:day];
        //refresh the table
        [self.tableView reloadData];
        
        //-----begin query to update program-----
        //save the newly added WorkoutDay under the appropriate program
        PFQuery *query = [PFQuery queryWithClassName:@"WorkoutPrograms"];
        [query whereKey:@"createdBy" equalTo:[PFUser currentUser]];
        [query whereKey:@"programName" equalTo:self.selectedProgram];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error)
            {
                //successful find
                NSLog(@"Successfully retrieved the program");
                [object addObject:day.dayName forKey:@"workoutDayNames"];
                [object saveInBackground];
            }
            else
            {
                NSLog(@"Error");
            }
        }];
        //--------finish query--------
        
        
        
        //-----begin building new class based on new day-----
        //remove the spaces from the day name
        NSString *dayNameWithoutSpaces = [day.dayName stringByReplacingOccurrencesOfString:@" " withString:@""];
        //NSLog(@"%@", dayNameWithoutSpaces);
        
        //also, create a new class for that specific WorkoutDay
        PFObject *newDay = [PFObject objectWithClassName:dayNameWithoutSpaces];
        [newDay setObject:[PFUser currentUser] forKey:@"createdBy"];
        newDay[@"exerciseNames"] = [[NSMutableArray alloc] init];
        [newDay saveInBackground];
        //--------finish building--------
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


- (void) loadInitialData //initial data for testing the view
{
    //get the current date
    self.currDate = [NSDate date];
    
    //formate it
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd, yyyy"];
    
    //convert to string
    NSString *dateString = [dateFormat stringFromDate:self.currDate];
    
    //try it
    NSLog(@"Todays date is =%@", dateString);
}

//allow the toolbar to appear

-(void)viewWillAppear:(BOOL)animated
{
    //[self.navigationController setToolbarHidden:NO animated:YES];
}

//allow the toolbar to disappear when the view is not loaded

-(void)viewWillDisappear:(BOOL)animated
{
    //[self.navigationController setToolbarHidden:YES animated:YES];
}


//function for setting all the button images
-(void)setButtonImages
{
    UIImage *backArrow = [[UIImage imageNamed:@"back_button.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.backButton setImage:backArrow];
}

- (NSString *)getLastCompletedDate:(WorkoutDay *)day
{
    //check if there are exercises
    if([day.workoutExercises count] == 0 )
    {
        //no exercises so return "Not yet completed"
        return @"Not yet completed";
    }
    else
    {
        //get the first exercise
        WorkoutExercise *firstExercise = [day.workoutExercises objectAtIndex:0];
        
        //check if there are WorkoutSets in the exercises
        if ([firstExercise.workoutSets count]==0)
        {
            //return if there are no workout sets in the exercise
            return @"Not yet completed";
        }
        else
        {
            //if there are workout sets, see if they've been completed
            WorkoutSet *firstSet = [firstExercise.workoutSets objectAtIndex:0];
            
            //check if the set has a date completed
            if(firstSet.dateCompleted==nil)
            {
                //return nil if there is no date completed for the set
                return @"Not yet completed";
            }
            else
            {
                //return the date completed
                return firstSet.dateCompleted;
            }
            
        }
    }
}

- (void)modifyNavigationBar
{
    /*
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x5A84E5);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
     */
    
    //set the title of the navigation bar
    self.navigationItem.title = self.selectedProgram;
}


- (void)viewDidLoad
{
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    //initialize the workoutDays array
    [super viewDidLoad];
    
    //load the button images
    //[self setButtonImages];

    [self modifyNavigationBar];
    
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
    return [self.workoutDays count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkoutDayCell" forIndexPath:indexPath];
    DayTableViewCell *cell =(DayTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WorkoutDayCell" forIndexPath:indexPath];
    
    //set the cell that should be displayed
    WorkoutDay *day = [self.workoutDays objectAtIndex:indexPath.row];
    cell.dayLabel.text = day.dayName;
    
    //get the last completed day or nil
    NSString *lastCompletedForDay = [self getLastCompletedDate:day];
    
    //append the appropriate string
    cell.lastCompletedLabel.text = [@"Last completed: " stringByAppendingString:lastCompletedForDay];

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
