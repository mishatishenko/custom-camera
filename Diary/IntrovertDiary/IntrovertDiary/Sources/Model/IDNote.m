//
//  IDNote.m
//  IntrovertDiary
//
//  Created by Www Www on 8/20/17.
//  Copyright © 2017 Michael Tishchenko. All rights reserved.
//

#import "IDNote.h"

@implementation IDNote

- (instancetype)init
{
	if (self = [super init])
	{
		_creationDate = [NSDate date];
	}
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super init])
	{
		_creationDate = [aDecoder decodeObjectForKey:@"creationDate"];
		_text = [aDecoder decodeObjectForKey:@"text"];
		_picture = [aDecoder decodeObjectForKey:@"picture"];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self.creationDate forKey:@"creationDate"];
	[aCoder encodeObject:self.text forKey:@"text"];
	[aCoder encodeObject:self.picture forKey:@"picture"];
}

@end
