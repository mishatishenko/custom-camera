//
//  Photo.m
//  maps
//
//  Created by Www Www on 8/18/17.
//  Copyright © 2017 Michael Tishchenko. All rights reserved.
//

#import "Photo.h"

@interface Photo ()

@property (nonatomic, strong) PHAsset *asset;

@end

@implementation Photo

- (instancetype)initWithAsset:(PHAsset *)asset
{
	if (self = [super init])
	{
		_asset = asset;
	}
	
	return self;
}

@end
