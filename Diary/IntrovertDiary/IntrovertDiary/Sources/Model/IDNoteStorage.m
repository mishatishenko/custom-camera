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
@property (nonatomic, strong) NSMutableArray<NSValue *> *observers;

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

- (NSMutableArray *)observers
{
	if (nil == _observers)
	{
		_observers = [NSMutableArray new];
	}
	
	return _observers;
}

- (void)addObserver:(id<IDNoteStorageObserver>)delegate
{
	@synchronized(self)
	{
		NSValue *observer = [NSValue valueWithNonretainedObject:delegate];
		if (![self.observers containsObject:observer])
		{
			[self.observers addObject:observer];
		}
	}
}

- (void)removeObserver:(id<IDNoteStorageObserver>)delegate
{
	@synchronized(self)
	{
		NSValue *observer = [NSValue valueWithNonretainedObject:delegate];
		if ([self.observers containsObject:observer])
		{
			[self.observers removeObject:observer];
		}
	}
}

- (NSArray<IDNote *> *)notes
{
	return self.mutableNotes;
}

- (void)saveNote:(IDNote *)note
{
	BOOL isNewNote = NO;
	if (![self.mutableNotes containsObject:note])
	{
		[self.mutableNotes addObject:note];
		isNewNote = YES;
	}
	[self persistNotes];
	@synchronized(self)
	{
		for (NSValue *observerValue in self.observers)
		{
			id<IDNoteStorageObserver> observer = observerValue.nonretainedObjectValue;
			if (isNewNote)
			{
				if ([observer respondsToSelector:@selector(noteStorage:didAddNote:)])
				{
					[(id<IDNoteStorageObserver>)observer noteStorage:self didAddNote:note];
				}
			}
			else
			{
				if ([observer respondsToSelector:@selector(noteStorage:didUpdateNote:)])
				{
					[(id<IDNoteStorageObserver>)observer noteStorage:self
								didUpdateNote:note];
				}
			}
		}
	}
}

- (void)removeNote:(IDNote *)note
{
	[self.mutableNotes removeObject:note];
	@synchronized(self)
	{
		for (NSValue *observerValue in self.observers)
		{
			id<IDNoteStorageObserver> observer = observerValue.nonretainedObjectValue;
			if ([observer respondsToSelector:@selector(noteStorage:didDeleteNote:)])
			{
				[(id<IDNoteStorageObserver>)observer noteStorage:self
							didDeleteNote:note];
			}
		}
	}
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
