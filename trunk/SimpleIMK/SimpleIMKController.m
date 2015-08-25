//
//  SimpleIMKController.m
//  SimpleIMK
//
//  Created by zonble on 2008/3/21.
//  Copyright 2008 Lithoglyph Inc. All rights reserved.
//

#import "SimpleIMKController.h"



static id currentSender = nil;

@implementation SimpleIMKController

- (void)awakeFromNib
{
	NSConnection *connection = [NSConnection defaultConnection];
	[connection setRootObject:self];

	if ([connection registerName:@"SimpleIMK_DO"]) {
		NSLog(@"DO service registered");
	}
}

- (void)activateServer:(id)sender
{
	currentSender = sender;
}

- (void)deactivateServer:(id)sender
{
	currentSender = nil;
}

- (oneway void) sendString: (NSString *)string
{
	NSLog(@"sendString");
	[SimpleIMKController doSendString:string];
}

+ (void) doSendString: (NSString *)string
{
	if (currentSender != nil) {
		NSLog(@"doSendString");		
		[currentSender insertText:string replacementRange:NSMakeRange(NSNotFound, NSNotFound)];
		[self commitComposition:currentSender];	
	}
}

- (IBAction)sendTest: (id)sender
{
	[SimpleIMKController doSendString:@"Test"];
}

- (NSMenu*)menu
{
	NSMenu *menu = [[[NSMenu alloc] initWithTitle:@""] autorelease];
	NSMenuItem *menuItem = [[[NSMenuItem alloc] init] autorelease];
	[menuItem setTarget:self];
	[menuItem setAction:@selector(sendTest:)];
	[menuItem setTitle:@"Send 'Test'"];
	[menu addItem:menuItem];
	return menu;
}

//- (BOOL)inputText:(NSString*)string client:(id)sender
//{
//	NSString *newString = [string uppercaseString];
//	[sender insertText:newString replacementRange:NSMakeRange(NSNotFound, NSNotFound)];
//	[self commitComposition:sender];	
//	return YES;
//}
//
//- (BOOL)didCommandBySelector:(SEL)aSelector client:(id)sender
//{
//	return YES;
//}


@end
