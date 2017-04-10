//
//  MPMemeCell.m
//  MemeGenerator
//
//  Created by Martin Peshevski on 3/22/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import "MPMemeCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface MPMemeCell ()

@property (nonatomic, strong) UIImageView *memeImageView;

@end

@implementation MPMemeCell

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
    self.memeImageView = [[UIImageView alloc] init];
    self.memeImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.memeImageView.clipsToBounds = YES;
    self.memeImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.memeImageView.layer.borderWidth = 1;
    
    [self addSubview:self.memeImageView];
}

- (void)setConstraints
{
    [self.memeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setupWithImageUrl:(NSURL *)imageUrl
{
    [self.memeImageView sd_setImageWithURL:imageUrl];
}

- (void)setupWithImage:(UIImage *)image
{
    [self.memeImageView setImage:image];
}

@end
