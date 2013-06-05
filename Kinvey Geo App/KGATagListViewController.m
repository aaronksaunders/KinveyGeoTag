//
//  KGATagListViewController.m
//  Kinvey GeoTag
//
//  Copyright 2013 Kinvey, Inc
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
//  Created by Michael Katz on 5/30/13.
//

#import "KGATagListViewController.h"

#import <KinveyKit/KinveyKit.h>

@interface KGATagListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) NSArray* tags;
@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic) BOOL userUpdated;
@end

@implementation KGATagListViewController

- (instancetype)initWithTags:(NSArray *)tags
{
    self = [super init];
    if (self) {
        _tags = tags;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.view = [[UIView alloc] init];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0., 240., 320., 240.)];
    
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    UILabel* label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor lightGrayColor];
    label.text = @"Select a tag to show & subscribe";

    self.tableView.tableHeaderView = label;
    self.tableView.clipsToBounds = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString* tag = _tags[indexPath.row];
    cell.textLabel.text = tag;
    
    NSArray* userTags = [[KCSUser activeUser] getValueForAttribute:@"tags"];
    cell.accessoryType = (userTags && [userTags containsObject:tag]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor lightGrayColor];
    label.text = @"Select a tag to show & subscribe";
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* tag = _tags[indexPath.row];
    NSMutableArray* userTags = [[KCSUser activeUser] getValueForAttribute:@"tags"];
    
    if ((userTags && [userTags containsObject:tag])) {
        [userTags removeObject:tag];
    } else {
        if (!userTags) {
            userTags = [NSMutableArray array];
            [[KCSUser activeUser] setValue:userTags forAttribute:@"tags"];
        }
        [userTags addObject:tag];
    }
    _userUpdated = YES;
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - View Lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _userUpdated = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_userUpdated == YES) {
        [[KCSUser activeUser] saveWithCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            NSLog(@"saved user: %@ - %@", @(errorOrNil == nil), errorOrNil);
            
        }];
    }
}

@end
