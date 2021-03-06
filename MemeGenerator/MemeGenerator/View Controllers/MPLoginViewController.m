//
//  MPLoginViewController.m
//  Betting
//
//  Created by Martin Peshevski on 5/5/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import "MPLoginViewController.h"
#import "MPTextField.h"
#import "MPColorManager.h"
#import "MPFontManager.h"
#import "Constants.h"
#import "Masonry.h"
#import "MPRequestProvider.h"
#import "MPAlertManager.h"
#import "MBProgressHUD.h"
#import "MPAuthenticationManager.h"
#import "AppDelegate.h"
#import "MPSignUpViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface MPLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) MPTextField *usernameTextView;
@property (nonatomic, strong) MPTextField *passwordTextView;

@property (nonatomic, strong) UILabel *noAccountLabel;
@property (nonatomic, strong) UILabel *registerAccountLabel;
@property (nonatomic, strong) UIView *registerPlaceholderView;

@property (nonatomic, strong) UIImage *facebookButtonImage;

@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *facebookLoginButton;

@property (nonatomic, strong) UIButton *forgotPasswordButton;

@property (nonatomic, strong) UIView *keyboardAvoidingContainerView;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic) BOOL shouldShowNavigationBar;

@end

@implementation MPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Login";
    self.shouldShowNavigationBar = YES;

    [self setupViews];
    [self setConstraints];
    [self tabbarSetup];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupViews
{
    self.usernameTextView = [[MPTextField alloc] initWithColor:[MPColorManager getLabelColorWhite]];
    self.usernameTextView.textColor = [MPColorManager getLabelColorWhite];
    self.usernameTextView.placeholder = @"Email";
    self.usernameTextView.delegate = self;
    self.usernameTextView.keyboardType = UIKeyboardTypeEmailAddress;
    self.usernameTextView.returnKeyType = UIReturnKeyNext;
    self.usernameTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;

    self.passwordTextView = [[MPTextField alloc] initWithColor:[MPColorManager getLabelColorWhite]];
    self.passwordTextView.textColor = [MPColorManager getLabelColorWhite];
    [self.passwordTextView setSecureTextEntry:YES];
    self.passwordTextView.placeholder = @"Password";
    self.passwordTextView.delegate = self;

    self.loginButton = [[UIButton alloc] init];
    self.loginButton.backgroundColor = [MPColorManager getNavigationBarColor];
    [self.loginButton setTitleColor:[MPColorManager getLabelColorWhite] forState:UIControlStateNormal];
    [self.loginButton setTitle:[@"Sign in" uppercaseString] forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(onLogin) forControlEvents:UIControlEventTouchUpInside];
    
    self.facebookButtonImage = [UIImage imageNamed:@"facebook-login-button"];
    
    self.facebookLoginButton = [[UIButton alloc] init];
    [self.facebookLoginButton addTarget:self action:@selector(onFacebookLoginTap) forControlEvents:UIControlEventTouchUpInside];
    [self.facebookLoginButton setBackgroundImage:self.facebookButtonImage forState:UIControlStateNormal];
    
    self.forgotPasswordButton = [[UIButton alloc] init];
    [self.forgotPasswordButton setTitle:@"Forgot password?" forState:UIControlStateNormal];
    [self.forgotPasswordButton setTitleColor:[MPColorManager getLabelColorWhite] forState:UIControlStateNormal];
    self.forgotPasswordButton.titleLabel.font = [MPFontManager getTitleLabelFont];
    [self.forgotPasswordButton addTarget:self action:@selector(onForgotPassword) forControlEvents:UIControlEventTouchUpInside];
    
    self.noAccountLabel = [[UILabel alloc] init];
    self.noAccountLabel.text = @"No account?";
    self.noAccountLabel.font = [MPFontManager getTitleLabelNormalFont];
    self.noAccountLabel.textColor = [MPColorManager getLabelColorWhite];
    self.noAccountLabel.textAlignment = NSTextAlignmentCenter;
    
    self.registerAccountLabel = [[UILabel alloc] init];
    self.registerAccountLabel.font = [MPFontManager getTitleLabelFont];
    self.registerAccountLabel.textColor = [MPColorManager getLabelColorWhite];
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    self.registerAccountLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Register free account"
                                                             attributes:underlineAttribute];
    self.registerAccountLabel.textAlignment = NSTextAlignmentCenter;
    
    self.registerPlaceholderView = [[UIView alloc] init];
    self.registerPlaceholderView.userInteractionEnabled = YES;
    [self.registerPlaceholderView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRegisterScreen)]];

    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicator.hidden = YES;
    
    self.keyboardAvoidingContainerView = [[UIView alloc] init];
    
    [self.keyboardAvoidingContainerView addSubview:self.usernameTextView];
    [self.keyboardAvoidingContainerView addSubview:self.passwordTextView];
    [self.keyboardAvoidingContainerView addSubview:self.loginButton];
    [self.keyboardAvoidingContainerView addSubview:self.facebookLoginButton];
    [self.keyboardAvoidingContainerView addSubview:self.forgotPasswordButton];
    [self.keyboardAvoidingContainerView addSubview:self.activityIndicator];
    [self.registerPlaceholderView addSubview:self.noAccountLabel];
    [self.registerPlaceholderView addSubview:self.registerAccountLabel];
    [self.view addSubview:self.keyboardAvoidingContainerView];
    [self.view addSubview:self.registerPlaceholderView];
}

