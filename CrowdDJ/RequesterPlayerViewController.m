//
//  RequesterPlayerViewController.m
//  CrowdDJ
//
//  Created by Marko Vojvodic on 10/4/14.
//  Copyright (c) 2014 Marko Vojvodic. All rights reserved.
//

#import "RequesterPlayerViewController.h"
#import "RequesterSearchViewController.h"
#import "ServerInterface.h"
#import "UIImage.h"
#import "UIImage+BlurredFrame.h"

@interface RequesterPlayerViewController ()

@end

@implementation RequesterPlayerViewController

// TODO: ping server every 30 s (loadQueue)

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
    
    [tracks addObject:@{
                        
                        @"id": @13158665,
                        @"created_at": @"2011/04/06 15:37:43 +0000",
                        @"user_id": @3699101,
                        @"duration": @18109,
                        @"commentable": @true,
                        @"state": @"finished",
                        @"sharing": @"public",
                        @"tag_list": @"soundcloud:source=iphone-record",
                        @"permalink": @"munching-at-tiannas-house",
                        @"description": @"",
                        @"streamable": @true,
                        @"downloadable": @true,
                        @"genre": @"",
                        @"release": @"",
                        @"purchase_url": @"",
                        @"label_id": @"",
                        @"label_name": @"",
                        @"isrc": @"",
                        @"video_url": @"",
                        @"track_type": @"recording",
                        @"key_signature": @"",
                        @"bpm": @"",
                        @"title": @"Munching at Tiannas house",
                        @"release_year": @"",
                        @"release_month": @"",
                        @"release_day": @"",
                        @"original_format": @"m4a",
                        @"original_content_size": @10211857,
                        @"license": @"all-rights-reserved",
                        @"uri": @"http://api.soundcloud.com/tracks/13158665",
                        @"permalink_url": @"http://soundcloud.com/user2835985/munching-at-tiannas-house",
                        @"artwork_url": @"",
                        @"waveform_url": @"http://w1.sndcdn.com/fxguEjG4ax6B_m.png",
                        @"user": @{
        @"id": @3699101,
        @"permalink": @"user2835985",
        @"username": @"user2835985",
        @"uri": @"http://api.soundcloud.com/users/3699101",
        @"permalink_url": @"http://soundcloud.com/user2835985",
        @"avatar_url": @"http://a1.sndcdn.com/images/default_avatar_large.png?142a848"
    },
                        @"stream_url": @"http://api.soundcloud.com/tracks/13158665/stream",
                        @"download_url": @"http://api.soundcloud.com/tracks/13158665/download",
                        @"playback_count": @0,
                        @"download_count": @0,
                        @"favoritings_count": @0,
                        @"comment_count": @0,
                        @"created_with": @{
        @"id": @124,
        @"name": @"SoundCloud iPhone",
        @"uri": @"http://api.soundcloud.com/apps/124",
        @"permalink_url": @"http://soundcloud.com/apps/iphone"
    },
                        @"attachments_uri": @"http://api.soundcloud.com/tracks/13158665/attachments"
                        }
     ];
    
    [self loadQueue];
    
    [NSTimer scheduledTimerWithTimeInterval:30.0
                                     target:self
                                   selector:@selector(loadQueue)
                                   userInfo:nil
                                    repeats:YES];
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
    // TODO: check if need to skip
    
    ServerInterface * djServerInterface = [ServerInterface serverInterface];
    [djServerInterface retrieveTracksOnSuccess:^(NSArray * dict){
        tracks = [NSMutableArray arrayWithArray:dict];
    }
                                       failure:^(NSError * err){
                                           NSLog(@"%@", err);
                                       }
     ];
    
    titleTextView.text = [[tracks firstObject] objectForKey:@"title"];
    artistTextView.text = [[[tracks firstObject] objectForKey:@"user"] objectForKey:@"username"];

    
    if(![[[tracks firstObject] objectForKey:@"artwork_url"] isEqual:@""]){
        // if there is unique artwork for the track
        artworkUrl = [[tracks firstObject] objectForKey:@"artwork_url"];
        NSLog(@"the artwork_url was equal to null string");
    }
    else{
        // else use profile pic artwork
        artworkUrl = [[[tracks firstObject] objectForKey:@"user"] objectForKey:@"avatar_url"];
    }

    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:artworkUrl]]];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGSize topHalfSize = CGSizeMake(width, width/1.25);
    
    UIImage *scaledImage = [image scaleToSize: topHalfSize];
    CGRect blurFrame = CGRectMake(0, 0, scaledImage.size.width, scaledImage.size.height);
    scaledImage = [scaledImage applyLightEffectAtFrame:blurFrame];
    
   // UIView * darkGrey = [[[UIView] alloc] initWithFrame: CGRectMake(0,0,width,width)];
    UIView * darkGreyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width/1.25)];
    CGFloat newHeight = 2*width / 3;
    UIView * songInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, width/3.5, width, width/4.5)];
    [darkGreyView setBackgroundColor: [UIColor colorWithRed: 0.2 green: 0.2 blue: 0.2 alpha:0.4]];
    [songInfoView setBackgroundColor: [UIColor colorWithRed: 0.1 green: 0.1 blue: 0.1 alpha:0.8]];
    
    //skip button
    CGSize buttonSize = CGSizeMake(width/4, width/6);
    UIImage * skipImage = [UIImage imageNamed:@"skipButton.png"];
    UIImage * scaledSkipImage = [skipImage scaleToSize: buttonSize];
    UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [skipButton setImage:scaledSkipImage forState:UIControlStateNormal];
    skipButton.frame = CGRectMake(width/7.5, width/1.75, scaledSkipImage.size.width, scaledSkipImage.size.height);
    [skipButton addTarget:self
                   action: @selector(skipTrack)
         forControlEvents: UIControlEventTouchDown];
    
    //add button
    UIImage * addImage = [UIImage imageNamed:@"addButton.png"];
    UIImage * scaledAddImage = [addImage scaleToSize: buttonSize];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:scaledAddImage forState:UIControlStateNormal];
    addButton.frame = CGRectMake(width/1.65, width/1.75, scaledAddImage.size.width, scaledAddImage.size.height);
    [addButton addTarget:self
                   action: @selector(requestSong)
         forControlEvents: UIControlEventTouchDown];
    

    
    UIImageView * imageView = [[UIImageView alloc] initWithImage: scaledImage];
    //artworkImageView.image = image;
    //artworkImageView = imageView;
    
    [self.view addSubview:imageView];
    [self.view addSubview:darkGreyView];
    [self.view addSubview:songInfoView];
    [self.view addSubview:skipButton];
    [self.view addSubview:addButton];
    imageView.layer.zPosition = -100;
    darkGreyView.layer.zPosition = -99;
    songInfoView.layer.zPosition = -98;
    
    [trackQueueTableView reloadData];
}

- (void) skipTrack
{
    ServerInterface * djServerInterface = [ServerInterface serverInterface];
    [djServerInterface updateTrackWithTrackId:[[tracks firstObject] objectForKey:@"id"]
                                      success:^(){
                                          // TODO: implement skipping reuqest
                                      }
                                    failure:^(NSError * err){
                                        NSLog(@"%@", err);
                                    }
     ];
}

- (void) requestSong
{
    RequesterSearchViewController *requesterViewController = [[RequesterSearchViewController alloc] initWithNibName:@"RequesterSearchViewController" bundle:nil];
    [self.navigationController pushViewController:requesterViewController animated:YES];
}

- (void) setTracks:(NSArray *) newTracks
{
    tracks = [NSMutableArray arrayWithArray:newTracks];
}

- (void) addTrack:(NSDictionary *) newTrack
{
    [tracks addObject:newTrack];
}

@end
