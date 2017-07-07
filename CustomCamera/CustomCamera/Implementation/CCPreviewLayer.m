//
//  CCPreviewLayer.m
//  CustomCamera
//
//  Created by Www Www on 7/7/17.
//  Copyright © 2017 Michael Tishchenko. All rights reserved.
//

@import AVFoundation;

#import "CCPreviewLayer.h"
#import "CCSession.h"

CCPreviewLayerGravity CCPreviewLayerGravityResize = @"resize";
CCPreviewLayerGravity CCPreviewLayerGravityResizeAspect = @"resizeAspect";
CCPreviewLayerGravity CCPreviewLayerGravityResizeAspectFill = @"resizeAspectFill";

@interface CCPreviewLayer ()

@property (nonatomic) AVCaptureVideoPreviewLayer *avLayer;

@end

@interface CCSession (ProjectAccess)

@property (nonatomic) AVCaptureSession *avSession;

@end

@implementation CCPreviewLayer

- (instancetype)init
{
	self = [super init];
	
	if (self)
	{
		self.avLayer = [AVCaptureVideoPreviewLayer new];
		self.videoGravity = CCPreviewLayerGravityResizeAspect;
	}
	
	return self;
}

- (void)setVideoGravity:(CCPreviewLayerGravity)videoGravity
{
	if (videoGravity != _videoGravity)
	{
		_videoGravity = [videoGravity copy];
		NSString *gravity = AVLayerVideoGravityResize;
		NSDictionary<CCPreviewLayerGravity, NSString *> *gravityMap =
					@{
						CCPreviewLayerGravityResize : AVLayerVideoGravityResize,
						CCPreviewLayerGravityResizeAspect : AVLayerVideoGravityResizeAspect,
						CCPreviewLayerGravityResizeAspectFill : AVLayerVideoGravityResizeAspectFill
					};
		if (nil != gravityMap[videoGravity])
		{
			gravity = gravityMap[videoGravity];
		}
		self.avLayer.videoGravity = gravity;
	}
}

- (void)updateWithSession:(CCSession *)session
{
	if (nil != session.avSession)
	{
		self.avLayer.session = session.avSession;
	}
}

@end
