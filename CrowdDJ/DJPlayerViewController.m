//
//  DJPlayerViewController.m
//  CrowdDJ
//
//  Created by Marko Vojvodic on 10/4/14.
//  Copyright (c) 2014 Marko Vojvodic. All rights reserved.
//

#import "DJPlayerViewController.h"
#import "SplashScreenViewController.h"

@interface DJPlayerViewController ()

@end

@implementation DJPlayerViewController

// TODO: ping server every 30 seconds

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // set up table view cells
    [trackQueueTableView registerNib:[UINib nibWithNibName:@"TrackCell" bundle:nil] forCellReuseIdentifier:[TrackCell reuseIdentifier]];
    [trackQueueTableView setRowHeight:64];
    
    tracks = [[NSMutableArray alloc] init];
    
    // just for testing
    /*
    [tracks addObject:@{
        @"title": @"Munching at Tiannas house",
        @"uri": @"http://api.soundcloud.com/tracks/13158665",
        @"permalink_url": @"http://soundcloud.com/user2835985/munching-at-tiannas-house",
        @"user": @{
            @"id": @3699101,
            @"permalink": @"user2835985",
            @"username": @"user2835985",
            @"uri": @"http://api.soundcloud.com/users/3699101",
            @"permalink_url": @"http://soundcloud.com/user2835985",
            @"avatar_url": @"http://a1.sndcdn.com/images/default_avatar_large.png?142a848"
        },
        @"stream_url": @"http://api.soundcloud.com/tracks/13158665/stream",
        @"download_url": @"http://api.soundcloud.com/tracks/13158665/download"
    }
     ];
    [tracks addObject:@{
                        @"title": @"Berghain bangers",
                        @"uri": @"http://api.soundcloud.com/tracks/69422508",
                        @"permalink_url": @"http://soundcloud.com/jochempaap/speedy-j-berghain-nov-2012",
                        @"user": @{
                                @"id": @3699101,
                                @"permalink": @"user2835985",
                                @"username": @"berghain",
                                @"uri": @"http://api.soundcloud.com/users/3699101",
                                @"permalink_url": @"http://soundcloud.com/user2835985",
                                @"avatar_url": @"http://a1.sndcdn.com/images/default_avatar_large.png?142a848"
                                },
                        @"stream_url": @"http://api.soundcloud.com/tracks/13158665/stream",
                        @"download_url": @"http://api.soundcloud.com/tracks/13158665/download"
                        }
     ];
    */
    
    // TODO: colors / images
    
    skipButton.titleLabel.text = @"Skip";
    idLabel.text = djId;

    [self loadQueue];
    
    // load player
    [self setUrlToPlay];
    [playerWebView loadHTMLString:urlToPlay baseURL:nil];
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

#pragma mark - Table view data source

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
    [trackQueueTableView reloadData];
}

// TODO: fix autoplay
- (void) setUrlToPlay
{
    // construct url from queue
    NSString * beginningOfUrlString = @"<iframe width=\"100%\" height=\"120\" scrolling=\"no\" frameborder=\"no\" src=\"https://w.soundcloud.com/player/?url=";
    NSString * newUrlToPlay = [[tracks firstObject] objectForKey:@"uri"];
    NSString * endOfUrlString = @"&auto_play=true\"></iframe>";

    urlToPlay = (NSMutableString *)[[[NSMutableString stringWithString:beginningOfUrlString] stringByAppendingString:newUrlToPlay] stringByAppendingString:endOfUrlString];
}

-(IBAction) skipSong
{
    // remove current song, set next song to play, reload table data
    if([tracks count] > 1){
        NSLog(@"Skipping song");
        [tracks removeObjectAtIndex:0];
        [self setUrlToPlay];
        [playerWebView loadHTMLString:urlToPlay baseURL:nil];
        [trackQueueTableView reloadData];
    }
}

@end
