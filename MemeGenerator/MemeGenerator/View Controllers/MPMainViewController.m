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
    MPSideMenuViewController *rightMenuController = [[MPSideMenuViewController alloc] init];
    self.rightViewWidth = 200.0;
    self.rightViewBackgroundColor = [UIColor colorWithRed:0.5 green:0.6 blue:0.5 alpha:0.9];
    self.rootViewCoverColorForRightView = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.05];
    self.rightViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
    self.rightViewController = rightMenuController;
}

- (void)rightViewWillLayoutSubviewsWithSize:(CGSize)size {
    [super rightViewWillLayoutSubviewsWithSize:size];
    
    if (!self.isRightViewStatusBarHidden) {
        self.rightView.frame = CGRectMake(0.0, 20.0, size.width, size.height-20.0);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self showRightViewAnimated:YES completionHandler:nil];
}

- (void)setupViews
{
    
}
    
- (void)setConstraints
{
    
}


    
@end
