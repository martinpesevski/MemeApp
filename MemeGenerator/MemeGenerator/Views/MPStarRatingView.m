//
//  MPStarRatingView.m
//  AllHotels
//
//  Created by Martin Peshevski on 3/4/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import "MPStarRatingView.h"
#import "Masonry.h"

#define kNumberOfStars 5

@interface MPStarRatingView ()

@property (nonatomic, strong) NSArray *starsArray;
@property (nonatomic, strong) UIView *starsContainer;

@end

@implementation MPStarRatingView

- (instancetype)init
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
    self.starsContainer = [[UIView alloc] init];
    
    NSMutableArray *starsMutable = [[NSMutableArray alloc] init];
    for (int i=0; i<kNumberOfStars; i++) {
        UIImage *starImage = [[UIImage imageNamed:@"ic_star_border"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        UIImageView *starView = [[UIImageView alloc] initWithImage:starImage];
        
        [starsMutable addObject:starView];
        [self.starsContainer addSubview:starView];
    }
    
    self.starsArray = starsMutable;
    
    [self addSubview:self.starsContainer];
}

- (void)setConstraints
{
    [self.starsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    for (int i=0; i<self.starsArray.count; i++) {
        UIImageView *starView = self.starsArray[i];
        [starView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.starsContainer).offset(i * (starView.frame.size.width + 5));
            make.top.bottom.equalTo(self.starsContainer);
        }];
        
        if (i == kNumberOfStars-1) {
            [starView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.starsContainer);
            }];
        }
    }
}

- (void)setupWithNumberOfStars:(int)numberOfStars
{
    for (int i=0; i<5; i++) {
        UIImageView *starView = self.starsArray[i];

        if (i>numberOfStars) {
            starView.hidden = YES;
        } else {
            starView.hidden = NO;
        }
    }
}

- (void)setStarColor:(UIColor *)starColor
{
    for (UIImageView *starView in self.starsArray) {
        starView.tintColor = starColor;
    }
}

@end
