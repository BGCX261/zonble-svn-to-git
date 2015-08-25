//
//  ZBTextView.m
//  colorBy
//
//  Created by zonble on 2007/12/11.
//  Copyright 2007 zonble.twbbs.org. All rights reserved.
//

#import "ZBTextView.h"


@implementation ZBTextView

- (NSImage *)textImage
{
	NSString *string = [[self textStorage] mutableString];
	NSMutableAttributedString *a = [[[NSMutableAttributedString alloc] initWithString:string] autorelease];
	
	NSRect myRect = [self frame];
	NSRect imgRect = [a boundingRectWithSize:NSMakeSize(myRect.size.width + 20, 1600) options:NSStringDrawingUsesLineFragmentOrigin];
	imgRect.size.width = myRect.size.width;
	NSImage *image = [[[NSImage alloc] initWithSize:imgRect.size] autorelease];
	[image lockFocus];
	NSRect rect = NSMakeRect(0, 0, [image size].width, [image size].height);
	[a drawInRect:rect];
	[image unlockFocus];	
	return image;
}

- (void)mouseDragged:(NSEvent *)theEvent
{
	[super mouseDragged:theEvent];
	NSLog(@"mouseDragged");
}
- (void)mouseUp:(NSEvent *)theEvent
{
	[super mouseDown:theEvent];	
	[super mouseUp:theEvent];
	NSLog(@"mouseUp");	
}
- (void)mouseDown:(NSEvent *)theEvent
{
	NSImage *image = [self textImage];
	NSPoint p = NSMakePoint(0, [image size].height);
	NSPasteboard *pb = [NSPasteboard generalPasteboard];
	NSArray *types = [NSArray arrayWithObjects: NSStringPboardType, nil];
	NSSize offset = NSMakeSize(0, 0);
	[pb declareTypes:types owner:self];	
	[pb setString:[[self textStorage] mutableString] forType:NSStringPboardType];

	[self dragImage:image at:p offset:offset event:theEvent pasteboard:pb source:self slideBack:YES];
}
@end
