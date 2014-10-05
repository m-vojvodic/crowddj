//
//  SplashScreenViewController.m
//  CrowdDJ
//
//  Created by Marko Vojvodic on 10/4/14.
//  Copyright (c) 2014 Marko Vojvodic. All rights reserved.
//

#import "SplashScreenViewController.h"
#import "DJPlayerViewController.h"
#import "RequesterConnectViewController.h"
#import "UIImage.h"



@interface SplashScreenViewController ()

@end

@implementation SplashScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // set up bg and logo
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGSize phoneSize = CGSizeMake(width, height);
    
    UIImage *BGImage = [UIImage imageNamed: @"scratchbglarge.png"];
    UIImage *scaledBG = [BGImage scaleToSize: phoneSize];
    self.view.backgroundColor = [UIColor colorWithPatternImage: scaledBG];
    
    UIImage *logoLarge = [UIImage imageNamed: @"scratchredlogo.png"];
    CGFloat logoWidth = width * 3/4;
    CGFloat logoProportion = logoWidth / logoLarge.size.width;
    CGFloat logoHeight = logoLarge.size.height * logoProportion - logoProportion/2;
    
    UIImage *scaledLogo = [UIImage imageWithCGImage:[logoLarge CGImage]
                                              scale:(logoLarge.scale * logoProportion)
                                        orientation: (logoLarge.imageOrientation)];
    
    UIImageView *logoHolder = [[UIImageView alloc] initWithFrame: CGRectMake(width/7.5, height/2.5,logoWidth, logoHeight)];
    logoHolder.image = scaledLogo;
    
    [self.view addSubview: logoHolder];
    
    
    /*UIButton *DJButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview: DJButton];*/
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToDjViewController:(id)sender {
     DJPlayerViewController *myViewController = [[DJPlayerViewController alloc] initWithNibName:@"DJPlayerViewController" bundle:nil];
    [self.navigationController pushViewController:myViewController animated:YES];


}

- (IBAction)goToRequestController:(id)sender {
    RequesterConnectViewController *myViewController = [[RequesterConnectViewController alloc] initWithNibName:@"RequesterConnectViewController" bundle:nil];
    [self.navigationController pushViewController:myViewController animated:YES];
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
