//
//  UnewsAppDelegate.m
//  Unews
//
//  Created by zonble on 2008/6/16.
//  Copyright zonble.twbbs.org 2008. All rights reserved.
//

#import "RSSAppDelegate.h"
#import "RootViewController.h"
#import "WebViewController.h"


@implementation RSSAppDelegate

@synthesize window;
@synthesize navigationController;


- (id)init
{
	if (self = [super init]) {
		// 
	}
	return self;
}


- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
	RootViewController *controller = [[navigationController viewControllers] objectAtIndex:0];
	[controller parseURL:[NSURL URLWithString:@"http://diggirl.net/hottodayrss.jsp"]];
//	[controller parseURL:[NSURL URLWithString:@"http://feeds.boingboing.net/boingboing/iBag"]];
//	[controller parseURL:[NSURL URLWithString:@"http://140.119.187.60/rss.asp"]];	
//	[controller parseURL:[NSURL URLWithString:@"http://zonble.twbbs.org/feed/rss/"]];
//	[controller parseURL:[NSURL URLWithString:@"http://picasaweb.google.com/data/feed/base/user/zonble?kind=album&alt=rss&hl=en_US"]];
//	[controller parseURL:[NSURL URLWithString:@"http://api.flickr.com/services/feeds/photos_public.gne?id=51035552736@N01&lang=zh-hk&format=rss_200"]];
//	[controller parseURL:[NSURL URLWithString:@"http://www.newstory.info/rss.xml"]];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
	// Save data if appropriate
}


- (void)dealloc
{
	[navigationController release];
	[window release];
	[super dealloc];
}

- (void)reloadTable
{
	RootViewController *controller = [[navigationController viewControllers] objectAtIndex:0];
	[controller reloadTable];
}

- (void)showErrorMessage
{
	UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Error" message:@"error happned" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[a show];
	[a release];	
}

- (void)openWebPage:(NSURL *)URL
{
	WebViewController *w = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:[NSBundle mainBundle]];
	[navigationController pushViewController:w animated:YES];
	[w loadURL:URL];
	[w release];
}

@end
