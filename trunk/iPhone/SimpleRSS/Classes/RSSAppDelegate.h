//
//  UnewsAppDelegate.h
//  Unews
//
//  Created by zonble on 2008/6/16.
//  Copyright zonble.twbbs.org 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSAppDelegate : NSObject <UIApplicationDelegate> {
	
	IBOutlet UIWindow *window;
	IBOutlet UINavigationController *navigationController;
}

- (void)reloadTable;
- (void)openWebPage:(NSURL *)URL;
- (void)showErrorMessage;

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;

@end

