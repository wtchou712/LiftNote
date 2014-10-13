//
//  WorkoutProgramListTableViewController.m
//  FitnessApp
//
//  Created by William Chou on 7/8/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import "WorkoutProgramListTableViewController.h"
#import "WorkoutProgram.h"
#import "AddNewProgramViewController.h"
#import "WorkoutDayListTableViewController.h"
#import "WorkoutDay.h"
#import "UnwindLeftToRightSegue.h"
#import <Parse/Parse.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface WorkoutProgramListTableViewController ()

@property NSMutableArray *WorkoutPrograms;
@property WorkoutProgram *selectedProgram;
@property NSMutableArray *selectedDays;
@property NSMutableArray *temproraryDays;
@property NSString *testName;
@property NSInteger *testCount;

@property(nonatomic, retain) UIColor *barTintColor;

@end

@implementation WorkoutProgramListTableViewController


//pass the correct data of the workout program
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segueToDayList"])
    {
        //get the index path taht is selected
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell*)sender];
        
        //get the program that was selected
        self.selectedProgram = [self.WorkoutPrograms objectAtIndex:indexPath.row];
        
        //initialize the selected days and then copy the days from the selected program
        //to the selectedDays array
        self.selectedDays = [[NSMutableArray alloc] init];
        self.selectedDays = [NSMutableArray arrayWithArray:self.selectedProgram.workoutDays];
        
    
        //UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        //WorkoutDayListTableViewController *controller = (WorkoutDayListTableViewController *)navController.topViewController;
        
        WorkoutDayListTableViewController *controller = (WorkoutDayListTableViewController *)segue.destinationViewController;
        
        //send the appropriate workout days to the workoutDay array in WorkoutDayListViewController
        controller.workoutDays = self.selectedDays;
        controller.selectedProgram = self.selectedProgram.programName;
        
        NSLog(@"Data has been passed");
    }
    NSLog(@"prepare for segue called");
}



//unwinds to Program list from Day list
- (IBAction)unwindToProgramFromDayList:(UIStoryboardSegue *) segue;
{
    //retrieve the source view controller
    WorkoutDayListTableViewController *source = [segue sourceViewController];
    
    //initialize the array
    //retrieve the array from WorkoutDayListTableViewController
    NSMutableArray *tempDays = source.workoutDays;
    
    
    //store the days in a temporary array
    self.temproraryDays = [[NSMutableArray alloc] init];
    self.temproraryDays = tempDays;
    
    //store the days in the selected program
    self.selectedProgram.workoutDays = [NSMutableArray arrayWithArray:self.temproraryDays];
    
    
    //test to make sure that all the objects are returned
    //prints out all the Workout days of the selected program
    /*FOR TESTING PURPOSES
    for (int x = 0; x < [self.temproraryDays count]; x++)
    {
        WorkoutDay *day = [self.temproraryDays objectAtIndex:x];
        NSString *dayLabel = day.dayName;
        NSLog(dayLabel);
    }
    */
    
}



//unwinds to Program list from Adding Program view controller
- (IBAction)unwindToProgramListFromAddProgram:(UIStoryboardSegue *) segue;
{
    //retrieve the source view controller
    AddNewProgramViewController *source = [segue sourceViewController];
    
    //retrieve the controller's to do item
    WorkoutProgram *program = source.addedProgram;

    
    //check if the added program either has no text or the Cancel button closed the screen
    if (program != nil)
    {
        //add the item to teh WorkoutPrograms array
        [self.WorkoutPrograms addObject:program];
        
        //reload the data
        [self.tableView reloadData];
        
        //save the new program to Parse
        PFObject *newProgram = [PFObject objectWithClassName:@"WorkoutPrograms"];
        [newProgram setObject:[PFUser currentUser] forKey:@"createdBy"];
        newProgram[@"programName"] = program.programName;
        [newProgram saveInBackground];
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



-(void)viewWillAppear:(BOOL)animated
{
    //[self.navigationController setToolbarHidden:NO animated:YES];
    //hide the back button
    [self.navigationItem setHidesBackButton:YES animated:NO];
}



-(void)viewWillDisappear:(BOOL)animated
{
    //[self.navigationController setToolbarHidden:YES animated:YES];
}



- (void)modifyNavigationBar
{
    //color the navigation bar
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x5A84E5);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //hide the back botton
    self.navigationItem.hidesBackButton = YES;
}



- (void)loadInitialData
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
                NSMutableArray *programDays = [[NSMutableArray alloc] init];
                programDays = [currProgram objectForKey:@"workoutDayNames"];
                
                //create the current program
                WorkoutProgram *addedProgram = [[WorkoutProgram alloc] init];
                addedProgram.programName = currProgram[@"programName"];
                
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
            [self.tableView reloadData];
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
    
    
    self.WorkoutPrograms = [[NSMutableArray alloc] init];
    [super viewDidLoad];
    [self loadInitialData];
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
    // Return the number of sections.
    //you only want one section so return 1
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section
    //return the number of items in the WorkourPrograms array
    return [self.WorkoutPrograms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //type of table cell view
    //static NSString *CellIdentifier = @"ListPrototypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    
    
    //Show the cells and their name labels
    WorkoutProgram *program = [self.WorkoutPrograms objectAtIndex:indexPath.row];
    cell.textLabel.text = program.programName;
    
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
