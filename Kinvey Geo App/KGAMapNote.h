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

@end
