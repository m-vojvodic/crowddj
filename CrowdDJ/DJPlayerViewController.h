//
//  DJPlayerViewController.h
//  CrowdDJ
//
//  Created by Marko Vojvodic on 10/4/14.
//  Copyright (c) 2014 Marko Vojvodic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DJPlayerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray * tracks;
    AVAudioPlayer * player;

    IBOutlet UIWebView * playerWebView;
    IBOutlet UITableView * trackQueueTableView;
    IBOutlet UIButton * skipButton;
    IBOutlet UILabel * idLabel;
}

@end
