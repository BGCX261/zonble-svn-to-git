//
//  SimpleRSS.h
//  SimpleRSS
//
//  Created by zonble on 2008/6/16.
//  Copyright 2008 zonble.twbbs.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFHTTPRequest.h"
#import "RSSAppDelegate.h"

@interface SimpleRSS : NSObject {
	id _delegate;
	
	NSXMLParser *_parser;
	LFHTTPRequest *_request;
	
	NSString *_feedTitle;
	NSMutableArray *_feedItems;
	
	NSMutableDictionary *_currentHandlingItem;
	NSString *_curretTag;
	BOOL _isCurrentTagAnEntry;
	BOOL _isImage;
}

- (void)parseURL: (NSURL *)URL;

@property (assign) id delegate;
@property (readonly, retain, nonatomic) NSString *title;
@property (readonly, retain, nonatomic) NSMutableArray *items;

@end
