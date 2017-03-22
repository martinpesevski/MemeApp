//
//  MPSideMenuViewController.h
//  Betting
//
//  Created by Martin Peshevski on 4/29/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPSideMenuProtocol <NSObject>

- (void)showViewController:(UIViewController *)viewController;

@end

@interface MPSideMenuViewController : UIViewController

@property (nonatomic, strong) id<MPSideMenuProtocol> sideMenuDelegate;

- (UIViewController *)getFirstController;

@end
