//
//  MPSearchMemesViewController.m
//  MemeGenerator
//
//  Created by Martin Peshevski on 3/22/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import "MPSearchMemesViewController.h"
#import "Masonry.h"
#import "MPMemeCell.h"
#import "Constants.h"
#import "MPMemeMakerViewController.h"

@interface MPSearchMemesViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *memesCollectionView;

@property (nonatomic, strong) NSArray *memesArray;

@end

@implementation MPSearchMemesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupViews];
    [self setConstraints];
}

- (void)setupViews
{
    NSMutableArray *memesMutable = [[NSMutableArray alloc] init];
    for (int i=1; i<11; i++) {
        [memesMutable addObject:[UIImage imageNamed:[NSString stringWithFormat:@"meme%d", i]]];
    }
    self.memesArray = memesMutable;
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    self.memesCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    self.memesCollectionView.delegate = self;
    self.memesCollectionView.dataSource = self;
    [self.memesCollectionView registerClass:[MPMemeCell class] forCellWithReuseIdentifier:@"memeCellIdentifier"];
    self.memesCollectionView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.memesCollectionView];
}

- (void)setConstraints
{
    [self.memesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - uicollectionview methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.memesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MPMemeCell *memeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"memeCellIdentifier" forIndexPath:indexPath];
    
    [memeCell setupWithImage:self.memesArray[indexPath.row]];
    
    return memeCell;
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MPMemeMakerViewController *memeMakerController = [[MPMemeMakerViewController alloc] initWithImage:self.memesArray[indexPath.row]];
    [self.navigationController pushViewController:memeMakerController animated:YES];
}

@end
