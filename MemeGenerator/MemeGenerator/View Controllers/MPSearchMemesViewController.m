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
#import "MPColorManager.h"
#import "MPMeme.h"
#import "MPRequestProvider.h"
#import "MBProgressHUD.h"
#import "SDWebImageManager.h"

@interface MPSearchMemesViewController () <UISearchBarDelegate>

@property (nonatomic, strong) NSArray *searchArray;

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation MPSearchMemesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadMemes];
}

- (void)setupViews
{
    [super setupViews];
    
    self.title = @"Select a meme";
    
//    NSString *dirPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"memes"];
//    NSError * error;
//    NSArray *memeImageNamesAray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:&error];
//    
//    NSMutableArray *memesMutable = [[NSMutableArray alloc] init];
//    for (NSString *imageName in memeImageNamesAray) {
//        NSString *imageNamePathExtension = [NSString stringWithFormat:@".%@", [imageName pathExtension]];
//        NSString *imageNameWithoutExtension = [imageName stringByReplacingOccurrencesOfString:imageNamePathExtension withString:@""];
//        NSString *imageNameFormatted = [imageNameWithoutExtension stringByReplacingOccurrencesOfString:@"_" withString:@" "];
//        
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:nil inDirectory:@"memes"];
//        UIImage *memeImage = [UIImage imageWithContentsOfFile:imagePath];
//        
//        MPMeme *meme = [[MPMeme alloc] initWithImage:memeImage name:imageNameFormatted];
//        
//        [memesMutable addObject:meme];
//    }
//    self.memesArray = memesMutable;

    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.barTintColor = [MPColorManager colorFromHexString:@"#838BFF"];
    self.searchBar.delegate = self;
    
    [self.view addSubview:self.searchBar];
}

- (void)setConstraints
{
    [super setConstraints];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    [self.memesCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.searchBar.mas_bottom);
    }];
}

#pragma mark - api calls

- (void)loadMemes
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MPRequestProvider sharedInstance] getMemesWithCompletion:^(id result, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSMutableArray *memesMutable = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in result) {
            MPMeme *meme = [[MPMeme alloc] initWithDict:dict];
            [memesMutable addObject:meme];
        }
        
        self.memesArray = memesMutable;
        
        [self.memesCollectionView reloadData];
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
    if (self.searchBar.text.length>0) {
        return self.searchArray.count;
    }
    
    return self.memesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MPMemeCell *memeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"memeCellIdentifier" forIndexPath:indexPath];
    
    MPMeme *meme;

    if (self.searchBar.text.length>0) {
        meme = self.searchArray[indexPath.row];
    } else {
        meme = self.memesArray[indexPath.row];
    }
    [memeCell setupWithImageUrl:[NSURL URLWithString: meme.imageUrlString]];
    
    return memeCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MPMeme *meme;
    
    if (self.searchBar.text.length>0) {
        meme = self.searchArray[indexPath.row];
    } else {
        meme = self.memesArray[indexPath.row];
    }
    
    [self loadImageFromUrl:meme.imageUrlString completion:^(UIImage *image) {
        MPMemeMakerViewController *memeMakerController = [[MPMemeMakerViewController alloc] initWithImage:image];
        [self.navigationController pushViewController:memeMakerController animated:YES];
    }];
}

#pragma mark - search bar delegate methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSMutableArray *searchArrayMutable = [[NSMutableArray alloc] init];
    for (MPMeme *meme in self.memesArray) {
        if ([[meme.name lowercaseString] containsString:[searchText lowercaseString]]) {
            [searchArrayMutable addObject:meme];
        }
    }
    self.searchArray = searchArrayMutable;
    
    [self.memesCollectionView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.memesCollectionView reloadData];
}

@end
