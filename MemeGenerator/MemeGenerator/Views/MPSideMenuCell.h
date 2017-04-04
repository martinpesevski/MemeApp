//
//  MPSideMenuCell.h
//  Betting
//
//  Created by Martin Peshevski on 4/29/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum:NSInteger {
    MPSideMenuCellTypeYourMemes = 0,
    MPSideMenuCellTypeNewest = 1,
    MPSideMenuCellTypePopular = 2,
} MPSideMenuCellType;

@interface MPSideMenuCell : UITableViewCell

- (void)setupWithTitle:(MPSideMenuCellType)cellType;
- (void)showUserLabel;

@end
