//
//  ZBColorBy.m
//  colorBy.colorPicker
//
//  Created by zonble on 2007/12/10.
//  Copyright 2007 zonble.twbbs.org. All rights reserved.
//

#import "ZBColorBy.h"
#define MSG(x) NSLocalizedStringWithDefaultValue(x, nil, [NSBundle bundleForClass:[ZBColorBy class]], x, nil)

@implementation ZBColorBy

- (void)updateColor: (NSColor *)aColor
{
	if(!aColor)
		return;
	NSString *hsbString= @"";
	NSString *rgbString= @"";
	NSString *cmykString= @"";
	NSColor *rgbColor;
	NSColor *cmykColor;		
	
	if([aColor colorSpaceName] == NSDeviceWhiteColorSpace || [aColor colorSpaceName] == NSCalibratedWhiteColorSpace) {
		rgbColor = [NSColor colorWithCalibratedRed:1.0 green:1.0 blue:1.0 alpha:[aColor alphaComponent]];
		cmykColor = [NSColor colorWithDeviceCyan:0.0 magenta:0.0 yellow:0.0 black:0.0 alpha:[aColor alphaComponent]];
	}
	else if([aColor colorSpaceName] == NSDeviceBlackColorSpace || [aColor colorSpaceName] == NSCalibratedBlackColorSpace) {
		rgbColor = [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:[aColor alphaComponent]];
		cmykColor = [NSColor colorWithDeviceCyan:0.0 magenta:0.0 yellow:0.0 black:1 alpha:[aColor alphaComponent]];
	}
	else {
		cmykColor = [aColor colorUsingColorSpaceName:NSDeviceCMYKColorSpace];
	}	
	
	if(_useDeviceColor) {
		rgbColor = [aColor colorUsingColorSpaceName:NSDeviceRGBColorSpace];			
		hsbString = [NSString stringWithFormat:@"[NSColor colorWithDeviceHue:%1.2f saturation:%1.2f brightness:%1.2f alpha:%1.2f]", [rgbColor hueComponent], [rgbColor saturationComponent], [rgbColor brightnessComponent], [rgbColor alphaComponent]];
		rgbString = [NSString stringWithFormat:@"[NSColor colorWithDeviceRed:%1.2f green:%1.2f blue:%1.2f alpha:%1.2f]",[rgbColor redComponent], [rgbColor greenComponent], [rgbColor blueComponent], [rgbColor alphaComponent]];
		cmykString = [NSString stringWithFormat:@"[NSColor colorWithDeviceCyan:%1.2f magenta:%1.2f yellow:%1.2f black:%1.2f alpha:%1.2f]", [cmykColor cyanComponent], [cmykColor magentaComponent], [cmykColor yellowComponent], [cmykColor blackComponent], [cmykColor alphaComponent]];
	}
	else {
		rgbColor = [aColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];	
		hsbString = [NSString stringWithFormat:@"[NSColor colorWithCalibratedHue:%1.2f saturation:%1.2f brightness:%1.2f alpha:%1.2f]", [rgbColor hueComponent], [rgbColor saturationComponent], [rgbColor brightnessComponent], [rgbColor alphaComponent]];
		rgbString = [NSString stringWithFormat:@"[NSColor colorWithCalibratedRed:%1.2f green:%1.2f blue:%1.2f alpha:%1.2f]",[rgbColor redComponent], [rgbColor greenComponent], [rgbColor blueComponent], [rgbColor alphaComponent]];
		cmykString = [NSString stringWithFormat:@"[NSColor colorWithDeviceCyan:%1.2f magenta:%1.2f yellow:%1.2f black:%1.2f alpha:%1.2f]", [cmykColor cyanComponent], [cmykColor magentaComponent], [cmykColor yellowComponent], [cmykColor blackComponent], [cmykColor alphaComponent]];		
		
	}
	NSString *cgrgbString = [NSString stringWithFormat:@"CGColorCreateGenericRGB(%1.2f, %1.2f, %1.2f, %1.2f)",[rgbColor redComponent], [rgbColor greenComponent], [rgbColor blueComponent], [rgbColor alphaComponent]];
	NSString *cgcmykString = [NSString stringWithFormat:@"CGColorCreateGenericCMYK(%1.2f, %1.2f, %1.2f, %1.2f, %1.2f)", [cmykColor cyanComponent], [cmykColor magentaComponent], [cmykColor yellowComponent], [cmykColor blackComponent], [cmykColor alphaComponent]];
	
	[[[_uHSBTextview textStorage] mutableString] setString:hsbString];
	[[[_uRGBTextview textStorage] mutableString] setString:rgbString];
	[[[_uCMYKTextview textStorage] mutableString] setString:cmykString];
	[[[_uCGRGBTextview textStorage] mutableString] setString:cgrgbString];
	[[[_uCGCMYKTextview textStorage] mutableString] setString:cgcmykString];	
}

