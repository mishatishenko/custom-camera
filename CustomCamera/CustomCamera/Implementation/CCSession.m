//
//  CCSession.m
//  CustomCamera
//
//  Created by Www Www on 7/7/17.
//  Copyright © 2017 Michael Tishchenko. All rights reserved.
//

@import AVFoundation;
#import "CCSession.h"
#import "CCerror.h"

const CCAccessToCamera CCAccessToCameraAllowed = @"allowed";
const CCAccessToCamera CCAccessToCameraDenied = @"denied";

const CCCameraLightMode CCCameraLightModeFlash = @"flash";
const CCCameraLightMode CCCameraLightModeTorch = @"torch";
const CCCameraLightMode CCCameraLightModeOff = @"off";

const CCCameraDirection CCCameraDirectionFront = @"front";
const CCCameraDirection CCCameraDirectionBack = @"back";

const CCSessionPreset CCSessionPresetHigh = @"high";
const CCSessionPreset CCSessionPresetNormal = @"normal";
const CCSessionPreset CCSessionPresetLow = @"low";
const CCSessionPreset CCSessionPresetPhoto = @"photo";

@interface CCSession ()

@property (nonatomic, copy) AVCaptureSession *avSession;
@property (nonatomic, strong) NSMutableArray<CCFilter *> *filters;
@property (nonatomic, getter=isStarted) BOOL started;

@end

@implementation CCSession

+ (CCSession *)session
{
	return [self new];
}

+ (NSDictionary<CCSessionPreset, NSString *> *)presetMap
{
	return @{
		CCSessionPresetHigh : AVCaptureSessionPresetHigh,
		CCSessionPresetNormal : AVCaptureSessionPresetMedium,
		CCSessionPresetLow : AVCaptureSessionPresetLow,
		CCSessionPresetPhoto : AVCaptureSessionPresetPhoto
	};
}

- (instancetype)init
{
	self = [super init];
	
	if (nil != self)
	{
		self.avSession = [AVCaptureSession new];
		self.avSession.sessionPreset = AVCaptureSessionPresetPhoto;
	}
	
	return self;
}

- (BOOL)canApplyPreset:(CCSessionPreset)preset
{
	return [self.avSession canSetSessionPreset:[[self class] presetMap][preset]];
}

- (void)setPreset:(CCSessionPreset)preset
{
	if (preset != _preset)
	{
		_preset = [preset copy];
		NSString *newPreset = nil != [[self class] presetMap][preset] &&
					[self canApplyPreset:preset] ? [[self class] presetMap][preset] :
					AVCaptureSessionPresetPhoto;
		
		self.avSession.sessionPreset = newPreset;
	}
}

- (void)requestAccessToCameraWithCompletion:(void (^)(CCAccessToCamera access))completion
{
	[AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
	{
		if (nil != completion)
		{
			completion(granted ? CCAccessToCameraAllowed : CCAccessToCameraDenied);
		}
	}];
}

- (void)start
{
	@synchronized (self)
	{
		if (!self.isStarted)
		{
			self.started = YES;
			[self requestAccessToCameraWithCompletion:^(CCAccessToCamera access)
			{
				if ([access isEqualToString:CCAccessToCameraDenied])
				{
					self.started = NO;
					void (^errorHandler)(NSError *error) = self.errorHandler;
					if (nil != errorHandler)
					{
						errorHandler([NSError errorWithDomain:kCCErrorDomain
									code:kCCErrorCodeCameraAccessDenied userInfo:nil]);
					}
				}
			}];
		}
	}
}

- (void)stop
{
	@synchronized(self)
	{
		if (self.isStarted)
		{
			self.started = NO;
			[self.avSession stopRunning];
		}
	}
}

- (void)getSnapshotWithCompletion:(void (^)(UIImage *image))completion
{

}

- (void)startVideoRecording
{

}

- (void)stopVideoRecording
{

}

- (void)flushVideo
{

}

- (void)getRecordedVideoWithCompletion:(void (^)(NSData *video))completion
{

}

- (void)getQRCodeWithCompletion:(void (^)(NSString *qrCode))completion
{

}

- (void)applyFilter:(CCFilter *)filter
{

}

- (void)disableFilter:(CCFilter *)filter
{

}

@end
