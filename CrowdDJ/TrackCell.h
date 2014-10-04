//
//  TrackCell.h
//  CrowdDJ
//
//  Created by Marko Vojvodic on 10/4/14.
//  Copyright (c) 2014 Marko Vojvodic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackCell : UITableViewCell
{
    IBOutlet UILabel * titleLabel;
    IBOutlet UILabel * artistNameLabel;
}

+ (NSString *)reuseIdentifier;

- (void) setTitle:(NSString *)title;
- (void) setArtist:(NSString *)artist;

@end
