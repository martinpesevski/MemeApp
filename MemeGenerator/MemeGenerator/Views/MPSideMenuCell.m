//
//  MPSideMenuCell.m
//  Betting
//
//  Created by Martin Peshevski on 4/29/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import "MPSideMenuCell.h"
#import "Masonry.h"
#import "MPColorManager.h"
#import "MPFontManager.h"

@interface MPSideMenuCell ()

@property (nonatomic, strong) UIImageView *categoryImage;
@property (nonatomic ,strong) UILabel *categoryLabel;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UIView *separator;

@property (nonatomic, strong) MASConstraint *userConstraint;
@property (nonatomic, strong) MASConstraint *topConstraint;

@end

@implementation MPSideMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        [self setConstraints];
    }
    return self;
}

- (void)setupViews
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.userLabel = [[UILabel alloc] init];
    self.userLabel.text = @"user";
    self.userLabel.textColor = [MPColorManager getRedColor];
    self.userLabel.font = [MPFontManager getDescriptionLabelBoldFont];
    self.userLabel.hidden = YES;
    
    self.separator = [[UIView alloc] init];
    self.separator.backgroundColor = [MPColorManager getSeparatorColor];
    self.separator.hidden = YES;
    
    self.categoryImage = [[UIImageView alloc] init];
    self.categoryImage.tintColor = [MPColorManager getNavigationBarColor];

    self.categoryLabel = [[UILabel alloc] init];
    self.categoryLabel.textColor = [MPColorManager getRedColor];
    
    [self.contentView addSubview:self.separator];
    [self.contentView addSubview:self.userLabel];
    [self.contentView addSubview:self.categoryImage];
    [self.contentView addSubview:self.categoryLabel];
}

- (void)setConstraints
{
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        self.userConstraint = make.top.equalTo(self.separator.mas_bottom);
        make.left.equalTo(self.contentView).offset(15);
    }];
    [self.categoryImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        self.topConstraint = make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@30);
    }];
    [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.categoryImage.mas_right).offset(15);
        make.centerY.equalTo(self.categoryImage);
        make.right.equalTo(self.contentView).offset(-10);
    }];
}

- (void)setupWithTitle:(MPSideMenuCellType)cellType
{
    self.categoryLabel.text = [self getStringForType:cellType];
    [self.categoryImage setImage:[self getImageForType:cellType]];
}

- (void)showUserLabel
{
    self.separator.hidden = NO;
    
    self.userLabel.hidden = NO;
    self.userConstraint.offset(10);
    self.topConstraint.offset(15);
}

- (UIImage *)getImageForType:(MPSideMenuCellType)type
{
    UIImage *returnImage = nil;
    
    switch (type) {
        case MPSideMenuCellTypeYourMemes:
            returnImage = [UIImage imageNamed:@"trade-icon"];
            break;
        case MPSideMenuCellTypeNewest:
            returnImage = [UIImage imageNamed:@"leagues-icon"];
            break;
        case MPSideMenuCellTypePopular:
            returnImage = [UIImage imageNamed:@"mates-icon"];
            break;
        default:
            return nil;
            break;
    }
    
    
    if (returnImage) {
        returnImage = [returnImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    return returnImage;
}

- (NSString *)getStringForType:(MPSideMenuCellType)type
{
    switch (type) {
        case MPSideMenuCellTypeYourMemes:
            return @"Your memes";
            break;
        case MPSideMenuCellTypeNewest:
            return @"Newest";
            break;
        case MPSideMenuCellTypePopular:
            return @"Popular";
            break;
        case MPSideMenuCellTypeSignOut:
            return @"Logout";
            break;
        default:
            break;
    }
    
    return @"";
}

@end
