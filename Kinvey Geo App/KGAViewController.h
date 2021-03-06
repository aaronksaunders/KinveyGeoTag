//
//  KGAViewController.h
//  Kinvey Geo App
//
//  Created by Brian Wilson on 5/3/12.
//  Copyright (c) 2012 Kinvey. See LICENSE for license information.

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <KinveyKit/KinveyKit.h>

@interface KGAViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate, KCSCollectionDelegate, KCSPersistableDelegate>

@property (nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet MKMapView *worldView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *locationNoteField;


- (IBAction)refreshPlaces:(id)sender;


- (void)findLocation;
- (void)foundLocation:(CLLocation *)location;

@end
