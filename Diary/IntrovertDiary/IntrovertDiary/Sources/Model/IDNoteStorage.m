//
//  IDNoteStorage.m
//  IntrovertDiary
//
//  Created by Www Www on 8/20/17.
//  Copyright © 2017 Michael Tishchenko. All rights reserved.
//

#import "IDNoteStorage.h"
#import "IDNote.h"

@interface IDNoteStorage ()

@property (nonatomic, strong) NSMutableArray<IDNote *> *mutableNotes;

@end

@implementation IDNoteStorage

+ (IDNoteStorage *)sharedStorage
{
	static IDNoteStorage *sharedStorage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken,
	^{
		sharedStorage = [IDNoteStorage new];
	});
	
	return sharedStorage;
}

- (NSMutableArray<IDNote *> *)mutableNotes
{
	if (nil == _mutableNotes)
	{
		_mutableNotes = [NSMutableArray new];
		[self restoreNotes];
	}
	
	return _mutableNotes;
}

- (NSArray<IDNote *> *)notes
{
	return self.mutableNotes;
}

- (void)saveNote:(IDNote *)note
{
	if (![self.mutableNotes containsObject:note])
	{
		[self.mutableNotes addObject:note];
	}
	[self persistNotes];
}

- (void)removeNote:(IDNote *)note
{
	[self.mutableNotes removeObject:note];
	[self persistNotes];
}

- (void)persistNotes
{
	[[NSUserDefaults standardUserDefaults] setObject:
				[NSKeyedArchiver archivedDataWithRootObject:self.mutableNotes]
				forKey:@"notes"];
}

- (void)restoreNotes
{
	[self.mutableNotes addObjectsFromArray:[NSKeyedUnarchiver
				unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]
				objectForKey:@"notes"]]];
}

@end
