//
//  KGAMapNote.h
//  Kinvey Geo App
//
//  Created by Brian Wilson on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface KGAMapNote : NSObject <MKAnnotation>


- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title: (NSString *)title;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;

@end
