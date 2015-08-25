//
//  DogGirl.m
//	A Simple Application to view pictures from Diggirl.net with Coverflow effect.
//
//  Created by zonble on 2007-11-11.
//  Copyright (c) 2007 zonble's promptbook. All rights reserved.
//

#import "DigGirl.h"
#import "CKKulerXMLExtension.h"
#import "CKImageItem.h"

#define HOTTODAY_URL @"http://www.diggirl.net/hottodayrss.jsp"
#define HOTTODAY_FILE @"hottodayrss.xml"
#define NEW_URL @"http://www.diggirl.net/newrss.jsp"
#define NEW_FILE @"newrss.xml"
#define NEWPUSH_URL @"http://www.diggirl.net/newpushrss.jsp"
#define NEWPUSH_FILE @"newpushrss.xml"

@implementation DigGirl

- (NSString *)_CacheFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return [basePath stringByAppendingPathComponent:@"org.twbbs.zonble.DigGirl"];
}

- (void) _parseRSS: (NSData *) rss
{
	_girls = [NSMutableArray new];
	if(![rss length]) return;
	NSString *tempPath = [self _CacheFolder];
	tempPath = [tempPath stringByStandardizingPath];
	if(![[NSFileManager defaultManager] fileExistsAtPath:tempPath isDirectory:NULL]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:tempPath attributes:nil];
		NSLog(@"create temp dir");
	}
	
	NSError *err;
	NSXMLDocument *xmlDoc = [[NSXMLDocument alloc] initWithData:rss options:0 error:&err];
	NSDictionary *girls = [[xmlDoc kulerDictionaryFromDocument] valueForKeyPath:@"channel.item"];
	for (NSDictionary *girl in girls) {
		NSString *title = [girl valueForKeyPath:@"title.$"];
		NSString *link = [girl valueForKeyPath:@"link.$"];		
		NSString *photoURLString = [girl valueForKeyPath:@"media:thumbnail._url"];
		NSString *filename = [[photoURLString pathComponents] objectAtIndex:([[photoURLString pathComponents] count])-1];
		photoURLString = [photoURLString stringByReplacingOccurrencesOfString:filename withString: [@"o" stringByAppendingString:filename]];
		NSURL *photoURL = [NSURL URLWithString:photoURLString];
		NSString *fullPath = [tempPath stringByAppendingPathComponent:filename];		
		fullPath = [fullPath stringByStandardizingPath];	
		NSImage *image;
		if(![[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:NULL]){
			NSData *data = [NSData dataWithContentsOfURL:photoURL];
			image = [[NSImage alloc] initWithData:data];
			[data writeToFile:fullPath atomically:YES];
			NSLog(@"saving to %@...%d", fullPath, [data bytes]);			
		} else {
			image= [[NSImage alloc] initByReferencingFile: fullPath];
		}

		[image setCacheMode:NSImageCacheAlways];
		CKImageItem *item = [[CKImageItem alloc] initWithImage:image imageID:photoURLString imageTitle: title];
		[item setImageLink:link];
		[item setImagePath:fullPath];		
		[item setImageSubTitle:link];		
		[_girls addObject:item];
		
//[self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:NO]	
		[girlFlow performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
		if([_girls count] > 1) {
			[message setStringValue:[NSString stringWithFormat:@"Loading pictures, %d pictures are loaded.", [_girls count]]];
		} else {
			[message setStringValue:@"Loading pictures, one picture is loaded."];	
		}
	}
	[message setStringValue:@"All pictures are loaded."];			
}

- (void) stopLoading 
{
	[progress setHidden:YES];
	[progress stopAnimation:nil];
	[menu setEnabled:YES];	
	if(![_girls count]) {
		[message setStringValue:@"Unable to load pictures from DigGirl.net."];
	}
}

- (void) fetchRSS: (NSArray *)perameters
{	
	id pool = [NSAutoreleasePool new];
	NSURL *url = [perameters objectAtIndex:0];
	NSString *fullPath = [perameters objectAtIndex:1];	
	NSData *rss = [NSData dataWithContentsOfURL:url];
	[self _parseRSS:rss];
	[rss writeToFile:fullPath atomically:YES];
	[girlFlow performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];	
	// [girlFlow reloadData];
	[self stopLoading];
	[pool drain];	
}

- (void) doFetch:  (NSURL *)url fullPath:(NSString *)fullPath 
{
	[NSThread detachNewThreadSelector:@selector(fetchRSS:) toTarget:self withObject: [NSArray arrayWithObjects:url, fullPath, nil]];	
}

- (void) updateGirls:  (NSString *)urlstring filename:(NSString *)filename 
{
	NSString *tempPath = [self _CacheFolder];
	tempPath = [tempPath stringByStandardizingPath];
	NSString *fullPath = [tempPath stringByAppendingPathComponent:filename];
	fullPath = [fullPath stringByStandardizingPath];
	NSURL *url = [NSURL URLWithString:urlstring];
	NSData *rss;
	[message setStringValue:@""];
	[progress setHidden:NO];
	[progress startAnimation:nil];
	[menu setEnabled:NO];
	
	if(![[NSFileManager defaultManager] fileExistsAtPath:tempPath isDirectory:NULL]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:tempPath attributes:nil];
		NSLog(@"create temp dir");		
	}
	if(![[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:NULL]) {
		[self doFetch:url fullPath:fullPath];
	} else {
		NSDate *createDate = [[[NSFileManager defaultManager] fileAttributesAtPath:fullPath traverseLink:YES] objectForKey:NSFileCreationDate];
		NSDate *expireDate = [NSDate dateWithTimeIntervalSinceNow:(-2*60*60)];
		if ([createDate compare:expireDate] ==  NSOrderedAscending) {
			[self doFetch:url fullPath:fullPath];			
		} else {
			rss = [NSData dataWithContentsOfFile:fullPath];
			[self _parseRSS:rss];
			[girlFlow reloadData];
			[self stopLoading];
		}
	}
}

- (void) awakeFromNib
{
	[window center];
	[window zoom:nil];
	[message setStringValue:@""];
	[girlFlow setDataSource:self];
	[girlFlow setDelegate:self];
	[self showHotestToday:self];
}


- (IBAction)showHotestToday:(id)sender
{
	[self updateGirls:HOTTODAY_URL filename:HOTTODAY_FILE];
}
- (IBAction)showNew:(id)sender
{
	[self updateGirls:NEW_URL filename:NEW_FILE];
}
- (IBAction)showNewPush:(id)sender
{
	[self updateGirls:NEWPUSH_URL filename:NEWPUSH_FILE];	
}

- (IBAction)openWithPreview:(id)sender
{
	unsigned int index = [girlFlow selectedIndex];	
	CKImageItem *item = [_girls objectAtIndex:index];	
	NSString *fullPath = [item imagePath];
	
	NSString *cmd = [NSString stringWithFormat:@"open -a Preview %@", fullPath];
	system([cmd UTF8String]);
}

- (IBAction)setAsWallpaper:(id)sender
{
	unsigned int index = [girlFlow selectedIndex];
	CKImageItem *item = [_girls objectAtIndex:index];	
	NSString *fullPath = [item imagePath];
	if(![fullPath length])
		return;
	
	NSString *tempPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Pictures"];
	if(![[NSFileManager defaultManager] fileExistsAtPath:tempPath isDirectory:NULL]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:tempPath attributes:nil];
	}	
	tempPath = [tempPath stringByAppendingPathComponent:@"DigGirl"];
	if(![[NSFileManager defaultManager] fileExistsAtPath:tempPath isDirectory:NULL]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:tempPath attributes:nil];
		NSLog(@"create temp dir");
	}		
	NSString *cmd = [NSString stringWithFormat:@"cp %@ ~/Pictures/DigGirl/.", fullPath];	
	system([cmd UTF8String]);
	NSString *filename = [fullPath lastPathComponent];
	cmd = [NSString stringWithFormat:@"/usr/bin/osascript -e \"tell application \\\"Finder\\\" \n set desktop picture to file \\\"Pictures:DigGirl:%@\\\" of home \n end tell\"", filename];
	NSLog(cmd);
	system([cmd UTF8String]);
}

