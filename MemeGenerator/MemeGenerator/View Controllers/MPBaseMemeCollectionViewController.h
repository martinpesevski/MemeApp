//
//  MPBaseMemeCollectionViewController.h
//  MemeGenerator
//
//  Created by Martin Peshevski on 4/4/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPBaseViewController.h"

@interface MPBaseMemeCollectionViewController : MPBaseViewController

@property (nonatomic, strong) UICollectionView *memesCollectionView;

@property (nonatomic, strong) NSArray *memesArray;

- (void)setupViews;
- (void)setConstraints;

@end
