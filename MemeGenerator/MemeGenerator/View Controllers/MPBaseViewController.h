//
//  MPBaseViewController.h
//  Betting
//
//  Created by Martin Peshevski on 4/29/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPNavigationBarView.h"

@interface MPBaseViewController : UIViewController

- (void)addTitleViewWithTitle:(NSString *)title image:(UIImage *)image;
- (void)addTitleViewWithTitle:(NSString *)title image:(UIImage *)image description:(NSString *)description;
- (void)onBack;

@end
