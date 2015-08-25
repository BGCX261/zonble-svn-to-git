//
//  WebViewController.h
//  Unews
//
//  Created by zonble on 2008/6/17.
//  Copyright 2008 zonble.twbbs.org. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController {
	IBOutlet UIWebView *_webView;

}

- (void)loadURL:(NSURL *)URL;

@end
