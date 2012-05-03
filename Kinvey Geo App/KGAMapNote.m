//
//  KGAMapNote.m
//  Kinvey Geo App
//
//  Created by Brian Wilson on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KGAMapNote.h"

@implementation KGAMapNote

@synthesize coordinate = _coordinate;
@synthesize title = _title;

- (id)init
{
    return [self initWithCoordinate:CLLocationCoordinate2DMake(37.785835, -122.406417) title:@"Rio de Janeiro"];
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title
{
    self = [super self];
    if (self){
        _coordinate = coordinate;
        [self setTitle:title];
    }
    return self;
}



@end
