#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import <WebKit/WebKit.h>
#import "CKImageItem.h"

@interface DigGirl : NSObject  {
	// int _generation;
	NSMutableArray *_girls;	
	IBOutlet id girlFlow;
	IBOutlet id menu;	
	IBOutlet id progress;	
	IBOutlet id window;
	IBOutlet id message;
	IBOutlet id webBrowser;
	IBOutlet id webPanel;	
}

- (IBAction)showHotestToday:(id)sender;
- (IBAction)showNew:(id)sender;
- (IBAction)showNewPush:(id)sender;
- (IBAction)openWithPreview:(id)sender;
- (IBAction)setAsWallpaper:(id)sender;
- (IBAction)exportToiPhoro:(id)sender;
- (IBAction)exportAllToiPhoro:(id)sender;
@end