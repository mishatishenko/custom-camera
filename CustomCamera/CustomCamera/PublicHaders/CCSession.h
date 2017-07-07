//
//  CCSession.h
//  CustomCamera
//
//  Created by Www Www on 7/7/17.
//  Copyright © 2017 Michael Tishchenko. All rights reserved.
//

@import Foundation;
@import UIKit;

@class CCFilter;
@class CCPreviewLayer;

typedef const NSString * CCAccessToCamera NS_EXTENSIBLE_STRING_ENUM;
extern CCAccessToCamera CCAccessToCameraAllowed;
extern CCAccessToCamera CCAccessToCameraDenied;
extern CCAccessToCamera CCAccessToCameraNotDetermined;

typedef const NSString * CCCameraLightMode NS_EXTENSIBLE_STRING_ENUM;
extern CCCameraLightMode CCCameraLightModeFlash;
extern CCCameraLightMode CCCameraLightModeTorch;
extern CCCameraLightMode CCCameraLightModeOff;

typedef const NSString * CCCameraDirection NS_EXTENSIBLE_STRING_ENUM;
extern CCCameraDirection CCCameraDirectionFront;
extern CCCameraDirection CCCameraDirectionBack;

@interface CCSession : NSObject

@property (nonatomic, copy) void (^errorHandler)(NSError *error);
@property (nonatomic, copy) CCCameraLightMode lightMode;
@property (nonatomic, copy) CCCameraDirection directionMode;

+ (CCSession *)session;

- (void)requestAccessToCameraWithCompletion:(void (^)(CCAccessToCamera access))completion;

- (void)start;
- (void)stop;

- (void)getSnapshotWithCompletion:(void (^)(UIImage *image))completion;
- (void)startVideoRecording;
- (void)stopVideoRecording;
- (void)flushVideo;
- (void)getRecordedVideoWithCompletion:(void (^)(NSData *video))completion;

- (void)getQRCodeWithCompletion:(void (^)(NSString *qrCode))completion;

@property (readonly, nonatomic) NSArray<CCFilter *> *filters;
- (void)applyFilter:(CCFilter *)filter;
- (void)disableFilter:(CCFilter *)filter;

@end
