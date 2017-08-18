//
//  PhotoStorage.m
//  maps
//
//  Created by Www Www on 8/18/17.
//  Copyright © 2017 Michael Tishchenko. All rights reserved.
//

#import "PhotoStorage.h"
#import "Photo.h"
@import Photos;

@interface PhotoStorage () <PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) NSMutableArray<Photo *> *mutablePhotos;
@property (nonatomic) BOOL inSetup;

@end

@implementation PhotoStorage

- (instancetype)init
{
	if (self = [super init])
	{
		[[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
	}
	
	return self;
}

- (void)dealloc
{
	[[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (PhotoStorageAccess)accessStatus
{
	NSDictionary<NSNumber *, NSNumber *> *accessValuesMap =
				@{
					@(PHAuthorizationStatusAuthorized) : @(kPhotoStorageAccessAllowed),
					@(PHAuthorizationStatusDenied) : @(kPhotoStorageAccessDenied),
					@(PHAuthorizationStatusRestricted) : @(kPhotoStorageAccessDenied),
					@(PHAuthorizationStatusNotDetermined) : @(kPhotoStorageAccessNotDetermined),
				};
	
	return [accessValuesMap[@([PHPhotoLibrary authorizationStatus])] integerValue];
}

- (void)requestAccessStatusWithCompletion:(void (^)(PhotoStorageAccess status))completion
{
	if (nil == completion)
	{
		return;
	}
	
	[PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status)
	{
		NSDictionary<NSNumber *, NSNumber *> *accessValuesMap =
					@{
						@(PHAuthorizationStatusAuthorized) : @(kPhotoStorageAccessAllowed),
						@(PHAuthorizationStatusDenied) : @(kPhotoStorageAccessDenied),
						@(PHAuthorizationStatusRestricted) : @(kPhotoStorageAccessDenied),
						@(PHAuthorizationStatusNotDetermined) : @(kPhotoStorageAccessNotDetermined),
					};
		
		completion([accessValuesMap[@([PHPhotoLibrary authorizationStatus])] integerValue]);
	}];
}

- (NSMutableArray<Photo *> *)mutablePhotos
{
	@synchronized(self)
	{
		if (nil == _mutablePhotos)
		{
			_mutablePhotos = [NSMutableArray new];
		}
	}
	
	return _mutablePhotos;
}

-(NSArray<Photo *> *)photos
{
	return self.mutablePhotos;
}

- (void)setupWithCompletion:(void (^)(NSError *))completion
{
	@synchronized(self)
	{
		if (self.inSetup)
		{
			return;
		}
		self.inSetup = YES;
		[self.mutablePhotos removeAllObjects];
	}
	[self requestAccessStatusWithCompletion:^(PhotoStorageAccess status)
	{
		if (status == kPhotoStorageAccessAllowed)
		{
			dispatch_async(dispatch_get_global_queue(0, 0),
			^{
				PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage
							options:nil];
				[result enumerateObjectsUsingBlock:
				^(PHAsset * obj, NSUInteger idx, BOOL * _Nonnull stop)
				{
					@synchronized(self)
					{
						[self.mutablePhotos addObject:[[Photo alloc] initWithAsset:obj]];
					}
				}];
				
				dispatch_async(dispatch_get_main_queue(),
				^{
					if (nil != completion)
					{
						@synchronized (self)
						{
							self.inSetup = NO;
						}
						completion(nil);
					}
				});
			});
		}
		else if (nil != completion)
		{
			@synchronized (self)
			{
				self.inSetup = NO;
			}
			completion([NSError errorWithDomain:@"PhotoStorage" code:-1 userInfo:nil]);
		}
	}];
}

#pragma mark - photos observing

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
	[self setupWithCompletion:^(NSError *error)
	{
		if (nil == error)
		{
			[self.observer photoStorageWasChanged:self];
		}
	}];
}

@end
