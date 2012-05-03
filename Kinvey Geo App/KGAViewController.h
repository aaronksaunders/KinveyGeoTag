//
//  KGAViewController.h
//  Kinvey Geo App
//
//  Created by Brian Wilson on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface KGAViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate>

@property (nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet MKMapView *worldView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *locationTitleField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectedMapType;


- (IBAction)changeMapType:(id)sender;


- (void)findLocation;
- (void)foundLocation:(CLLocation *)location;

@end
