//
//  GoogleMapViewController.m
//  maps
//
//  Created by Www Www on 8/18/17.
//  Copyright © 2017 Michael Tishchenko. All rights reserved.
//

#import "GoogleMapViewController.h"
@import GoogleMaps;
#import "PhotoStorage.h"
#import "Photo.h"

@interface GoogleMapViewController ()
@property (nonatomic, strong) GMSMapView *mapView;

@end

@implementation GoogleMapViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
				longitude:151.20 zoom:1];
	GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];

	self.view = mapView;
	self.mapView = mapView;
}

- (void)reload
{
	/*for (Photo *photo in self.photoStorage.photos)
	{
		if (nil != photo.asset.location)
		{
			GMSMarker *marker = [GMSMarker new];
			marker.position = photo.asset.location.coordinate;
			marker.icon = photo.thumbnail;
			marker.map = self.mapView;
		}
	}*/
}

@end
