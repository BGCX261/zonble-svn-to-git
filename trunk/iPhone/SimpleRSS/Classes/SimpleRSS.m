//
//  SimpleRSS.m
//  SimpleRSS
//
//  Created by zonble on 2008/6/16.
//  Copyright 2008 zonble.twbbs.org. All rights reserved.
//

#import "SimpleRSS.h"


@implementation SimpleRSS

+ (UIImage *)blankImage
{
	UIImage *i = [[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"blank" ofType:@"png"]] autorelease];
	return i;
}

- (void)dealloc
{
	[_parser release];
	[_request release];
	[_feedItems release];
	[_currentHandlingItem release];
	[_feedTitle release];
	[_curretTag release];
	[super dealloc];
}

- (NSString *)_savePathForURL:(NSURL *)URL
{
	NSArray *filePaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask,YES); 	
	NSString *pathSring = [filePaths objectAtIndex: 0];
	
	NSString *docString = [[[[URL absoluteString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"/" withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""];
	int l = [docString length] - 4;
	if (l > 30)
		l = 30;
	docString = [docString substringWithRange:NSMakeRange(4, l)];
	NSString *fileString = [pathSring stringByAppendingPathComponent:docString];
	return fileString;
}

- (id)init
{
	self = [super init];
	if (self != nil) {
		_feedItems = [NSMutableArray new];
		_request = [LFHTTPRequest new];
		_request.delegate = self;
	}
	return self;
}

- (void)showErrorMessage
{
	id delegate = [[UIApplication sharedApplication] delegate];
	[delegate showErrorMessage];		
}

- (void)parseURL: (NSURL *)URL
{
	if (!URL)
		return;
	[_feedItems removeAllObjects];	
	if ([_request isRunning]) {
		[_request cancel];
	}
	[_request performMethod:LFHTTPRequestGETMethod onURL:URL withData:nil];	
}

#pragma mark LFHTTPRequestDelegate

- (void)httpRequestDidComplete:(LFHTTPRequest *)request
{
	NSData *data = [request receivedData];
	if (data) {
		if (_parser)
			[_parser release];
		_parser = [[NSXMLParser alloc] initWithData:data];
		_parser.delegate = self;
		[_parser parse];
	}
}
- (void)httpRequestDidCancel:(LFHTTPRequest *)request
{
	
}
- (void)httpRequest:(LFHTTPRequest *)request didFailWithError:(NSString *)error
{
	
}


#pragma mark XML Parser delegate

- (void)reload
{
	id delegate = [[UIApplication sharedApplication] delegate];
	[delegate reloadTable];	
}

- (void)fetchImage:(NSArray *)array
{
	if ([array count] != 2)
		return;
	id pool = [NSAutoreleasePool new];
	NSString *imageURLString = [array objectAtIndex:0];
	NSDictionary *item = [array objectAtIndex:1];
	
	if (!item)
		return;
	
	NSURL *imageURL = [NSURL URLWithString:imageURLString];
	NSString *imageCachePath = [self _savePathForURL:imageURL];
	NSData *data;
	if ([[NSFileManager defaultManager] fileExistsAtPath:imageCachePath]) {
		data = [NSData dataWithContentsOfFile:imageCachePath];
	}
	else {
		data = [NSData dataWithContentsOfURL:imageURL];
		[data writeToURL:[NSURL fileURLWithPath:imageCachePath] atomically:YES];
	}
	
	UIImage *image = [[UIImage alloc] initWithData:data];
	if (image) {
		[item setValue:image forKey:@"image"];
	}
	[image release];
	[self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
	[pool drain];
	[pool release];		
}

- (void)parser:(NSXMLParser*)parser
didStartElement:(NSString*)elementName
  namespaceURI:(NSString*)namespaceURI
 qualifiedName:(NSString*)qualifiedName
    attributes:(NSDictionary*)attributeDict
{
	if ([elementName isEqualToString:@"item"] && !_isCurrentTagAnEntry) {
		if (_currentHandlingItem) {
			[_currentHandlingItem release]; 
		}
		_currentHandlingItem = [NSMutableDictionary dictionary];
		[_currentHandlingItem retain];
		_isCurrentTagAnEntry = YES;
	}
	else if ([elementName isEqualToString:@"image"] && !_isImage) {
		_isImage = YES;
	}
	if (_isCurrentTagAnEntry) {
		if ([elementName isEqualToString:@"media:thumbnail"]) {
			NSString *imageURLString = [attributeDict valueForKey:@"url"];
			[_currentHandlingItem setValue:imageURLString forKey:@"imageURL"];
		}
	}
	_curretTag = elementName;
	[_curretTag retain];
}

- (void)parser:(NSXMLParser*)parser
 didEndElement:(NSString*)elementName
  namespaceURI:(NSString*)namespaceURI
 qualifiedName:(NSString*)qName
{
	if ([elementName isEqualToString:@"item"] && _isCurrentTagAnEntry) {
		if ([_currentHandlingItem valueForKey:@"imageURL"]) {
			[_currentHandlingItem setObject:[SimpleRSS blankImage] forKey:@"image"];
		}
		
		id tmp = [_currentHandlingItem retain];
		[_feedItems addObject:_currentHandlingItem];
		if ([_currentHandlingItem valueForKey:@"imageURL"]) {
			[NSThread detachNewThreadSelector:@selector(fetchImage:) toTarget:self withObject:[NSArray arrayWithObjects:[_currentHandlingItem valueForKey:@"imageURL"], _currentHandlingItem, nil]];		
		}
		[tmp release];
		_isCurrentTagAnEntry = NO;
	}
	else if ([elementName isEqualToString:@"image"] && _isImage) {
		_isImage = NO;
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (!_curretTag)
		return;
	string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([string isEqualToString:@""])
		return;
	if ([string isEqualToString:@"\n"])
		return;
	if (_isCurrentTagAnEntry) {
		if ([_curretTag isEqualToString:@"title"]) {
			NSString *title = [_currentHandlingItem valueForKey:@"title"];
			if (!title) {
				title = string;
			}
			else {
				title = [title stringByAppendingString:string];
			}
			[_currentHandlingItem setObject:title forKey:@"title"];
		}
		else if ([_curretTag isEqualToString:@"link"]) {
			NSString *link = [_currentHandlingItem valueForKey:@"link"];
			if (!link) {
				link = string;
			}
			else {
				link = [link stringByAppendingString:string];
			}
			[_currentHandlingItem setObject:link forKey:@"link"];			
		}
		else if ([_curretTag isEqualToString:@"description"]) {
			NSString *description = [_currentHandlingItem valueForKey:@"description"];
			if (!description) {
				description = string;
			}
			else {
				description = [description stringByAppendingString:string];
			}
			[_currentHandlingItem setObject:description forKey:@"description"];
		}
		else if ([_curretTag isEqualToString:@"pubDate"]) {
			NSString *pubDate = [_currentHandlingItem valueForKey:@"pubDate"];
			if (!pubDate) {
				pubDate = string;
			}
			else {
				pubDate = [pubDate stringByAppendingString:string];
			}
			[_currentHandlingItem setObject:pubDate forKey:@"pubDate"];
		}		
	}
	else if (_isImage) {
	}
	else {
		if ([_curretTag isEqualToString:@"title"]) {
			id tmp = _feedTitle;
			if (!_feedTitle) {
				_feedTitle = string;
			}
			else {
				_feedTitle = [_feedTitle stringByAppendingString:string];
			}
			[_feedTitle retain];
			[tmp release];
		}
	}
}

- (void)parserDidEndDocument:(NSXMLParser*)parser
{
	NSLog(@"end");
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self reload];
	[parser release];
	[_currentHandlingItem release];
	[_curretTag release];
	_isCurrentTagAnEntry = NO;
	_isImage = NO;
}

- (void)parser:(NSXMLParser*)parser
parseErrorOccurred:(NSError*)parseError
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];	
	UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                message:@"error happended"
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
	[a show];
	[a release];
}


@synthesize delegate = _delegate;
@synthesize title = _feedTitle;
@synthesize items = _feedItems;
@end
