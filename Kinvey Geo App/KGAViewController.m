//
//  KGAViewController.m
//  Kinvey Geo App
//
//  Copyright 2012-2013 Kinvey, Inc
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//  Created by Brian Wilson on 5/3/12.
//

#import "KGAViewController.h"
#import "KGAMapNote.h"

#import <KinveyKit/KinveyKit.h>

#define ONE_KILOMETER 1.0e3

@interface KGAViewController ()

@property (retain) id<KCSStore> mapStore;
@property (retain) id<KCSStore> hotelStore;

@end

@implementation KGAViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self){
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];

        // We don't want to overload the user with multiple
        // updates, so we only update every 3 meters (at most).
        [_locationManager setDistanceFilter:3];
        
        // KINVEY: Here we define our collection to use 
        KCSCollection* mapNotes = [KCSCollection collectionFromString:@"mapNotes" ofClass:[KGAMapNote class]];
        _mapStore = [KCSAppdataStore storeWithCollection:mapNotes options:nil];
        
        // KINVEY: Here we define our collection to use (this is for data
        // integration)
        KCSCollection* hotels = [KCSCollection collectionFromString:@"hotels" ofClass:[KGAMapNote class]];
        _hotelStore = [KCSAppdataStore storeWithCollection:hotels options:nil];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Make the map show our location
    [self.worldView setShowsUserLocation:YES];

}

- (void)viewDidUnload
{
    [self setWorldView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

// This is linked to the refresh button
- (IBAction)refreshPlaces:(id)sender {

    // Remove all annotations at this time, since we're going to redraw them
    [self.worldView removeAnnotations:self.worldView.annotations];
    
    // Redraw all annotations
    [self updateMarkers];
}

- (void)findLocation
{
    // Find the current location
    [self.locationManager startUpdatingLocation];
    
    // Indicate that we're searching for your location
    [self.activityIndicator startAnimating];
    
    // Hide the text input field
    [self.locationNoteField setHidden:YES];
}

// Called when the location is found
- (void)foundLocation:(CLLocation *)location
{
    // Get the location that was found
    CLLocationCoordinate2D coord = [location coordinate];
    
    // Create a new note with the text from the text field
    KGAMapNote *note = [[KGAMapNote alloc] initWithLocation:location title:self.locationNoteField.text];
    
    // Add the annotation (we do this here so that we don't have to wait for it to be downloaded from
    // Kinvey before we display it
    [self.worldView addAnnotation:note];
    
    // Bring the map view back to where we're dropping the note
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, ONE_KILOMETER, ONE_KILOMETER);
    [self.worldView setRegion:region animated:YES];
    
    // Reset the display 
    self.locationNoteField.text = @"";
    self.locationNoteField.hidden = NO;
    
    // We've found our location, so we can stop searching
    [self.locationManager stopUpdatingLocation];
    
    // KINVEY: Save this note to Kinvey
    [_mapStore saveObject:note withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        [self.activityIndicator stopAnimating];
        if (errorOrNil != nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Save Note"
                                                            message:errorOrNil.localizedDescription
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            
            [alert show];
            NSLog(@"Error: %@, %@, %d", errorOrNil.localizedDescription, errorOrNil.localizedFailureReason, errorOrNil.code);
        }
    } withProgressBlock:nil];
}

// Called to update fetch all annotations
- (void)updateMarkers
{
    // Get the current limits of the map view
    MKCoordinateSpan span = self.worldView.region.span;

    // KINVEY: Geo Queries use miles and there are ~69 miles per each latitudeDelta
    double distanceInMiles = span.latitudeDelta*69;
    CLLocationCoordinate2D mapCenter =  self.worldView.centerCoordinate;

    // KINVEY: Build a query against the "_geoloc" collection in your backend
    //         centered at mapCenter, with a distance of distanceInMiles
    KCSQuery *q = [KCSQuery queryOnField:@"_geoloc"
               usingConditionalsForValues:
                    kKCSNearSphere,
                    [NSArray arrayWithObjects:
                     [NSNumber numberWithFloat:mapCenter.longitude],
                     [NSNumber numberWithFloat:mapCenter.latitude], nil],
                    kKCSMaxDistance,
                    [NSNumber numberWithFloat:distanceInMiles], nil];

    // Kinvey: Set the query to our built query
    // Kinvey: Search for our annotations.  We'll populate the map in the delegate

    [_hotelStore queryWithQuery:q withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        [self.activityIndicator stopAnimating];
        if (errorOrNil == nil) {
            // Add all the returned annotations to the map
            [self.worldView addAnnotations:objectsOrNil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Get Notes"
                                                            message:errorOrNil.localizedDescription
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            
            [alert show];
            NSLog(@"Error: %@, %@, %d", errorOrNil.localizedDescription, errorOrNil.localizedFailureReason, errorOrNil.code);
        }
    } withProgressBlock:nil];
    
    
    // Kinvey: External place data
    //         Add a filter for hotel
    [_hotelStore queryWithQuery:q withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        [self.activityIndicator stopAnimating];
        if (errorOrNil == nil) {
            // Add all the returned annotations to the map
            [self.worldView addAnnotations:objectsOrNil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Get Notes"
                                                            message:errorOrNil.localizedDescription
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            
            [alert show];
            NSLog(@"Error: %@, %@, %d", errorOrNil.localizedDescription, errorOrNil.localizedFailureReason, errorOrNil.code);
        }
    } withProgressBlock:nil];
}

#pragma mark - CLLocationDelegate Methods

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSTimeInterval t = [[newLocation timestamp] timeIntervalSinceNow];

    // Don't bother using the location if it's a stale location
    if (t < -180){
        return;
    }
    
    // Start our processing for the location
    [self foundLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // Just log it for now.
    NSLog(@"Location manager failed with error: %@", error);
}

#pragma mark - MKMapView Delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // Testing this app shows that sometimes mapView:didUpdateUserLocation: gets called
    // with a nil value for location (so [userLocation coordinate] is not valid and we
    // can't use it.
    if ([userLocation location] != nil){
        CLLocationCoordinate2D center = [userLocation coordinate];
        [mapView setRegion:MKCoordinateRegionMakeWithDistance(center, ONE_KILOMETER, ONE_KILOMETER) animated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    // Whenever the region changes update the markers
    [self updateMarkers];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn: (UITextField *)textField
{
    // The user hit the "Done" key, so

    // Find the current location and mark the note
    [self findLocation];
    
    // Remove the keyboard and stop responding to non-touch events
    [textField resignFirstResponder];
    
    // Indicate that we're done
    return YES;
}

@end
