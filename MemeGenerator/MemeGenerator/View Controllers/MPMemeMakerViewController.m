//
//  MPMemeMakerViewController.m
//  MemeGenerator
//
//  Created by Martin Peshevski on 3/22/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import "MPMemeMakerViewController.h"
#import "Masonry.h"

@interface MPMemeMakerViewController ()

@property (nonatomic, strong) UIImage *image;

@end

@implementation MPMemeMakerViewController

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupViews];
    [self setConstraints];
}

- (void)setupViews
{
    
}

- (void)setConstraints
{
    
}

@end
