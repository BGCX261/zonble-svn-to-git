//
//  ZBTabViewItem.h
//  colorBy.colorPicker
//
//  Created by zonble on 2008/1/6.
//  Copyright 2007 zonble.twbbs.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ZBTabViewItem : NSTabViewItem {
	BOOL	_isSettedUsingIcon;
	BOOL	_isSettediconSize;	
	BOOL	_usingIcon;
	float	_iconSize;
	NSImage *_iconImage;
}
- (void)refreshLabel;
- (void)setIconImage: (NSImage *)icon;
- (NSImage *)iconImage;
- (void)setUsingIcon: (BOOL)usingIcon;
- (void)setDefaultIconImage;
- (BOOL)isUsingIcon;
- (void)setIconSize: (float)newSize;
- (float)iconSize;
@end
