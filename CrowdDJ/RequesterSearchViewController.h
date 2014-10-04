//
//  RequesterSearchViewController.h
//  CrowdDJ
//
//  Created by Marko Vojvodic on 10/4/14.
//  Copyright (c) 2014 Marko Vojvodic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackCell.h"

@interface RequesterSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    IBOutlet UISearchBar * songSearchBar;
    IBOutlet UITableView * searchResultsTableView;
    IBOutlet TrackCell * trackTableViewCell;
    
    NSMutableArray * tracks;
    
    NSDictionary * trackToAddToQueue;
}
@end
