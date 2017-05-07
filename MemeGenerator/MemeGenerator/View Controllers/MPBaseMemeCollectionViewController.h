//
//  MPBaseMemeCollectionViewController.h
//  MemeGenerator
//
//  Created by Martin Peshevski on 4/4/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPBaseViewController.h"
#import "MPRequestProvider.h"
#import "SDWebImageManager.h"

@interface MPBaseMemeCollectionViewController : MPBaseViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *memesCollectionView;

@property (nonatomic, strong) NSArray *memesArray;

- (void)setupViews;
- (void)setConstraints;
- (void)loadImageFromUrl:(NSString *)imageUrl completion:(imageCompletion)completion;

@end
