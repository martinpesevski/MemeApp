//
//  MPSidewaysButton.m
//  AllHotels
//
//  Created by Martin Peshevski on 3/4/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import "MPSidewaysButton.h"
#import "MPFontManager.h"
#import "Masonry.h"
#import "Constants.h"

@interface MPSidewaysButton ()

@property (nonatomic, strong) UILabel *titleRotatedLabel;
@property (nonatomic, strong) NSString *titleString;

@end

@implementation MPSidewaysButton

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        [self setupViews];
        [self setConstraints];
    }
    return self;
}

- (void)setupViews
{
    self.clipsToBounds = NO;
    
    self.titleRotatedLabel = [[UILabel alloc] init];
    self.titleRotatedLabel.textColor = [UIColor blackColor];
    self.titleRotatedLabel.text = self.titleString;
    self.titleRotatedLabel.font = [MPFontManager getTitleLabelFont];
//    self.titleRotatedLabel.transform = CGAffineTransformRotate(self.titleRotatedLabel.transform, M_PI_2);
    self.titleRotatedLabel.center = self.center;
    
    [self addSubview:self.titleRotatedLabel];
}

- (void)setConstraints
{
//    [self.titleRotatedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self);
//        make.width.equalTo(@(kScreenHeight));
//    }];
}

@end
