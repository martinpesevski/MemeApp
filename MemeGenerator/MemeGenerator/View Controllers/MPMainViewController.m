//
//  ViewController.m
//  AllHotels
//
//  Created by Martin Peshevski on 3/2/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import "MPMainViewController.h"
#import "MPSideMenuViewController.h"
#import "MPColorManager.h"

@interface MPMainViewController ()

@property (nonatomic, strong) MPSideMenuViewController *leftMenu;

@end

@implementation MPMainViewController

- (void)setup
{
    MPSideMenuViewController *rightMenuController = [[MPSideMenuViewController alloc] init];
    self.rightViewWidth = 200.0;
    self.rightViewBackgroundColor = [[MPColorManager getBackgroundColor] colorWithAlphaComponent:0.9];
    self.rootViewCoverColorForRightView = [[MPColorManager getBackgroundColor] colorWithAlphaComponent:0.5];
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
}

- (void)setupViews
{
    
}
    
- (void)setConstraints
{
    
}


    
@end