- (void)doCopy:(NSMutableString *)string
{
	NSLog(@"Copy");
	NSLog(@"Copy: %@", string);	
	NSPasteboard *pb = [NSPasteboard generalPasteboard];
	NSArray *types = [NSArray arrayWithObjects: NSStringPboardType, nil];
	[pb declareTypes:types owner:self];	
	[pb setString:string forType:NSStringPboardType];
}

- (IBAction)copyCMYK:(id)sender
{
	[self doCopy:[[_uCMYKTextview textStorage] mutableString]];
}
- (IBAction)copyHSB:(id)sender
{
	[self doCopy:[[_uHSBTextview textStorage] mutableString]];
}
- (IBAction)copyRGB:(id)sender
{
	[self doCopy:[[_uRGBTextview textStorage] mutableString]];
}
- (IBAction)copyCGCMYK:(id)sender
{
	[self doCopy:[[_uCGCMYKTextview textStorage] mutableString]];
}
- (IBAction)copyCGRGB:(id)sender
{
	[self doCopy:[[_uCGRGBTextview textStorage] mutableString]];	
}
- (IBAction)switchMode:(id)sender
{
	
	int m = [[_uColorMode selectedCell] tag];
	if(m == 0) {
		_useDeviceColor=NO;
	} else {
		_useDeviceColor=YES;		
	}
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:_useDeviceColor] forKey:@"useDeviceColor"];
	[self updateColor:[[self colorPanel] color]];	
}

- (NSImage *)imageFromBundle:(NSString *)name ofType:(NSString *)type
{
	NSBundle *b = [NSBundle bundleForClass:[ZBColorBy class]];
	NSString *path = [b pathForResource:name ofType:type];
	NSImage *image = [[[NSImage alloc] initWithContentsOfFile:path] autorelease];
	return image;
}

- (void)awakeFromNib
{
	[_uNSTab setIconSize:18.0];
	[_uNSTab setIconImage:[self imageFromBundle:@"nscolor" ofType:@"jpg"]];
	[_uCGTab setIconSize:18.0];	
	[_uCGTab setIconImage:[self imageFromBundle:@"cgcolor" ofType:@"jpg"]];	 
	_useDeviceColor=NO;
	_useDeviceColor=[[[NSUserDefaults standardUserDefaults] objectForKey:@"useDeviceColor"] boolValue];
	if(_useDeviceColor) {
		[_uColorMode selectCellAtRow:1 column:0];
	} else {
		[_uColorMode selectCellAtRow:0 column:0];		
	}
	[self updateColor:[[self colorPanel] color]];
	
}

// provide a tooltip for our color picker icon in the NSColorPanel
- (NSString *)buttonToolTip
{
	return MSG(@"colorBy.colorPicker");
}

// provide a description string for our color picker
- (NSString *)description
{
	return MSG(@"colorBy.colorPicker - An utility to generate NSColor code");	
}

// The minimal size of the color picker view (10.5 API)
- (NSSize)minContentSize
{
	return NSMakeSize(250., 340.);
}

- (NSView *)provideNewView:(BOOL)initialRequest
{
	if (initialRequest) {
		BOOL loaded = [NSBundle loadNibNamed:@"colorBy" owner:self];
		NSAssert((loaded == YES), @"NIB did not load");
	}
	NSAssert((nil != _uColorByView), @"coloByView is nil!");
	return _uColorByView;	
}

- (NSImage *)provideNewButtonImage 
{
	NSImage *im = im = [[NSImage alloc] initWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"colorBy" ofType:@"png"]];
	[im setSize:NSMakeSize(32.0,32.0)];	
	return im;
}

- (void)setColor:(NSColor *)color 
{	
	[[self colorPanel] setColor:color];
	[self updateColor:[[self colorPanel] color]];	
}

- (BOOL)supportsMode:(int)mode 
{
	switch (mode) {
		case NSColorPanelAllModesMask:
		case NSCustomPaletteModeColorPanel:
			return YES;
	}
	return NO;
}

- (int)currentMode {
	return NSColorPanelAllModesMask;
}

@end
