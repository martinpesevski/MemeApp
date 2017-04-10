//
//  MPDashboardCell.m
//  MemeGenerator
//
//  Created by Martin Peshevski on 3/22/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import "MPDashboardCell.h"
#import "Masonry.h"
#import "Constants.h"
#import "MPFontManager.h"

@interface MPDashboardCell ()

@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *cellLabel;

@end

@implementation MPDashboardCell

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    self.cellImageView = [[UIImageView alloc] init];
    self.cellImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.cellLabel = [[UILabel alloc] init];
    self.cellLabel.font = [MPFontManager getLargeFont];
    self.cellLabel.numberOfLines = 0;
    self.cellLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self addSubview:self.cellImageView];
    [self addSubview:self.cellLabel];
}

- (void)setConstraints
{
    [self.cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(40);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@100);
    }];
    [self.cellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cellImageView.mas_right).offset(40);
        make.centerY.equalTo(self.cellImageView);
        make.right.equalTo(self).offset(-40);
    }];
}

- (void)setupWithText:(NSString *)text image:(UIImage *)image
{
    self.cellImageView.image = image;
    self.cellLabel.text = text;
}

@end
