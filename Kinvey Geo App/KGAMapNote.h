//
//  KGAMapNote.h
//  Kinvey GeoTag
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

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <KinveyKit/KinveyKit.h>

// Kinvey: Make sure to add 'KCSPersistable' here
@interface KGAMapNote : NSObject <MKAnnotation, KCSPersistable>


- (id)initWithLocation:(CLLocation*)location title: (NSString *)title;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) CLLocation* location;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray* tags;

// This iVar holds the complete results from the location provider
// (if not from Kinvey).  This is non-portable between location providers, but
// can give you more information if you're using a specific provider, or
// want to handle the mapping between various providers.
@property (nonatomic, readonly, retain) NSDictionary *fullLocationResults;

@end
