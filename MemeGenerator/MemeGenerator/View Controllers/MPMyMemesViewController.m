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
#import "AppDelegate.h"
#import "Strings.h"
#import "MPRequestProvider.h"

@interface MPMyMemesViewController ()

@property (nonatomic, strong) NSArray *localMemesArray;

@end

@implementation MPMyMemesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = kMyMemesTitleString;
    
    [self tabbarSetup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self loadImages];
    [self loadUserMemes];
}

- (void)tabbarSetup
{
    BOOL isLoggedIn = [[MPAuthenticationManager sharedManager] isLoggedIn];
    NSArray *names = @[kBackString, isLoggedIn?kLogoutString:kLoginRegisterString];
    NSArray *images = @[[UIImage imageNamed:@"ic_left_white"],[UIImage new]];
    
    simpleBlock backBlock = ^{
        [self onBack];
    };
    
    simpleBlock loginBlock = ^{
        if (isLoggedIn) {
            [MPAlertManager showAlertMessage:kLogoutConfirmString withOKblock:^{
                [[MPAuthenticationManager sharedManager] signOut];
            }];
        } else {
            [self showLogin];
        }
    };
    
    NSArray *actionsArray = @[backBlock, loginBlock];
    
    [self setupTabbarWithNames:names images:images actions:actionsArray];
}

- (void)loadUserMemes
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MPRequestProvider sharedInstance] getUserMemesWithCompletion:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
        if (result && !error) {

            NSMutableArray *memesMutable = [[NSMutableArray alloc] init];
            NSArray *keysArray = [[result allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            for (int i=0; i<keysArray.count; i++) {
                NSDictionary *dict = result[keysArray[i]];
                MPMeme *meme = [[MPMeme alloc] initWithDict:dict];
                meme.memeID = keysArray[i];
                [memesMutable addObject:meme];
            }
            
            self.memesArray = memesMutable;
            
            [self.memesCollectionView reloadData];
        } else if (error) {
            [MPAlertManager showAlertMessage:error.localizedDescription withOKblock:nil hasCancelButton:NO];
        }
    }];
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
    [memeCell setupWithImageUrl:[NSURL URLWithString:meme.createdImageUrlString]];
    
    return memeCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MPMeme *meme = self.memesArray[indexPath.row];
    
    MPShareMemeViewController *shareMemeController = [[MPShareMemeViewController alloc] initWithMeme:meme];
    [self.navigationController pushViewController:shareMemeController animated:YES];
}

@end
