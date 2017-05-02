//
//  MPBaseViewController.h
//  Betting
//
//  Created by Martin Peshevski on 4/29/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPNavigationBarView.h"
#import "MPAuthenticationManager.h"
#import "MPAlertManager.h"

typedef void(^simpleBlock)();

@interface MPBaseViewController : UIViewController <UITabBarDelegate>

@property (nonatomic, strong) UITabBar *tabBar;

- (void)addTitleViewWithTitle:(NSString *)title image:(UIImage *)image;
- (void)addTitleViewWithTitle:(NSString *)title image:(UIImage *)image description:(NSString *)description;
- (void)onBack;
- (void)setupTabbarWithNames:(NSArray *)names images:(NSArray *)images actions:(NSArray *)actions;
- (void)showLogin;
- (void)tabbarSetup;

@end
