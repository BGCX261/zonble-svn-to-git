//
//  ZBColorBy.h
//  colorBy.colorPicker
//
//  Created by zonble on 2007/12/10.
//  Copyright 2007 zonble.twbbs.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ZBTabViewItem.h"


@interface ZBColorBy : NSColorPicker <NSColorPickingCustom>  {
	IBOutlet id _uColorByView;
	IBOutlet id _uHSBTextview;
	IBOutlet id _uRGBTextview;
	IBOutlet id _uCMYKTextview;
	IBOutlet id _uColorMode;
	IBOutlet id _uCGRGBTextview;
	IBOutlet id _uCGCMYKTextview;	
	BOOL	_useDeviceColor;
	IBOutlet id _uNSTab;
	IBOutlet id _uCGTab;	
}
- (IBAction)copyCMYK:(id)sender;
- (IBAction)copyHSB:(id)sender;
- (IBAction)copyRGB:(id)sender;
- (IBAction)copyCGCMYK:(id)sender;
- (IBAction)copyCGRGB:(id)sender;
- (IBAction)switchMode:(id)sender;
@end
