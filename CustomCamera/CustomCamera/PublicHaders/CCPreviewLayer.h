//
//  CCPreviewLayer.h
//  CustomCamera
//
//  Created by Www Www on 7/7/17.
//  Copyright © 2017 Michael Tishchenko. All rights reserved.
//

@import Foundation;

typedef NSString * CCPreviewLayerGravity NS_EXTENSIBLE_STRING_ENUM;
extern const CCPreviewLayerGravity CCPreviewLayerGravityResize;
extern const CCPreviewLayerGravity CCPreviewLayerGravityResizeAspect;
extern const CCPreviewLayerGravity CCPreviewLayerGravityResizeAspectFill;

@interface CCPreviewLayer : NSObject

/*!
 @property videoGravity
 @abstract
    A string defining how the video is displayed within an bounds rect.

 @discussion
    Options are CCPreviewLayerGravityResize, CCPreviewLayerGravityResizeAspect and CCPreviewLayerGravityResizeAspectFill. CCPreviewLayerGravityResizeAspect is default.
 */
@property (nonatomic, strong) CCPreviewLayerGravity videoGravity;

@end
