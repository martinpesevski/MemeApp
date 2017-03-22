//
//  MPControllerManager.m
//  Betting
//
//  Created by Martin Peshevski on 5/24/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import "MPControllerManager.h"
#import "AppDelegate.h"

@implementation MPControllerManager

+ (UIViewController *)getTopViewController
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *topController = [MPControllerManager topViewControllerWithRootViewController:appDelegate.viewController];
    
    return topController;
}

+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    // Handling UITabBarController
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [MPControllerManager topViewControllerWithRootViewController:tabBarController.selectedViewController];
    }
    // Handling UINavigationController
    else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [MPControllerManager topViewControllerWithRootViewController:navigationController.visibleViewController];
    }
    // Handling Modal views
    else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [MPControllerManager topViewControllerWithRootViewController:presentedViewController];
    }
    // Handling UIViewController's added as subviews to some other views.
    else {
        for (UIView *view in [rootViewController.view subviews])
        {
            id subViewController = [view nextResponder];    // Key property which most of us are unaware of / rarely use.
            if ( subViewController && [subViewController isKindOfClass:[UIViewController class]])
            {
                return [MPControllerManager topViewControllerWithRootViewController:subViewController];
            }
        }
        return rootViewController;
    }
}

+ (void)goToPreviousController
{
    UIViewController *topController = [MPControllerManager getTopViewController];
    [topController.navigationController popViewControllerAnimated:YES];
}

@end
