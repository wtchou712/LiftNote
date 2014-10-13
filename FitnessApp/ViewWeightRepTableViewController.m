//
//  ViewWeightRepTableViewController.m
//  FitnessApp
//
//  Created by William Chou on 8/14/14.
//  Copyright (c) 2014 William Chou. All rights reserved.
//

#import "ViewWeightRepTableViewController.h"
#import "WorkoutSet.h"
//#import "AddNewWeightRepViewController.h"
#import "WeightRepTableViewCell.h"
#import "DateSetsClass.h"
#import <Parse/Parse.h>

static NSString * const WeightRepCellIdentifier = @"WeightRepCell";

@interface ViewWeightRepTableViewController ()

@property NSString *currentSetDate;
@property NSString *comparedDate;
@property NSMutableArray *cellArray;
@property DateSetsClass *addCell;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



@end

@implementation ViewWeightRepTableViewController

-(void)organizeSetsDates
{
    //initialize the addCell
    self.addCell = [[DateSetsClass alloc] init];
    
    //create an int that will keep track of the set count for a particular date
    int setCount = 1;
    
    NSLog(@"number of sets: ");
    NSLog(@"%lu", (unsigned long) (unsigned long)[self.workoutSets count]);
    
    for (int i = 0; i < [self.workoutSets count]; i++)
    {
        
        //get the current set and date
        WorkoutSet *currSet = [self.workoutSets objectAtIndex:i];
        self.currentSetDate = currSet.dateCompleted;
        
        if(i == 0)
        {
            //store the date string
            self.addCell.setDate = currSet.dateCompleted;
            
            //store the weight, rep of the currSet as a string ( 1. 4 x 35lbs )
            NSString *setCountString = [NSString stringWithFormat:@"%d", setCount];
            setCountString = [setCountString stringByAppendingString:@". "];
            NSString *addedString = [setCountString stringByAppendingString:currSet.rep];
            addedString = [addedString stringByAppendingString:@" x "];
            addedString = [addedString stringByAppendingString:currSet.weight];
            addedString = [addedString stringByAppendingString:@"lbs"];
            
            //set the DateSetsClass string to the created one
            self.addCell.setsList = addedString;
            NSLog(@"%@", self.addCell.setsList);
            
            //increase setCount counter
            setCount++;
            
            //set the compare date
            self.comparedDate = currSet.dateCompleted;
        }
        else
        {
            //since the sets are already ordered in most recent at the front of the array
            //compare if the currSet date is the same string, if not it is an earlier date
            
            //if the two dates are same
            if ([self.currentSetDate isEqualToString:self.comparedDate])
            {
                //change the setsLists of the previous DateSetsClass by adding this currSet
                NSString *setCountString = [NSString stringWithFormat:@"%d", setCount];
                setCountString = [setCountString stringByAppendingString:@". "];
                NSString *addedString = [@"\n" stringByAppendingString:setCountString];
                addedString = [addedString stringByAppendingString:currSet.rep];
                addedString = [addedString stringByAppendingString:@" x "];
                addedString = [addedString stringByAppendingString:currSet.weight];
                addedString = [addedString stringByAppendingString:@"lbs"];
                
                //append this set to the DateSetsClass string
                self.addCell.setsList = [self.addCell.setsList stringByAppendingString:addedString];
                NSLog(@"%@", self.addCell.setsList);
                
            }
            //if the two dates are not equal
            else
            {
                NSLog(@"dates not equal");
                
                //reset the setCount
                setCount = 1;
                
                //add the cell to the cellArray, so we can create a new one
                [self.cellArray addObject:self.addCell];
                
                //create a new cell
                self.addCell = [[DateSetsClass alloc] init];
                
                //set the date for the new cell
                self.addCell.setDate = currSet.dateCompleted;
                
                //create the weight, rep of the currSet as a string ( 1. 4 x 35lbs )
                NSString *setCountString = [NSString stringWithFormat:@"%d", setCount];
                setCountString = [setCountString stringByAppendingString:@". "];
                NSString *addedString = [setCountString stringByAppendingString:currSet.rep];
                addedString = [addedString stringByAppendingString:@" x "];
                addedString = [addedString stringByAppendingString:currSet.weight];
                addedString = [addedString stringByAppendingString:@"lbs"];
                
                //set the DateSetsClass string to the created one
                self.addCell.setsList = addedString;
                NSLog(@"%@", self.addCell.setsList);
                
            }
            
            //increase the counter
            setCount++;
        }
    }
    
    //add the last cell to the cellArray
    [self.cellArray addObject:self.addCell];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
- (IBAction)returnToExercises:(id)sender {
    [self performSegueWithIdentifier:@"unwindToExercisesFromWeightRep" sender:self];
}
 */

- (void)colorNavigationStatusBar
{
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x5A84E5);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

-(void)loadInitialData
{
    //get the exercise name without spaces
    NSString *exerciseNameWithoutSpaces = [self.selectedExercise.exerciseName stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //begin a query to get that exercise class
    PFQuery *query = [PFQuery queryWithClassName:exerciseNameWithoutSpaces];
    
    //get all objects except the one that has dateCompleted = "N/A"
    [query whereKey:@"dateCompleted" notEqualTo:@"N/A"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *sets, NSError *error) {
        if(!error)
        {
            //initialize array of WorkoutSets
            self.selectedExercise.workoutSets = [[NSMutableArray alloc] init];
            
            for(int i = 0; i <[sets count]; i++)
            {
                //get the log of the exercise for one day
                PFObject *object = [sets objectAtIndex:i];
                NSMutableArray *repArray = [[NSMutableArray alloc]init];
                NSMutableArray *weightArray = [[NSMutableArray alloc]init];
                repArray = [object objectForKey:@"repArray"];
                weightArray = [object objectForKey:@"weightArray"];
                
                //create a WorkoutSet for each rep and weight for that date
                for(int k = 0; k < [repArray count]; k++)
                {
                    //create the WorkoutSet
                    WorkoutSet *addedSet = [[WorkoutSet alloc]init];
                    addedSet.rep = [repArray objectAtIndex:k];
                    addedSet.weight = [repArray objectAtIndex:k];
                    addedSet.dateCompleted = [object objectForKey:@"dateCompleted"];
                    
                    NSLog(@"rep: ");
                    NSLog(@"%@", addedSet.rep);
                    NSLog(@"weight: ");
                    NSLog(@"%@", addedSet.weight);
                    
                    //add it to the array of WorkoutSets
                    [self.selectedExercise.workoutSets addObject:addedSet];
                }
            }
        }
        else
        {
            NSLog(@"Error");
        }
        self.workoutSets = [NSMutableArray arrayWithArray:self.selectedExercise.workoutSets];
        [self organizeSetsDates];
        [self.tableView reloadData];
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //set the title of the navigation bar
    self.navigationItem.title = self.selectedExercise.exerciseName;
    
    //[self colorNavigationStatusBar];
    [self loadInitialData];
    self.cellArray = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return [self.workoutSets count];
    
    //return the number of items in the cellArray
    return [self.cellArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self basicCellAtIndexPath:indexPath];
}

//function for creating the basic WeightRepTableViewCell
- (WeightRepTableViewCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath
{
    WeightRepTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:WeightRepCellIdentifier forIndexPath:indexPath];
    [self configureBasicCell:cell atIndexPath:indexPath];
    return cell;
}

//function to call other functions that will set the text for the workout sets and dates
- (void)configureBasicCell:(WeightRepTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    DateSetsClass *currItem = [self.cellArray objectAtIndex:indexPath.row];
    [self setDateForCell:cell item:currItem];
    [self setSetsForCell:cell item:currItem];

}

//function to set the date for the cell
- (void)setDateForCell:(WeightRepTableViewCell *)cell item:(DateSetsClass *)item
{
    NSString *date = item.setDate;
    [cell.dateLabel setText:date];
}

//function to set the weight, rep and set for the cell
-(void)setSetsForCell:(WeightRepTableViewCell *)cell item:(DateSetsClass *)item
{
    NSString *sets = item.setsList;
    [cell.weightRepLabel setText:sets];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForWeightRepCellAtIndexPath:indexPath];
}

//configures the cell and then calls function to calculate the height for the cell
- (CGFloat)heightForWeightRepCellAtIndexPath:(NSIndexPath *)indexPath
{
    static WeightRepTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:WeightRepCellIdentifier];
    });
    
    [self configureBasicCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

//request the cell to lay out its content
//then auto layout calculates the smallest possible size that fits the auto layout constraints
-(CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell
{
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
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
