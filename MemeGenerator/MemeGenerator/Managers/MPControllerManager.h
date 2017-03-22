//
//  MPControllerManager.h
//  Betting
//
//  Created by Martin Peshevski on 5/24/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPControllerManager : NSObject

+ (UIViewController *)getTopViewController;
+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController*)rootViewController;
+ (void)goToPreviousController;

@end
