//
//  KGAMapNote.m
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

#import "KGAMapNote.h"

#import "KCSHashtags.h"

// Private interface that holds our id and coordinate array
// these are only used internally
@interface KGAMapNote ()

@property (nonatomic) NSString *noteId;
@property (nonatomic, readwrite, retain) NSDictionary *fullLocationResults;

@end

@implementation KGAMapNote

- (id)init
{
    // If this is initialized incorrectly, we'll return a dummy value
    return [self initWithLocation:[[CLLocation alloc] initWithLatitude:37.785835 longitude:-122.406417] title:@"Rio de Janeiro"];
}

- (id)initWithLocation:(CLLocation*)location title:(NSString *)title
{
    self = [super init];
    if (self){
        _noteId = nil;
        _location = location;
        _title = title;
        _tags = [KCSHashtags tagsFromString:title];
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate
{
    return [_location coordinate];
}


// Kinvey: Mapping function
- (NSDictionary *)hostToKinveyPropertyMapping
{
    // So it's only initialized once
    static NSDictionary *mapping = nil;
    
    if (mapping == nil){
        //          client property        : backend column
        //          -----------------------:------------------------
        mapping = @{@"noteId"              : KCSEntityKeyId,          // noteId maps to _id
                    @"location"            : KCSEntityKeyGeolocation, // coordinates maps to _geoloc
                    @"title"               : @"name",                 // title maps to note
                    @"fullLocationResults" : @"fullResults",          // Grab the non-portable results
                    @"tags"                : @"tags"};                // the hashtags
    }
    
    return mapping;
}

@end
