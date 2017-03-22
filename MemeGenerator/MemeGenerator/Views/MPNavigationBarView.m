//
//  MPNavigationBarView.m
//  Betting
//
//  Created by Martin Peshevski on 7/2/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import "MPNavigationBarView.h"
#import "Masonry.h"
#import "MPFontManager.h"
#import "MPColorManager.h"

@interface MPNavigationBarView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) UIView *containerView;

@end

@implementation MPNavigationBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self setConstraints];
    }
    return self;
}

- (void)setupViews
{
    self.imageView = [[UIImageView alloc] init];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [MPFontManager getTitleLabelFont];
    
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.textColor = [UIColor whiteColor];
    self.descriptionLabel.font = [MPFontManager getDescriptionLabelNormalFont];
    
    self.containerView = [[UIView alloc] init];
    
    [self.containerView addSubview:self.imageView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.descriptionLabel];

    [self addSubview:self.containerView];
}

- (void)setConstraints
{
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.containerView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(5);
        make.right.equalTo(self.containerView);
        make.top.equalTo(self.containerView);
    }];
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(5);
        make.right.equalTo(self.containerView);
        make.bottom.equalTo(self.containerView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
}

- (void)setupWithTitle:(NSString *)title image:(UIImage *)image
{
    [self setupWithTitle:title image:image description:@""];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(40);
        make.right.equalTo(self.containerView);
        make.centerY.equalTo(self.containerView);
    }];
}

- (void)setupWithTitle:(NSString *)title image:(UIImage *)image description:(NSString *)description
{
    [self.imageView setImage:image];
    self.titleLabel.text = title;
    self.descriptionLabel.text = description;
}

@end
