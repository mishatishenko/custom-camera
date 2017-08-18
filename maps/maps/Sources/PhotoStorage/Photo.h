//
//  Photo.h
//  maps
//
//  Created by Www Www on 8/18/17.
//  Copyright © 2017 Michael Tishchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/PHAsset.h>

@class PHAsset;

@interface Photo : NSObject

@property (nonatomic, readonly) PHAsset *asset;
- (instancetype)initWithAsset:(PHAsset *)asset;

@end
