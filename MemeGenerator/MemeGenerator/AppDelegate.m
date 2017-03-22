//
//  AppDelegate.m
//  MemeGenerator
//
//  Created by Martin Peshevski on 3/22/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import "AppDelegate.h"
#import "MPColorManager.h"
#import "MPBaseNavigationViewController.h"
#import "MPMainViewController.h"
#import "MPDashboardController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self setMainController];
    
    [self setNavigationBarAppearance];
    
    return YES;
}

- (void)setNavigationBarAppearance
{
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor whiteColor]
                                                           }];
    [[UINavigationBar appearance] setBarTintColor:[MPColorManager getNavigationBarColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}

- (void)setMainController
{
    MPDashboardController *hotelsController = [[MPDashboardController alloc] init];
    MPBaseNavigationViewController *dashboardNavController = [[MPBaseNavigationViewController alloc] initWithRootViewController:hotelsController];
    
    MPMainViewController *mainViewController = [[MPMainViewController alloc] init];
    mainViewController.rootViewController = dashboardNavController;
    [mainViewController setup];
    self.viewController = mainViewController;
    self.window.rootViewController = self.viewController;
    
    [UIView transitionWithView:self.window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
}

@end
