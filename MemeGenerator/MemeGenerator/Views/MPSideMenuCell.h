//
//  MPSideMenuCell.h
//  Betting
//
//  Created by Martin Peshevski on 4/29/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum:NSInteger {
    MPSideMenuCellTypeTrade = 0,
    MPSideMenuCellTypeLeagues = 1,
    MPSideMenuCellTypeMates = 2,
    MPSideMenuCellTypeSettings = 3,
    MPSideMenuCellTypeSignOut = 4
} MPSideMenuCellType;

@interface MPSideMenuCell : UITableViewCell

- (void)setupWithTitle:(MPSideMenuCellType)cellType;
- (void)showUserLabel;

@end
