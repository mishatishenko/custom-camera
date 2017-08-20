//
//  IDAppDelegate.m
//  IntrovertDiary
//
//  Created by Www Www on 8/20/17.
//  Copyright © 2017 Michael Tishchenko. All rights reserved.
//

#import "IDAppDelegate.h"

@implementation IDAppDelegate

- (BOOL)application:(UIApplication *)application
			didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	NSDictionary *textTitleOptions =
				@{
					NSForegroundColorAttributeName :
					[UIColor colorWithRed:97./255 green:108./255 blue:115./255 alpha:1],
					NSBackgroundColorAttributeName : [UIColor whiteColor],
					NSFontAttributeName :
					[UIFont fontWithName:@"SFUIDisplay-Semibold" size:12.0]
				};
	[[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
	
	return YES;
}

@end