- (IBAction)exportToiPhoro:(id)sender
{
	unsigned int index = [girlFlow selectedIndex];
	CKImageItem *item = [_girls objectAtIndex:index];	
	NSString *fullPath = [item imagePath];
	if(![fullPath length])
		return;
	NSString *cmd = [NSString stringWithFormat:@"/usr/bin/osascript -e \"tell application \\\"iPhoto\\\" \n activate\n import from \\\"%@\\\" \n end tell\"", fullPath];
	NSLog(cmd);
	system([cmd UTF8String]);
}

- (IBAction)exportAllToiPhoro:(id)sender
{
	if(![_girls count]) return;
	NSString *cmd = @"/usr/bin/osascript -e \"tell application \\\"iPhoto\\\" \n activate\n";
	for(CKImageItem *item in _girls) {
		NSString *fullPath = [item imagePath];
		cmd = [cmd stringByAppendingFormat:@"import from \\\"%@\\\"\n", fullPath];
	}
	cmd = [cmd stringByAppendingString:@"end tell\""];
	system([cmd UTF8String]);	
}

//system("/usr/bin/osascript -e \"tell application \\\"iPhoto\\\" to import from \\\"%@\\\" to \\\"Diggirl\\\"\"");

/* The routines of a imageflowview */

- (NSUInteger)numberOfItemsInImageFlow:(id) aBrowser
{
	return [_girls count];
}
- (id) imageFlow:(id)aFlowLayer itemAtIndex:(int)index
{
	return [_girls objectAtIndex:index];
}

- (void)imageFlow:(id)aFlowLayer cellWasDoubleClickedAtIndex: (int)index
{
	CKImageItem *item = [_girls objectAtIndex:index];	
	NSString *URLString = [item imageLink];	
	//NSURL *u = [NSURL URLWithString:URLString];
	//NSURLRequest *r = [NSURLRequest requestWithURL:u];
	//[webPanel center];
	//[webPanel orderFront:self];			   
	//[[webBrowser mainFrame] loadRequest:r];
	if(![URLString isEqualToString:@""]) {
		NSString *cmd = [NSString stringWithFormat:@"open %@", URLString];
		system([cmd UTF8String]);
	}	
}

- (void)windowWillClose:(NSNotification*)n {
    [[NSApplication sharedApplication] terminate:self];
}


/*
-(NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector
{
	const char *selname = sel_getName(aSelector);
    NSLog(@"trying to call %s", selname);
    return [super methodSignatureForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    NSLog(@"trying to determine %s", sel_getName(aSelector));
    return [super respondsToSelector:aSelector];
} */


@end
