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
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "MPLoginViewController.h"
#import "MPAuthenticationManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([[MPAuthenticationManager sharedManager] isLoggedIn]) {
        [self setMainController];
    } else {
        [self setSignIn];
    }
    
    [self setNavigationBarAppearance];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];

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

- (void)setSignIn
{
    MPLoginViewController *loginController = [[MPLoginViewController alloc] init];
    MPBaseNavigationViewController *loginNavController = [[MPBaseNavigationViewController alloc] initWithRootViewController:loginController];
    
    self.viewController = loginNavController;
    self.window.rootViewController = self.viewController;

    [UIView transitionWithView:self.window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
}

@end
