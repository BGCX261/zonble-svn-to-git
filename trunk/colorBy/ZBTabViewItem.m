//
//  ZBTabViewItem.m
//  colorBy.colorPicker
//
//  Created by zonble on 2008/1/6.
//  Copyright 2007 zonble.twbbs.org. All rights reserved.
//

#import "ZBTabViewItem.h"

@implementation ZBTabViewItem

- (NSImage *)_defaultIcon
{
	NSImage *icon = [[NSImage alloc] initWithSize:NSMakeSize(20, 20)];
	[icon lockFocus];
	NSBezierPath *b = [NSBezierPath bezierPathWithRect:NSMakeRect(0, 0, 20, 20)];
	[[NSColor whiteColor] setFill];
	[b fill];
	[[NSColor blackColor] setStroke];
	[b stroke];
	[icon unlockFocus];
	return icon;
}
- (void) awakeFromNib 
{
	if(_isSettedUsingIcon == NO)
		_usingIcon = YES;
	if(_isSettediconSize == NO) 
		_iconSize = 18.0;
	if(_iconImage == nil)
		_iconImage = [self _defaultIcon];	
}
- (void)dealloc
{
	[_iconImage release];
	[super dealloc];
}
- (void)refreshLabel
{
	[[self tabView] setNeedsDisplay:YES];
	[self setLabel: [[[self label] copy] autorelease]];		
}
- (void)setIconImage: (NSImage *)icon
{
	NSImage *tmp = _iconImage;
	_iconImage = [icon retain];
	[tmp release];
	_usingIcon = YES;	
	[self refreshLabel];
}
- (void)setDefaultIconImage
{
	NSImage *tmp = _iconImage;
	_iconImage = [[self _defaultIcon] retain];	
	[tmp release];	
	_usingIcon = YES;
	[self refreshLabel];	
}
- (NSImage *)iconImage
{
	return _iconImage;
}
- (void)setUsingIcon: (BOOL)usingIcon
{
	_isSettedUsingIcon = YES;
	_usingIcon = usingIcon;
	[self refreshLabel];	
}
- (BOOL)isUsingIcon
{
	return _usingIcon;
}
- (void)setIconSize: (float)newSize
{
	_isSettediconSize = YES;
	_iconSize = newSize;
	[self refreshLabel];	
}
- (float)iconSize
{
	return _iconSize;
}
- (void)drawLabel:(BOOL)shouldTruncateLabel inRect:(NSRect)tabRect
{
	if(!_usingIcon) {
		[super drawLabel:shouldTruncateLabel inRect:tabRect];
		return;
	}
	if(_iconImage == nil) {
		[super drawLabel:shouldTruncateLabel inRect:tabRect];
		_usingIcon = NO;
		return;
	}
	if(_isSettediconSize == NO) {
		float h = tabRect.size.height;
		_iconSize = h;
		_isSettediconSize = YES;
	}
	NSRect iconRect;
	if( [_iconImage size].height < _iconSize) {
	   iconRect = NSMakeRect(tabRect.origin.x + 2, tabRect.origin.y + 2,  [_iconImage size].width,[_iconImage size].height);		
	}
	else {	
	   iconRect = NSMakeRect(tabRect.origin.x + 2, tabRect.origin.y + 2,  _iconSize - 2, _iconSize - 2);
	}
	NSRect iconImageRect = NSMakeRect(0, 0, [_iconImage size].width, [_iconImage size].height);
	[_iconImage drawInRect:iconRect fromRect:iconImageRect operation:NSCompositeSourceOver fraction:1.0];

	NSRect labelRect = NSMakeRect(tabRect.origin.x + _iconSize, tabRect.origin.y, tabRect.size.width - _iconSize, tabRect.size.height);
	[super drawLabel:shouldTruncateLabel inRect:labelRect];
}

- (NSSize)sizeOfLabel:(BOOL)shouldTruncateLabel
{
	NSSize originalSize = [super sizeOfLabel:shouldTruncateLabel];
	if(!_usingIcon) {
		return originalSize;
	}
	if(_iconImage == nil) {
		_usingIcon = NO;
		return originalSize;
	}

	NSSize newSize = NSMakeSize(originalSize.width + _iconSize, originalSize.height);
	/*
	if(originalSize.height < _iconSize){
		newSize.height = _iconSize;
	} */

	return newSize;
}

@end
