//
//  TAIEXAppDelegate.m
//  TAIEX
//
//  Created by zonble on 2008/12/24.
//  Copyright zonble.twbbs.org 2008. All rights reserved.
//

#import "TAIEXAppDelegate.h"
#import "RootViewController.h"
#import "ZBAddStockViewController.h"
#import "ZBArrayController.h"

@implementation TAIEXAppDelegate

@synthesize window;
@synthesize navigationController;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{	
	// Configure and show the window

	[[ZBArrayController sharedController] performSelector:@selector(fetchData) withObject:nil afterDelay:1.0];
	[ZBAddStockViewController sharedController];
	window.backgroundColor = [UIColor blackColor];
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
	// Save data if appropriate
	[[ZBArrayController sharedController] save];
}

- (void)dealloc
{
	[navigationController release];
	[window release];
	[super dealloc];
}

- (void)showAddStockView
{
	ZBAddStockViewController *controller = [ZBAddStockViewController sharedController];
	[[self navigationController] presentModalViewController:controller animated:YES];
}
- (void)hideAddStockView
{
	[[self navigationController] dismissModalViewControllerAnimated:YES];
}

@end
