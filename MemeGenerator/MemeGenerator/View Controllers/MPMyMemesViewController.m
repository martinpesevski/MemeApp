//
//  MPMyMemesViewController.m
//  MemeGenerator
//
//  Created by Martin Peshevski on 4/4/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import "MPMyMemesViewController.h"
#import "MPMeme.h"
#import "MPMemeCell.h"
#import "MPShareMemeViewController.h"

@interface MPMyMemesViewController ()

@end

@implementation MPMyMemesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Your memes";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadImages];
}

- (void)loadImages {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths.firstObject;
    NSString *imagesPath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"memeGenerator"];
    
    NSError * error;
    NSArray *memeImageNamesAray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:imagesPath error:&error];
    
    NSMutableArray *memesMutable = [[NSMutableArray alloc] init];
    for (NSString *imageName in memeImageNamesAray) {
        NSString *imageNamePathExtension = [NSString stringWithFormat:@".%@", [imageName pathExtension]];
        NSString *imageNameWithoutExtension = [imageName stringByReplacingOccurrencesOfString:imageNamePathExtension withString:@""];
        NSString *imageNameFormatted = [imageNameWithoutExtension stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        
        NSString *imagePath = [NSString stringWithFormat:@"%@/%@/%@",documentsDirectory,@"memeGenerator", imageName];
        UIImage *memeImage = [UIImage imageWithContentsOfFile:imagePath];
        
        MPMeme *meme = [[MPMeme alloc] initWithImage:memeImage name:imageNameFormatted];
        [memesMutable addObject:meme];
    }
    self.memesArray = memesMutable;

    [self.memesCollectionView reloadData];
}

#pragma mark - uicollectionview methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.memesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MPMemeCell *memeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"memeCellIdentifier" forIndexPath:indexPath];
    
    MPMeme *meme;
    
    meme = self.memesArray[indexPath.row];
    [memeCell setupWithImage:meme.image];
    
    return memeCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MPMeme *meme = self.memesArray[indexPath.row];
    
    MPShareMemeViewController *shareMemeController = [[MPShareMemeViewController alloc] initWithImage:meme.image];
    [self.navigationController pushViewController:shareMemeController animated:YES];
}

@end
