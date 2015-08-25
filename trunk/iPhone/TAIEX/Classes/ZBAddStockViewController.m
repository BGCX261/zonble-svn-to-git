//
//  ZBAddStockViewController.m
//  TAIEX
//
//  Created by zonble on 2008/12/24.
//  Copyright 2008 zonble.twbbs.org. All rights reserved.
//

#import "ZBAddStockViewController.h"
#import "ZBStockTableViewCell.h"
#import "ZBArrayController.h"
#import "TAIEXAppDelegate.h"

static ZBAddStockViewController *addStockViewController;

@implementation ZBAddStockViewController

@synthesize searchBar;
@synthesize tableView;

+ (id)sharedController
{
	if (!addStockViewController)
		addStockViewController = [[ZBAddStockViewController alloc] initWithNibName:@"ZBAddStockViewController" bundle:[NSBundle mainBundle]];
	return addStockViewController;
}
- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
}
- (void)dealloc 
{
	[_stockArray release];
	[_listedArray release];
    [super dealloc];
}
- (void)addStockWithName:(NSString *)name stockID:(NSString *)stockID
{
	NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", stockID, @"stockID", nil];
	[_stockArray addObject:d];
}
- (void)addStockFromFile:(NSString *)filename
{
	NSString *s = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
	NSArray *a = [s componentsSeparatedByString:@"\n"];
	for (NSString *line in a) {
		line = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		NSArray *lineArray = [line componentsSeparatedByString:@" "];
		if ([lineArray count] >= 2) {
			NSString *stockID = [lineArray objectAtIndex:0];
			NSString *name = [lineArray objectAtIndex:1];
			[self addStockWithName:name stockID:stockID];
		}
	}
}
- (void)loadArray
{
	_stockArray = [NSMutableArray new];
	_listedArray = [NSMutableArray new];	
	NSString *stock1Filename = [[NSBundle mainBundle] pathForResource:@"stock1" ofType:@"txt"];
	[self addStockFromFile:stock1Filename];
	NSString *stock2FileName = [[NSBundle mainBundle] pathForResource:@"stock2" ofType:@"txt"];
	[self addStockFromFile:stock2FileName];
}
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
	self = [super initWithNibName:nibName bundle:nibBundle];
	if (self != nil) {
		[self loadArray];
	}
	return self;
}
- (void)viewDidLoad 
{
    [super viewDidLoad];
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[searchBar becomeFirstResponder];
	[searchBar setText:nil];
	[_listedArray removeAllObjects];
	[tableView reloadData];
}
- (IBAction)closeAction:(id)sender
{
	TAIEXAppDelegate *controller = [[UIApplication sharedApplication] delegate];
	[controller hideAddStockView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)aTableView  numberOfRowsInSection:(NSInteger)section
{
	return [_listedArray count];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
    
    ZBStockTableViewCell *cell = (ZBStockTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ZBStockTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSDictionary *d = [_listedArray objectAtIndex:indexPath.row];
	NSString *name = [d valueForKey:@"name"];
	NSString *stockID = [d valueForKey:@"stockID"];
	
	cell.nameLabel.text = name;
	cell.stockIDLabel.text = stockID;
	cell.priceLabel.text = nil;
	cell.updownLobel.text = nil;
	
    return cell;
}
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSDictionary *d = [_listedArray objectAtIndex:indexPath.row];
	NSString *name = [d valueForKey:@"name"];
	NSString *stockID = [d valueForKey:@"stockID"];
	
	[[ZBArrayController sharedController] addStockWithName:name stockID:stockID];
	[self closeAction:self];
}

- (void)filterArrayWithKeyword:(NSString *)keyword
{
	[_listedArray removeAllObjects];
	if ([keyword length]) {
		for (NSDictionary *d in _stockArray) {
			NSString *name = [d valueForKey:@"name"];
			NSString *stockID = [d valueForKey:@"stockID"];
			if ([name rangeOfString:keyword].location != NSNotFound || [stockID hasPrefix:keyword])
				[_listedArray addObject:d];
		}
	}
	[tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar
{
	NSString *keyword = [[aSearchBar text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	[self filterArrayWithKeyword:keyword];
	[aSearchBar resignFirstResponder];
}

@end
