//
//  main.m
//  SimpleIMK
//
//  Created by zonble on 2008/3/21.
//  Copyright Lithoglyph Inc 2008. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <InputMethodKit/InputMethodKit.h>
#import "SimpleIMKController.h"

IMKServer *SimpleInputMethodServer = nil;

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
	SimpleInputMethodServer = [[IMKServer alloc] initWithName:@"SimpleIMK_1_Connection" bundleIdentifier:[[NSBundle mainBundle] bundleIdentifier]];	
    if (!SimpleInputMethodServer) {
		NSLog(@"input method server init failed!");
        return 1;
    }	
	[NSBundle loadNibNamed:@"MainMenu" owner:[NSApplication sharedApplication]];	

	[[NSApplication sharedApplication] run];
	[pool drain];	
	return 0;
}
