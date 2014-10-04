//
//  RequesterPlayerViewController.h
//  CrowdDJ
//
//  Created by Marko Vojvodic on 10/4/14.
//  Copyright (c) 2014 Marko Vojvodic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackCell.h"

@interface RequesterPlayerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView * trackQueueTableView;
    
    IBOutlet TrackCell * trackTableViewCell;
    
    IBOutlet UIButton * skipButton;
    IBOutlet UIButton * requestButton;
    
    IBOutlet UIImageView * artworkOfCurrentTrack;
    
    IBOutlet UITextView * artistTextView;
    IBOutlet UITextView * titleTextView;
    
    NSMutableArray * tracks;
    NSString * djId;
    NSString * artworkUrl;
}

@end
