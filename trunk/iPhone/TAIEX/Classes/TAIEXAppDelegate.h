//
//  TAIEXAppDelegate.h
//  TAIEX
//
//  Created by zonble on 2008/12/24.
//  Copyright zonble.twbbs.org 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAIEXAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

- (void)showAddStockView;
- (void)hideAddStockView;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

