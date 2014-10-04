//
//  RequesterSearchViewController.m
//  CrowdDJ
//
//  Created by Marko Vojvodic on 10/4/14.
//  Copyright (c) 2014 Marko Vojvodic. All rights reserved.
//

#import "RequesterSearchViewController.h"

@interface RequesterSearchViewController ()

@end

@implementation RequesterSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // set up table view cells
    [searchResultsTableView registerNib:[UINib nibWithNibName:@"TrackCell" bundle:nil] forCellReuseIdentifier:[TrackCell reuseIdentifier]];
    [searchResultsTableView setRowHeight:64];
    
    tracks = [[NSMutableArray alloc] init];
    
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

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    trackToAddToQueue = [tracks objectAtIndex:indexPath.row];
    // TODO: send server a request
}

#pragma mark - search bar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text = @"";
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    if([searchBar.text isEqual:@""]){
        return;
    }
    // TODO: fetch results from server
    
    NSLog(@"tracks:\n%@", tracks);
    
    [searchResultsTableView reloadData];
}


@end
