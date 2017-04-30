//
//  MPTab.m
//  Betting
//
//  Created by Martin Peshevski on 4/29/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import "MPTab.h"
#import <QuartzCore/QuartzCore.h>
#import "MPColorManager.h"
#import "Masonry.h"
#import "MPFontManager.h"

@interface MPTab ()

@property (nonatomic, strong) UILabel *tabNameLabel;
@property (nonatomic, strong) NSString *tabName;
//@property (nonatomic, strong) UIView *bottomBorder;

@property (nonatomic, strong) UITapGestureRecognizer *tapRecogniser;

@end

@implementation MPTab

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.tabName = title;
        
        [self setupViews];
        [self setConstraints];
    }
    return self;
}

- (void)setupViews
{
    self.tapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelect)];
    [self addGestureRecognizer:self.tapRecogniser];
    
    self.tabNameLabel = [[UILabel alloc] init];
    self.tabNameLabel.text = self.tabName;
    self.tabNameLabel.textColor = [MPColorManager getLabelColorWhite];
    self.tabNameLabel.font = [MPFontManager getTabBarFont];
    self.tabNameLabel.textAlignment = NSTextAlignmentCenter;
    self.tabNameLabel.numberOfLines = 0;
    self.tabNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
//    self.bottomBorder = [[UIView alloc] init];
//    self.bottomBorder.backgroundColor = [MPColorManager getNavigationBarColor];
//    self.bottomBorder.hidden = YES;
    
    [self addSubview:self.tabNameLabel];
//    [self addSubview:self.bottomBorder];
}

- (void)setConstraints
{
    [self.tabNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.equalTo(self).offset(2);
        make.right.equalTo(self).offset(-2);
    }];
//    [self.bottomBorder mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.left.right.equalTo(self);
//        make.height.equalTo(@3);
//    }];
}

- (void)didSelect
{    
    if (self.tabDelegate) {
        [self.tabDelegate didSelectTab:self];
    }
}

- (void)setSelected:(BOOL)isSelected
{
    if (isSelected) {
        self.backgroundColor = [MPColorManager getNavigationBarColor];
//        self.bottomBorder.hidden = NO;
    } else {
        self.backgroundColor = [UIColor clearColor];
//        self.bottomBorder.hidden = YES;
    }
}

@end
