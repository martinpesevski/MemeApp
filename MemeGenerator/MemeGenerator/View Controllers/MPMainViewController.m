//
//  ViewController.m
//  AllHotels
//
//  Created by Martin Peshevski on 3/2/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import "MPMainViewController.h"
#import "MPSideMenuViewController.h"

@interface MPMainViewController ()

@property (nonatomic, strong) MPSideMenuViewController *leftMenu;

@end

@implementation MPMainViewController

- (void)setup
{
    MPSideMenuViewController *leftMenuController = [[MPSideMenuViewController alloc] init];
    self.leftViewWidth = 250.0;
    self.leftViewBackgroundColor = [UIColor colorWithRed:0.5 green:0.6 blue:0.5 alpha:0.9];
    self.rootViewCoverColorForLeftView = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.05];
    self.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
    self.leftViewController = leftMenuController;
}

- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size {
    [super leftViewWillLayoutSubviewsWithSize:size];
    
    if (!self.isLeftViewStatusBarHidden) {
        self.leftView.frame = CGRectMake(0.0, 20.0, size.width, size.height-20.0);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self showLeftViewAnimated:YES completionHandler:nil];
}

- (void)setupViews
{
    
}
    
- (void)setConstraints
{
    
}


    
@end
