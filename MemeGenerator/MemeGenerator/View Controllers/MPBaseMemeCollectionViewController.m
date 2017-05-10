//
//  MPBaseMemeCollectionViewController.m
//  MemeGenerator
//
//  Created by Martin Peshevski on 4/4/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import "MPBaseMemeCollectionViewController.h"
#import "MPMemeCell.h"
#import "Masonry.h"
#import "Constants.h"

@interface MPBaseMemeCollectionViewController ()

@end

@implementation MPBaseMemeCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupViews];
    [self setConstraints];
}

- (void)setupViews
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    self.memesCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    self.memesCollectionView.delegate = self;
    self.memesCollectionView.dataSource = self;
    [self.memesCollectionView registerClass:[MPMemeCell class] forCellWithReuseIdentifier:@"memeCellIdentifier"];
    self.memesCollectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.memesCollectionView];
}

- (void)setConstraints
{
    [self.memesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.tabBar.mas_top);
        make.top.equalTo(self.view);
    }];
}

- (void)loadImageFromUrl:(NSString *)imageUrl completion:(imageCompletion)completion
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        completion(image);
    }];
}

#pragma mark - uicollectionview methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //will be overrided in children
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //will be overriden in children
    return [UICollectionViewCell new];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float imageWidthHeight = MIN(kScreenWidth, kScreenHeight)/2 - 2 * kMemePadding + kMemePadding/2;
    return CGSizeMake(imageWidthHeight, imageWidthHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kMemePadding, kMemePadding, kMemePadding, kMemePadding);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kMemePadding;
}

@end
