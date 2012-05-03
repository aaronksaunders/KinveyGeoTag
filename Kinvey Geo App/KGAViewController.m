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

@end

@implementation KGAViewController

@synthesize locationManager = _locationManager;
@synthesize worldView = _worldView;
@synthesize locationTitleField = _locationTitleField;
@synthesize selectedMapType = _selectedMapType;
@synthesize activityIndicator = _activityIndicator;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self){
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
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
    [self.activityIndicator stopAnimating];
    self.locationTitleField.hidden = NO;
    [self.locationManager stopUpdatingLocation];
    
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
//    [mapView setCenterCoordinate:[userLocation coordinate] animated:YES];
    [mapView setRegion:MKCoordinateRegionMakeWithDistance([userLocation coordinate], 50.0E3, 50.0E3) animated:YES];
    
}

#pragma mark -
#pragma mark UITextField Delegate
- (BOOL)textFieldShouldReturn: (UITextField *)textField
{
    [self findLocation];
    [textField resignFirstResponder];
    return YES;
}


@end
