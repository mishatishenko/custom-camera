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

typedef NSString * CCAccessToCamera NS_EXTENSIBLE_STRING_ENUM;
extern const CCAccessToCamera CCAccessToCameraAllowed;
extern const CCAccessToCamera CCAccessToCameraDenied;

typedef NSString * CCCameraLightMode NS_EXTENSIBLE_STRING_ENUM;
extern const CCCameraLightMode CCCameraLightModeFlash;
extern const CCCameraLightMode CCCameraLightModeTorch;
extern const CCCameraLightMode CCCameraLightModeOff;

typedef NSString * CCCameraDirection NS_EXTENSIBLE_STRING_ENUM;
extern const CCCameraDirection CCCameraDirectionFront;
extern const CCCameraDirection CCCameraDirectionBack;

typedef NSString * CCSessionPreset NS_EXTENSIBLE_STRING_ENUM;
extern const CCSessionPreset CCSessionPresetHigh;
extern const CCSessionPreset CCSessionPresetNormal;
extern const CCSessionPreset CCSessionPresetLow;
extern const CCSessionPreset CCSessionPresetPhoto;

@interface CCSession : NSObject

@property (nonatomic, copy) void (^errorHandler)(NSError *error);
@property (nonatomic, copy) CCCameraLightMode lightMode;
@property (nonatomic, copy) CCCameraDirection directionMode;

+ (CCSession *)session;

- (void)requestAccessToCameraWithCompletion:(void (^)(CCAccessToCamera access))completion;

@property (nonatomic, strong) CCSessionPreset preset;
- (BOOL)canApplyPreset:(CCSessionPreset)preset;

@property (nonatomic, readonly, getter=isStarted) BOOL started;
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
