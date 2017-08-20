//
//  IDNoteStorage.h
//  IntrovertDiary
//
//  Created by Www Www on 8/20/17.
//  Copyright © 2017 Michael Tishchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IDNote;

@interface IDNoteStorage : NSObject

+ (IDNoteStorage *)sharedStorage;

@property (nonatomic, readonly) NSArray<IDNote *> *notes;

- (void)saveNote:(IDNote *)note;
- (void)removeNote:(IDNote *)note;

@end
