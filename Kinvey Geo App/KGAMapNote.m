//
//  KGAMapNote.m
//  Kinvey Geo App
//
//  Created by Brian Wilson on 5/3/12.
//  Copyright (c) 2012 Kinvey. See LICENSE for license information.
//

#import "KGAMapNote.h"

// Map latitude and longitude to the correct indices
enum {
    kKGALongitudeIndex = 0,
    kKGALatitudeIndex = 1
};

// Private interface that holds our id and coordinate array
// these are only used internally
@interface KGAMapNote ()

@property (nonatomic) NSArray *coordinateArray;
@property (nonatomic) NSString *noteId;

@end

@implementation KGAMapNote

@synthesize title = _title;
@synthesize coordinateArray = _coordinateArray;
@synthesize noteId = _noteId;


- (id)init
{
    // If this is initialized incorrectly, we'll return a dummy value
    return [self initWithCoordinate:CLLocationCoordinate2DMake(37.785835, -122.406417) title:@"Rio de Janeiro"];
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title
{
    self = [super self];
    if (self){
        _coordinateArray = nil;
        _noteId = nil;
        [self setCoordinate: coordinate];
        [self setTitle:title];
    }
    return self;
}

// Setter for 'coordinate' property
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    // Update the coordinateArray with the coordinate information
    self.coordinateArray = [NSArray arrayWithObjects:
                    [NSNumber numberWithDouble:newCoordinate.longitude],
                    [NSNumber numberWithDouble:newCoordinate.latitude], nil];
}

// Getter for 'coordinate' property
- (CLLocationCoordinate2D)coordinate
{
    // Build the CLLocationCoordinate2D from our array
    NSNumber *lat = [self.coordinateArray objectAtIndex:kKGALatitudeIndex];
    NSNumber *lon = [self.coordinateArray objectAtIndex:kKGALongitudeIndex];
    
    return CLLocationCoordinate2DMake(lat.doubleValue, lon.doubleValue);
}

// Kinvey: Mapping function
- (NSDictionary *)hostToKinveyPropertyMapping
{
    // So it's only initialized once
    static NSDictionary *mapping = nil;
    
    if (mapping == nil){
        mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                   @"_id", @"noteId",              // noteId maps to _id
                   @"_geoloc", @"coordinateArray", // coordinateArray maps to _geoloc
                   @"note", @"title", nil];        // title maps to note
    }
    
    return mapping;
    
    
}

@end
