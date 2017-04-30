//
//  MPTab.h
//  Betting
//
//  Created by Martin Peshevski on 4/29/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPTabDelegate <NSObject>

- (void)didSelectTab:(id)tab;

@end

@interface MPTab : UIView

@property (nonatomic ,strong) id<MPTabDelegate> tabDelegate;

- (instancetype)initWithTitle:(NSString *)title;
- (void)setSelected:(BOOL)isSelected;

@end
