//
//  KGAViewController.m
//  KinveyGeoApp
//
//  Created by Brian Wilson on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "KGAViewController.h"
#import "KGAMapNote.h"

static MKMapType mapTypeMap[3] = {
    MKMapTypeStandard,
    MKMapTypeSatellite,
    MKMapTypeHybrid
};
    

@interface KGAViewController ()

@property (retain) KCSCollection *mapNotes;

@end

@implementation KGAViewController

@synthesize locationManager = _locationManager;
@synthesize worldView = _worldView;
@synthesize locationTitleField = _locationTitleField;
@synthesize selectedMapType = _selectedMapType;
@synthesize activityIndicator = _activityIndicator;
@synthesize mapNotes = _mapNotes;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self){
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _mapNotes = [KCSCollection collectionFromString:@"mapNotes" ofClass:[KGAMapNote class]];
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.worldView setShowsUserLocation:YES];
}


- (void)viewDidUnload
{
    [self setWorldView:nil];
    [self setSelectedMapType:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)changeMapType:(id)sender {
    self.worldView.mapType = mapTypeMap[self.selectedMapType.selectedSegmentIndex];
}

- (IBAction)refreshPlaces:(id)sender {
    [self.worldView removeAnnotations:self.worldView.annotations];
    [self updateMarkers];
}

- (void)findLocation
{
    [self.locationManager startUpdatingLocation];
    [self.activityIndicator startAnimating];
    [self.locationTitleField setHidden:YES];
}

- (void)foundLocation:(CLLocation *)location
{
    CLLocationCoordinate2D coord = [location coordinate];
    KGAMapNote *note = [[KGAMapNote alloc] initWithCoordinate:coord title:self.locationTitleField.text];
    [self.worldView addAnnotation:note];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 1E3, 1E3);
    [self.worldView setRegion:region animated:YES];
    
    self.locationTitleField.text = @"";
    self.locationTitleField.hidden = NO;
    [self.locationManager stopUpdatingLocation];
    
    // Save this to Kinvey
    [note saveToCollection:self.mapNotes withDelegate:self];
}

- (void)updateMarkers
{
//    [self.mapNotes fetchAllWithDelegate:self];
    MKCoordinateSpan span = self.worldView.region.span;
    double distanceInMiles = span.latitudeDelta*69;
    CLLocationCoordinate2D mapCenter =  self.worldView.centerCoordinate;
    
    KCSQuery *q = [KCSQuery queryOnField:@"latLong"
               usingConditionalsForValues:
                    kKCSNearSphere,
                    [NSArray arrayWithObjects:
                     [NSNumber numberWithFloat:mapCenter.longitude],
                     [NSNumber numberWithFloat:mapCenter.latitude], nil],
                    kKCSMaxDistance,
                    [NSNumber numberWithFloat:distanceInMiles], nil];

    self.mapNotes.query = q;
    [self.mapNotes fetchWithDelegate:self];
}

#pragma mark -
#pragma mark CLLocationDelegate Methods

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Old Location: %@, New Location: %@", oldLocation, newLocation);
    NSTimeInterval t = [[newLocation timestamp] timeIntervalSinceNow];
    
    if (t < -180){
        // Older than 3 minutes
        return;
    }
    
    [self foundLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location manager failed with error: %@", error);
}

#pragma mark -
#pragma mark MKMapView Delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSAssert(mapView != nil, @"Expected mapView to be not nil, WTF mate");
    NSAssert(userLocation != nil, @"Expected userLocation to be not nil, WTF mate");
    [mapView setRegion:MKCoordinateRegionMakeWithDistance([userLocation coordinate], 1.0E3, 1.0E3) animated:YES];
    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self updateMarkers];
}

#pragma mark -
#pragma mark UITextField Delegate
- (BOOL)textFieldShouldReturn: (UITextField *)textField
{
    [self findLocation];
    [textField resignFirstResponder];
    return YES;
}


#pragma mark -
#pragma mark KCSPersistableDelegate
-(void)entity:(id)entity operationDidCompleteWithResult:(NSObject *)result
{
    [self.activityIndicator stopAnimating];

}

- (void)entity:(id)entity operationDidFailWithError:(NSError *)error
{
    [self.activityIndicator stopAnimating];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Save Note"
                                                    message:[error description]
                                                   delegate:self cancelButtonTitle:@"Ok"
                                           otherButtonTitles:nil];

    [alert show];

}

#pragma mark -
#pragma mark KCSCollectionDelegate

- (void)collection:(KCSCollection *)collection didCompleteWithResult:(NSArray *)result
{
    NSLog(@"Adding %d annotations", [result count]);
    [self.worldView addAnnotations:result];
}

- (void)collection:(KCSCollection *)collection didFailWithError:(NSError *)error
{
    [self.activityIndicator stopAnimating];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Get Notes"
                                                    message:[error description]
                                                   delegate:self cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    
    [alert show];
}




@end
