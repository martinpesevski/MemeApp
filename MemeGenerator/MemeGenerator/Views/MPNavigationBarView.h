//
//  MPNavigationBarView.h
//  Betting
//
//  Created by Martin Peshevski on 7/2/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPNavigationBarView : UIView

- (void)setupWithTitle:(NSString *)title image:(UIImage *)image;
- (void)setupWithTitle:(NSString *)title image:(UIImage *)image description:(NSString *)description;

@end
