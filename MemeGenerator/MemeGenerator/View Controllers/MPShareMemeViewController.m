//
//  MPShareMemeViewController.m
//  MemeGenerator
//
//  Created by Martin Peshevski on 3/28/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import "MPShareMemeViewController.h"
#import "Masonry.h"
#import "MPColorManager.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "Strings.h"
#import "MPRequestProvider.h"

#define kMemeImageHeightWidth 300

@interface MPShareMemeViewController ()

@property (nonatomic, strong) UIImage *memeImage;
@property (nonatomic, strong) UIImageView *memeImageView;
@property (nonatomic, strong) UIButton *favoriteButton;
@property (nonatomic, strong) UIButton *shareButton;

@end

@implementation MPShareMemeViewController

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.memeImage = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self setConstraints];
    [self tabbarSetup];
}

- (void)setupViews
{
    self.title = kShareTitleString;
    
    self.memeImageView = [[UIImageView alloc] initWithImage:self.memeImage];
    self.memeImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.memeImageView.clipsToBounds = YES;
    self.memeImageView.layer.borderWidth = 1;
    self.memeImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.memeImageView.backgroundColor = [UIColor blackColor];
    
    self.favoriteButton = [[UIButton alloc] init];
    [self.favoriteButton setTitle:kFavouriteString forState:UIControlStateNormal];
    [self.favoriteButton setTitleColor:[MPColorManager getLabelColorWhite] forState:UIControlStateNormal];
    [self.favoriteButton addTarget:self action:@selector(onFavorite) forControlEvents:UIControlEventTouchUpInside];
    
    self.shareButton = [[UIButton alloc] init];
    [self.shareButton setTitle:kShareString forState:UIControlStateNormal];
    [self.shareButton setTitleColor:[MPColorManager getLabelColorWhite] forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(onShare) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.memeImageView];
    [self.view addSubview:self.favoriteButton];
    [self.view addSubview:self.shareButton];
}

- (void)setConstraints
{
    [self.memeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(kLeftRightPadding);
        make.width.height.equalTo(@(kMemeImageHeightWidth));
    }];
    [self.favoriteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.memeImageView.mas_bottom).offset(20);
        make.height.equalTo(@(kLoginButtonHeight));
        make.centerX.equalTo(self.view);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.favoriteButton.mas_bottom).offset(20);
        make.height.equalTo(@(kLoginButtonHeight));
        make.centerX.equalTo(self.view);
    }];
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

#pragma mark - button actions

- (void)onFavorite
{
    MPMeme *meme = [[MPMeme alloc] initWithImage:self.memeImage name:@"martin test"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MPRequestProvider sharedInstance] postMeme:meme completion:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
        
        if (result && !error) {
            [MPAlertManager showAlertMessage:kSuccessPostingMemeString withOKblock:nil hasCancelButton:NO];
        } else if (error) {
            [MPAlertManager showAlertMessage:error.localizedDescription withOKblock:nil hasCancelButton:NO];
        }
    }];
}

- (void)onShare
{
    NSMutableArray *sharingItems = [NSMutableArray new];
//    [sharingItems addObject:kShareMessageString];
    [sharingItems addObject:self.memeImage];
    //    [sharingItems addObject:url];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

@end
