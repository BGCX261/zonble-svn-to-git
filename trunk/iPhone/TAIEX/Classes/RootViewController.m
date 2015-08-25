//
//  RootViewController.m
//  TAIEX
//
//  Created by zonble on 2008/12/24.
//  Copyright zonble.twbbs.org 2008. All rights reserved.
//

#import "RootViewController.h"
#import "TAIEXAppDelegate.h"
#import "ZBStockParser.h"
#import "ZBStockTableViewCell.h"
#import "ZBArrayController.h"
#import "ZBChartViewController.h"

@implementation RootViewController

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
	[[ZBArrayController sharedController] setDelegate:self];
	self.title = [NSString stringWithUTF8String:"陽春台股"];
	
	NSMutableArray *a = [NSMutableArray array];
	[a addObject:_addItem];
	[a addObject:_editItem];
	
	NSString *updateTimeString = [[[NSUserDefaults standardUserDefaults] objectForKey:updateTime] description];
	_updateLabel.text = updateTimeString;
	_updateLabel.font = [UIFont systemFontOfSize:10.0];
	_updateLabel.textColor = [UIColor whiteColor];
	[a addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] autorelease]];
	[a addObject:[[[UIBarButtonItem alloc] initWithCustomView:_updateLabel] autorelease]];
	[a addObject:_updateItem];
	_toolbar.items = a;
	
	[self tableView].backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)dealloc
{
    [super dealloc];
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[self navigationController] navigationBar].barStyle = UIBarStyleDefault;
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	NSArray *array = [[ZBArrayController sharedController] array];
    return [array count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    ZBStockTableViewCell *cell = (ZBStockTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ZBStockTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
 
	NSArray *array = [[ZBArrayController sharedController] array];
	
    // Set up the cell...
	NSDictionary *d = [array objectAtIndex:indexPath.row];
	NSString *name = [d valueForKey:@"name"];
	NSString *stockID = [d valueForKey:@"stockID"];
	NSString *price = [d valueForKey:@"price"];
	if (![price length])
		price = @"--";
	NSString *updown = [d valueForKey:@"updown"];
	if (![updown length]) {
		updown = @"--";		
	}
	else {
		unichar aChar = [updown characterAtIndex:0];
		if (aChar == '+')
			[cell setUp:YES];
		else if (aChar == '-')
			[cell setUp:NO];
	}
	
	
	cell.nameLabel.text = name;
	cell.stockIDLabel.text = stockID;
	cell.priceLabel.text = price;
	cell.updownLobel.text = updown;

    return cell;
}
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSArray *array = [[ZBArrayController sharedController] array];
	NSDictionary *d = [array objectAtIndex:indexPath.row];
	NSString *stockID = [d valueForKey:@"stockID"];
	ZBChartViewController *controller = [ZBChartViewController sharedController];
	[[self navigationController] pushViewController:controller animated:YES];
	[controller loadImageOfStockID:stockID];
}
- (BOOL)tableView:(UITableView *)aTableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return YES;
}
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		[[ZBArrayController sharedController] removeAtIndex:indexPath.row];		
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)aTableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)aTableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark Interface Builder actions

- (void)setEditingStatus:(BOOL)flag
{
	if (flag) {
		_editItem.style = UIBarButtonItemStyleDone;
	}
	else {
		_editItem.style = UIBarButtonItemStyleBordered;			
	}
}
- (IBAction)fetchDataAction:(id)sender
{
	[[ZBArrayController sharedController] fetchData];
}
- (IBAction)addStockAction:(id)sender
{
	[tableView setEditing:NO];
	[self setEditingStatus:NO];

	TAIEXAppDelegate *controller = [[UIApplication sharedApplication] delegate];
	[controller showAddStockView];
}
- (IBAction)editAction:(id)sender
{
	[tableView setEditing:!tableView.editing];
	[self setEditingStatus:tableView.editing];
}

- (void)arrayController:(id)controller didAddStockWithName:(NSString *)name stockID:(NSString *)stockID
{
	[tableView reloadData];
}
- (void)arrayControllerFetchDataDidEnd:(id)controller
{
	NSLog(@"arrayControllerFetchDataDidEnd");
	NSDate *date = [NSDate date];
	[[NSUserDefaults standardUserDefaults] setObject:date forKey:updateTime];	
	
	NSString *dateString = [date description];
	_updateLabel.text = dateString;
	[tableView reloadData];	
}
- (void)arrayControllerFetchDataDidFailed:(id)controller
{
	NSLog(@"arrayControllerFetchDataDidFailed");	
	[tableView reloadData];
	_updateLabel.text = @"Failed!";
}



@end

