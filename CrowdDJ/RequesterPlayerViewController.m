//
//  RequesterPlayerViewController.m
//  CrowdDJ
//
//  Created by Marko Vojvodic on 10/4/14.
//  Copyright (c) 2014 Marko Vojvodic. All rights reserved.
//

#import "RequesterPlayerViewController.h"
#import "RequesterSearchViewController.h"

@interface RequesterPlayerViewController ()

@end

@implementation RequesterPlayerViewController

// TODO: ping server every 30 s

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // set up table view cells
    [trackQueueTableView registerNib:[UINib nibWithNibName:@"TrackCell" bundle:nil] forCellReuseIdentifier:[TrackCell reuseIdentifier]];
    [trackQueueTableView setRowHeight:64];
    
    tracks = [[NSMutableArray alloc] init];
    
    // TODO: colors/images
    skipButton.titleLabel.text = @"Skip";
    requestButton.titleLabel.text = @"Request";
    
    [self loadQueue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [tracks count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrackCell *cell = (TrackCell *)[tableView dequeueReusableCellWithIdentifier:[TrackCell reuseIdentifier]
                                                                   forIndexPath:indexPath];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"TrackCell" owner:self options:nil];
        cell = trackTableViewCell;
        trackTableViewCell = nil;
    }
    
    NSDictionary * track = [tracks objectAtIndex:indexPath.row];
    // Configure the cell...
    [cell setTitle:[track objectForKey:@"title"]];
    [cell setArtist:[[track objectForKey:@"user"] objectForKey:@"username"]];
    
    return cell;
}

#pragma mark - server interface

- (void) loadQueue
{
    // TODO: send request to server
    
    titleTextView.text = [[tracks firstObject] objectForKey:@"title"];
    artistTextView.text = [[[tracks firstObject] objectForKey:@"user"] objectForKey:@"username"];
    
    [trackQueueTableView reloadData];
}

- (IBAction) skipSong
{
    // send request to server to skip song
}

- (IBAction) requestSong
{
    RequesterSearchViewController *requesterViewController = [[RequesterSearchViewController alloc] initWithNibName:@"RequesterSearchViewController" bundle:nil];
    [self.navigationController pushViewController:requesterViewController animated:YES];
}

@end
