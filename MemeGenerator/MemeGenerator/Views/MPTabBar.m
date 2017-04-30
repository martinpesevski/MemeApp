//
//  MPTabBar.m
//  Betting
//
//  Created by Martin Peshevski on 4/29/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import "MPTabBar.h"
#import "MPTab.h"
#import "Constants.h"
#import "Masonry.h"

@interface MPTabBar () <MPTabDelegate>

@property (nonatomic, strong) NSMutableArray *tabsArray;

@end

@implementation MPTabBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectedTabIndex = 0;
    }
    return self;
}

- (void)setupWithTabNames:(NSArray *)tabNames
{
    NSMutableArray *tabNamesMutable = [[NSMutableArray alloc] init];
    
    for (NSString *name in tabNames) {
        NSString *resultName = [name uppercaseString];
        resultName = [resultName stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        
        [tabNamesMutable addObject:resultName];
    }
    
    self.tabNamesArray = tabNamesMutable;
    
    [self setupViews];
    [self setConstraints];
}

- (void)setupViews
{
    for (int i = 0; i <self.tabsArray.count; i++) {
        MPTab *tab = self.tabsArray[i];
        
        [tab removeFromSuperview];
        tab = nil;
    }
    
    self.tabsArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<self.tabNamesArray.count; i++) {
        MPTab *tab = [[MPTab alloc] initWithTitle:self.tabNamesArray[i]];
        tab.tag = i;
        tab.tabDelegate = self;
        [self.tabsArray addObject:tab];
        
        [self addSubview:tab];
    }

    [self setSelectedTabIndex:_selectedTabIndex];
}

- (void)setConstraints
{
    [self reloadConstraints];
}

- (void)didSelectTab:(id)tab
{
    int index = (int)((MPTab *)tab).tag;
    self.selectedTabIndex = index;

    if (self.tabBarDelegate) {
        [self.tabBarDelegate didSelectTabAtIndex:index];
    }
}

- (void)reloadConstraints
{
    int numberOfTabs = (int)self.tabsArray.count;
    float tabWidth = kScreenWidth/numberOfTabs;
    
    for (int i=0; i<self.tabsArray.count; i++) {
        MPTab *tab = self.tabsArray[i];
        
        [tab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(i*tabWidth);
            make.width.equalTo(@(tabWidth));
        }];
    }
}

- (void)setSelectedTabIndex:(int)selectedTabIndex
{
    _selectedTabIndex = selectedTabIndex;
    
    for (MPTab *tab in self.tabsArray) {
        if (tab.tag != selectedTabIndex) {
            [tab setSelected:NO];
        } else {
            [tab setSelected:YES];
        }
    }
}

@end
