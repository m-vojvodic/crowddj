//
//  RequesterConnectViewController.m
//  CrowdDJ
//
//  Created by Marko Vojvodic on 10/4/14.
//  Copyright (c) 2014 Marko Vojvodic. All rights reserved.
//

#import "RequesterConnectViewController.h"
#import "RequesterPlayerViewController.h"
#import "ServerInterface.h"

@interface RequesterConnectViewController ()

@end

@implementation RequesterConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)connectToDj:(id)sender {
    if([djIdTextField.text isEqual:@""]){
        NSLog(@"No can dosville baby doll");
        return;
    }
    ServerInterface * djServerInterface = [ServerInterface serverInterface];
    [djServerInterface set_djId:djIdTextField.text];
    
    //need server
    NSLog(@"djServerInterface/_djId %@", [djServerInterface get_djId]);
    [djServerInterface retrieveDjWithOptions:@{@"options":@{}}
                                     success:^(NSArray * tracks){
                                         // TODO: possible conditional statements
                                         NSLog(@"%@", tracks);
                                         djIdTextField.text = 0;
                                         
                                         RequesterPlayerViewController *rpvc = [[RequesterPlayerViewController alloc] initWithNibName:@"RequesterPlayerViewController" bundle:nil];
                                         [rpvc setTracks:tracks];
                                         [self.navigationController pushViewController:rpvc animated:YES];
                                     }
                                     failure:^(NSError * err){
                                         NSLog(@"%@", err);
                                     }
     ];
    
    RequesterPlayerViewController *rpvc = [[RequesterPlayerViewController alloc] initWithNibName:@"RequesterPlayerViewController" bundle:nil];

    [self.navigationController pushViewController:rpvc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
