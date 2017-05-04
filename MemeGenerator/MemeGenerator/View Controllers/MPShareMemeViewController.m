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
#import "MPFontManager.h"

#define kMemeImageHeightWidth 300

@interface MPShareMemeViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *memeImage;
@property (nonatomic, strong) MPMeme *meme;
@property (nonatomic, strong) UIImageView *memeImageView;
@property (nonatomic, strong) UIButton *favoriteButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *registerPromptButton;
@property (nonatomic, strong) UILabel *privacyLabel;
@property (nonatomic, strong) UISwitch *memePrivacySwitch;

@end

@implementation MPShareMemeViewController

- (instancetype)initWithMeme:(MPMeme *)meme
{
    self = [super init];
    if (self) {
        self.meme = meme;
        self.memeImage = meme.image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self setConstraints];
    [self tabbarSetup];
    
    if ([[MPAuthenticationManager sharedManager] isLoggedIn]) {
        [self syncMeme];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoggedOut) name:USER_LOGGED_OUT_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoggedIn) name:USER_LOGGED_IN_NOTIFICATION object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupViews
{
    self.title = kShareTitleString;
    
    self.scrollView = [[UIScrollView alloc] init];
    
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
    
    self.registerPromptButton = [[UIButton alloc] init];
    [self.registerPromptButton setTitleColor:[MPColorManager getLabelColorWhite] forState:UIControlStateNormal];
    self.registerPromptButton.titleLabel.font = [MPFontManager getTitleLabelFont];
    [self.registerPromptButton setTitle:kRegisterForSharePromptString forState:UIControlStateNormal];
    [self.registerPromptButton addTarget:self action:@selector(showLogin) forControlEvents:UIControlEventTouchUpInside];
    
    self.privacyLabel = [[UILabel alloc] init];
    self.privacyLabel.text = @"Visible on makeameme.org?";
    self.privacyLabel.font = [MPFontManager getTitleLabelFont];
    self.privacyLabel.textColor = [MPColorManager getLabelColorWhite];
    
    self.memePrivacySwitch = [[UISwitch alloc] init];
    [self.memePrivacySwitch setOn:self.meme.privacy == MPMemePrivacyPublic];
    [self.memePrivacySwitch addTarget:self action:@selector(onChangedMemePrivacy:) forControlEvents:UIControlEventValueChanged];
    [self.memePrivacySwitch setOnTintColor:[MPColorManager getNavigationBarColor]];
    
    if ([[MPAuthenticationManager sharedManager] isLoggedIn]) {
        self.registerPromptButton.hidden = YES;
        self.memePrivacySwitch.hidden = NO;
    } else {
        self.memePrivacySwitch.hidden = YES;
        self.registerPromptButton.hidden = NO;
    }
    
    [self.scrollView addSubview:self.memeImageView];
    [self.scrollView addSubview:self.registerPromptButton];
    [self.scrollView addSubview:self.privacyLabel];
    [self.scrollView addSubview:self.memePrivacySwitch];
    [self.scrollView addSubview:self.favoriteButton];
    [self.scrollView addSubview:self.shareButton];
    [self.view addSubview:self.scrollView];
}

- (void)setConstraints
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.tabBar.mas_top);
    }];
    [self.memeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.scrollView).offset(kLeftRightPadding);
        make.width.height.equalTo(@(kMemeImageHeightWidth));
    }];
    [self.registerPromptButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kLeftRightPadding);
        make.right.equalTo(self.view).offset(-kLeftRightPadding);
        make.left.equalTo(self.scrollView).offset(kLeftRightPadding);
        make.right.equalTo(self.scrollView).offset(-kLeftRightPadding);
        make.top.equalTo(self.memeImageView.mas_bottom).offset(20);
    }];
    [self.privacyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.centerY.equalTo(self.memePrivacySwitch);
    }];
    [self.memePrivacySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.memeImageView.mas_bottom).offset(20);
    }];
    [self.favoriteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.registerPromptButton.mas_bottom).offset(20);
        make.height.equalTo(@(kLoginButtonHeight));
        make.centerX.equalTo(self.view);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.favoriteButton.mas_bottom).offset(20);
        make.height.equalTo(@(kLoginButtonHeight));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.scrollView);
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
    
}

- (void)syncMeme
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MPRequestProvider sharedInstance] postMeme:self.meme completion:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
        
        if (result && !error) {
            self.meme.memeID = result[@"id"];
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

- (void)onLoggedIn
{
    self.registerPromptButton.hidden = YES;
    self.memePrivacySwitch.hidden = NO;
}

- (void)onLoggedOut
{
    self.registerPromptButton.hidden = NO;
    self.memePrivacySwitch.hidden = YES;
}

- (void)onChangedMemePrivacy:(UISwitch *)sender
{
    self.meme.privacy = sender.isOn?MPMemePrivacyPublic:MPMemePrivacyPrivate;
    
    [[MPRequestProvider sharedInstance] updatePrivacyForMeme:self.meme completion:^(id result, NSError *error) {
        
    }];
}

@end
