//
//  MPBaseLoginViewController.m
//  FanTrade
//
//  Created by Martin Peshevski on 1/16/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import "MPBaseLoginViewController.h"

@interface MPBaseLoginViewController ()

@end

@implementation MPBaseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    [navigationBar setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    
    [navigationBar setShadowImage:[UIImage new]];    
}



@end
