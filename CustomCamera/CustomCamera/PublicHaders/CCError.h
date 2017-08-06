//
//  CCError.h
//  CustomCamera
//
//  Created by Www Www on 7/7/17.
//  Copyright © 2017 Michael Tishchenko. All rights reserved.
//

@import Foundation;

NSString *const kCCErrorDomain = @"ccErrorDomain";

typedef NS_ENUM(NSUInteger, CCErrorCode)
{
	kCCErrorCodeCameraAccessDenied,
	kCCErrorCodeInternal
};
