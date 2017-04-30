//
//  MPTabBar.h
//  Betting
//
//  Created by Martin Peshevski on 4/29/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPTabBarDelegate <NSObject>

- (void)didSelectTabAtIndex:(int)index;

@end

@interface MPTabBar : UIView

@property (nonatomic, strong) id<MPTabBarDelegate> tabBarDelegate;
@property (nonatomic) int selectedTabIndex;
@property (nonatomic, strong) NSArray *tabNamesArray;

- (void)setupWithTabNames:(NSArray *)tabNames;
- (void)reloadConstraints;

@end