- (void)setConstraints
{
    [self.keyboardAvoidingContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view).offset(kLeftRightPadding);
        make.right.equalTo(self.view).offset(-kLeftRightPadding);
    }];
    [self.registerPlaceholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.tabBar.mas_top).offset(-50);
    }];
    [self.usernameTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.keyboardAvoidingContainerView).offset(10);
        make.left.right.equalTo(self.keyboardAvoidingContainerView);
        make.height.equalTo(@(kFloatingTextFieldHeight));
    }];
    [self.passwordTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameTextView.mas_bottom);
        make.left.right.equalTo(self.keyboardAvoidingContainerView);
        make.height.equalTo(@(kFloatingTextFieldHeight));
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.forgotPasswordButton.mas_bottom).offset(20);
        make.height.equalTo(@(kLoginButtonHeight));
        make.left.equalTo(self.keyboardAvoidingContainerView);
        make.right.equalTo(self.keyboardAvoidingContainerView);
    }];
    [self.facebookLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(20);
        make.height.equalTo(@(kLoginButtonHeight));
        float ratio = kLoginButtonHeight / self.facebookButtonImage.size.height;
        make.width.equalTo(@(self.facebookButtonImage.size.width * ratio));
        make.centerX.equalTo(self.keyboardAvoidingContainerView);
        make.bottom.equalTo(self.keyboardAvoidingContainerView);
    }];
    [self.forgotPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextView.mas_bottom).offset(10);
        make.left.right.equalTo(self.keyboardAvoidingContainerView);
        make.height.equalTo(@(kButtonHeight));
    }];
    [self.noAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.registerPlaceholderView);
    }];
    [self.registerAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.registerPlaceholderView);
        make.top.equalTo(self.noAccountLabel.mas_bottom).offset(20);
    }];
    [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.loginButton);
    }];
}

- (void)tabbarSetup
{
    NSArray *names = @[@"back"];
    NSArray *images = @[[UIImage imageNamed:@"ic_left_white"]];
    
    simpleBlock backBlock = ^{
        [self onBack];
    };
    
    NSArray *actionsArray = @[backBlock];
    
    [self setupTabbarWithNames:names images:images actions:actionsArray];
}

- (void)onLogin
{
    [self.view endEditing:YES];

    if (![self validation]) {
        [MPAlertManager showAlertMessage:@"Please enter valid credentials"];
        return;
    }
    
    NSString *usernameString = [NSString stringWithFormat:@"%@", [self.usernameTextView.text lowercaseString]];
    NSString *passwordString = [NSString stringWithFormat:@"%@", self.passwordTextView.text];
    
    self.passwordTextView.text = @"";

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MPAuthenticationManager sharedManager] loginWithUsername:usernameString
                                                      password:passwordString
                                                    completion:^(BOOL completed)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
               
        if (completed) {
            [self completeLogin];
        } else {
            [self showLoginError];
        }
    }];
}

- (BOOL)validation
{
    if (self.usernameTextView.text.length>0 && self.passwordTextView.text.length>0) {
        return YES;
    }
    return NO;
}

- (void)onForgotPassword{
//    MPForgotPasswordViewController *forgotPasswordController = [[MPForgotPasswordViewController alloc] init];
//    [self.navigationController pushViewController:forgotPasswordController animated:YES];
}

- (void)showRegisterScreen
{
    MPSignUpViewController *signupController = [[MPSignUpViewController alloc] init];
    [self.navigationController pushViewController:signupController animated:YES];
}

- (void)completeLogin
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate setMainController];
}

- (void)showLoginError
{
    [MPAlertManager showAlertMessage:@"Sign in failed. Try again later" withOKblock:nil hasCancelButton:NO];
}

#pragma mark - text field methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.usernameTextView]) {
        [self.usernameTextView resignFirstResponder];
        [self.passwordTextView becomeFirstResponder];
    } else {
        [self.view endEditing:YES];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{   
    return YES;
}

#pragma mark - facebook login

- (void)onFacebookLoginTap
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Facebook login: Process error");
         } else if (result.isCancelled) {
             NSLog(@"Facebook login Cancelled");
         } else {
             NSString *tokenString = result.token.tokenString;
             
             [self loginWithFacebookToken:tokenString username:nil];
         }
     }];
}

- (void)checkIfUsernameAvailableAndLoginWithToken:(NSString *)token username:(NSString *)username
{
    [self checkIfUsernameAvailable:username completion:^(BOOL completed) {
        if (completed) {
            [self loginWithFacebookToken:token username:username];
        } else {
            [self showUsernamePromptForToken:token];
        }
    }];
}

- (void)checkIfUsernameAvailable:(NSString *)username completion:(successCompletion)completion
{
    [[MPRequestProvider sharedInstance] checkUsernameAvailable:username completion:^(BOOL completed) {
        if (completion) {
            completion(completed);
        }
    }];
}

- (void)loginWithFacebookToken:(NSString *)token username:(NSString *)username
{
    [[MPAuthenticationManager sharedManager] loginWithFbToken:token username:username completion:^(id result, NSError *error) {
        if (error) {
            if (error.code == 100) {
                if ([error.domain containsString:@"No username provided"]) {
                    [self showUsernamePromptForToken:token];
                } else {
                    [MPAlertManager showAlertMessage:error.domain withOKblock:nil hasCancelButton:NO];
                }
            } else {
                [MPAlertManager showAlertMessage:error.localizedDescription withOKblock:nil hasCancelButton:NO];
            }
        } else if (result) {
            [self completeLogin];
        }
    }];
}

- (void)showUsernamePromptForToken:(NSString *)token
{
    [MPAlertManager showTextFieldAlertMessage:@"Which username would you like to use in the app?" withOKblock:^(NSString *username) {
        [self checkIfUsernameAvailableAndLoginWithToken:token username:username];
    } hasCancelButton:YES];
}

@end
