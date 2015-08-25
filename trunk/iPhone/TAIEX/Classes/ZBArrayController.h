//
//  ZBDictionaryController.h
//  TAIEX
//
//  Created by zonble on 2008/12/24.
//  Copyright 2008 zonble.twbbs.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBArrayController : NSObject {
	id delegate;
	NSMutableArray *_array;
}

+ (id)sharedController;
- (NSArray *)array;
- (void)addStockWithName:(NSString *)name stockID:(NSString *)stockID;
- (void)removeAtIndex:(NSInteger)index;
- (void)save;
- (void)fetchData;

@property (assign) id delegate;

@end

@interface NSObject(ZBArrayController)
- (void)arrayController:(id)controller didAddStockWithName:(NSString *)name stockID:(NSString *)stockID;
- (void)arrayControllerFetchDataDidEnd:(id)controller;
- (void)arrayControllerFetchDataDidFailed:(id)controller;
@end
