//
//  KGAMapNote.m
//  Kinvey Geo App
//
//  Created by Brian Wilson on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KGAMapNote.h"

@interface KGAMapNote ()

@property (nonatomic) NSArray *latLong;
@property (nonatomic) NSString *noteId;

@end

@implementation KGAMapNote

// @synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize latLong = _latLong;
@synthesize noteId = _noteId;


- (id)init
{
    return [self initWithCoordinate:CLLocationCoordinate2DMake(37.785835, -122.406417) title:@"Rio de Janeiro"];
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title
{
    self = [super self];
    if (self){
        _latLong = nil;
        _noteId = nil;
        [self setCoordinate: coordinate];
        [self setTitle:title];
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    self.latLong = [NSArray arrayWithObjects:
                    [NSNumber numberWithDouble:newCoordinate.longitude],
                    [NSNumber numberWithDouble:newCoordinate.latitude], nil];
}

- (CLLocationCoordinate2D)coordinate
{
    NSNumber *lat = [self.latLong objectAtIndex:1];
    NSNumber *lon = [self.latLong objectAtIndex:0];
    
    return CLLocationCoordinate2DMake(lat.doubleValue, lon.doubleValue);
}


- (NSDictionary *)hostToKinveyPropertyMapping
{
    static NSDictionary *mapping = nil;
    
    if (mapping == nil){
        mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                   @"_id", @"noteId",
                   @"_geoloc", @"latLong",
                   @"note", @"title", nil];
    }
    
    return mapping;
    
    
}

@end
