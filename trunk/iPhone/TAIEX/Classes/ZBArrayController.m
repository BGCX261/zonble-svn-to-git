//
//  ZBDictionaryController.m
//  TAIEX
//
//  Created by zonble on 2008/12/24.
//  Copyright 2008 zonble.twbbs.org. All rights reserved.
//

#import "ZBArrayController.h"
#import "ZBStockParser.h"

static ZBArrayController *arrayController;

@implementation ZBArrayController

@synthesize delegate;

+ (id)sharedController
{
	if (!arrayController)
		arrayController = [ZBArrayController new];
	return arrayController;
}
- (NSString *)_filepath
{
	NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [docPaths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"result.plist"];
	return path;
}
- (id)init
{
	self = [super init];
	if (self != nil) {
		_array = [NSMutableArray new];
		NSString *path = [self _filepath];		
		if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
			NSArray *a =[NSArray arrayWithContentsOfFile:path];
			[_array addObjectsFromArray:a];
		}
	}
	return self;
}
- (void) dealloc
{
	[_array release];
	[super dealloc];
}
- (NSArray *)array
{
	return _array;
}
- (void)save
{
	NSString *path = [self _filepath];
	[_array writeToFile:path atomically:YES];
}
- (BOOL)checkForStorckID:(NSString *)stockID
{
	for (NSDictionary *d in _array) {
		NSString *theID = [d valueForKey:@"stockID"];
		if ([theID isEqualToString:stockID])
			return NO;
	}
	return YES;
}
- (void)addStockWithName:(NSString *)name stockID:(NSString *)stockID
{
	if (![self checkForStorckID:stockID])
		return;	
	NSMutableDictionary *d = [NSMutableDictionary dictionary];
	[d setValue:name forKey:@"name"];
	[d setValue:stockID forKey:@"stockID"];
	[_array addObject:d];
	if (delegate && [delegate respondsToSelector:@selector(arrayController:didAddStockWithName:stockID:)]) {
		[delegate arrayController:self didAddStockWithName:name	stockID:stockID];
	}
	NSInteger i = [_array count] - 1;
	[[ZBStockParser alloc] initWithStockID:stockID delegate:self index:i];
}
- (void)removeAtIndex:(NSInteger)index
{
	[_array removeObjectAtIndex:index];
}
- (void)fetchData
{
	NSInteger i = 0;
	for (NSDictionary *d in _array) {
		NSString *stockID = [d valueForKey:@"stockID"];
		NSLog(@"stockID:%@", stockID);
		[[ZBStockParser alloc] initWithStockID:stockID delegate:self index:i];
//		[p autorelease];
		i++;
	}
}


#pragma mark Delegate Methods.

- (void)stockParser:(ZBStockParser *)parser didFetchResult:(NSDictionary *)result atIndex:(NSInteger)index
{	
	NSLog(@"result: %@", [result description]);
	NSMutableDictionary *d = [_array objectAtIndex:index];
	[d setObject:[result valueForKey:@"upDownValue"] forKey:@"updown"];
	[d setObject:[result valueForKey:@"price"] forKey:@"price"];
}

- (void)stockParserDidEndDocument:(ZBStockParser *)parser
{
	NSInteger index = [parser index];
	if (index && index == [_array count] - 1) {
		if (delegate && [delegate respondsToSelector:@selector(arrayControllerFetchDataDidEnd:)]) {
			[delegate arrayControllerFetchDataDidEnd:self];			
		}
	}
	[parser release];
}

@end
