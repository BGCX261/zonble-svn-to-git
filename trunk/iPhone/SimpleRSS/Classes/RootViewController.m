//
//  RootViewController.m
//  Unews
//
//  Created by zonble on 2008/6/16.
//  Copyright zonble.twbbs.org 2008. All rights reserved.
//

#import "RootViewController.h"
#import "RSSAppDelegate.h"
#import "ZBTableViewCell.h"

@implementation RootViewController

- (void)viewDidLoad
{
	// Add the following line if you want the list to be editable
	// self.navigationItem.leftBarButtonItem = self.editButtonItem;
	[[self tableView] setRowHeight:120.0];
	[[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
	[[self tableView] setSeparatorColor:[UIColor blackColor]];

}

- (void)parseURL:(NSURL *)URL
{
	if (!_rss) {
		_rss = [[SimpleRSS alloc] init];
	}
	[_rss parseURL:URL];
}

- (void)reloadTable
{
	[[self tableView] reloadData];
	[self setTitle:[_rss title]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[_rss items] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *MyIdentifier = @"MyIdentifier";
	
	ZBTableViewCell *cell = (ZBTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[ZBTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];		
	}
	
//	ZBTableViewCell	*cell = [[[ZBTableViewCell alloc] initWithFrame:CGRectZero] autorelease];	
	if ([[_rss items] objectAtIndex:indexPath.row]) {
		[cell setDictionary:[[_rss items] objectAtIndex:indexPath.row]];
	}
	return cell;
}

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *URLString = [[[_rss items] objectAtIndex:indexPath.row] valueForKey:@"link"];
	NSURL *URL = [NSURL URLWithString:URLString];
	id delegate = [[UIApplication sharedApplication] delegate];
	[delegate openWebPage:URL];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
}

- (void)viewDidDisappear:(BOOL)animated
{
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
	_rss = nil;
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc
{
	[_rss release];
	[super dealloc];
}


@end

