//
//  KGAMapNote.h
//  Kinvey Geo App
//
//  Created by Brian Wilson on 5/3/12.
//  Copyright (c) 2012 Kinvey. See LICENSE for license information.
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <KinveyKit/KinveyKit.h>

// Kinvey: Make sure to add 'KCSPersistable' here
@interface KGAMapNote : NSObject <MKAnnotation, KCSPersistable>


- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title: (NSString *)title;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;

// This iVar holds the complete results from the location provider
// (if not from Kinvey).  This is non-portable between location providers, but
// can give you more information if you're using a specific provider, or
// want to handle the mapping between various providers.
@property (nonatomic, readonly, retain) NSDictionary *fullLocationResults;

@end
