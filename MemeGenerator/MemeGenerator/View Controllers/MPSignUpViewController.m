//
//  MPSignUpViewController.m
//  Betting
//
//  Created by Martin Peshevski on 5/16/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import "MPSignUpViewController.h"
#import "MPTextField.h"
#import "Constants.h"
#import "MPColorManager.h"
#import "MPFontManager.h"
#import "Masonry.h"
#import "Strings.h"
#import "MPMyMemesViewController.h"

@interface MPSignUpViewController () <UITextFieldDelegate>

@property (nonatomic, strong) MPTextField *emailField;
@property (nonatomic, strong) MPTextField *usernameField;
@property (nonatomic, strong) MPTextField *passwordField;
@property (nonatomic, strong) MPTextField *confirmPasswordField;

@property (nonatomic, strong) MASConstraint *emailFieldTopConstraint;

@property (nonatomic, strong) UIScrollView *containerView;

@property (nonatomic, strong) UIButton *signUpButton;

@end

@implementation MPSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Register";

    [self setupViews];
    [self setConstraints];
    [self tabbarSetup];
}

- (void)setupViews
{   
    self.emailField = [[MPTextField alloc] initWithColor:[MPColorManager getLabelColorWhite]];
    self.emailField.textColor = [MPColorManager getLabelColorWhite];
    self.emailField.placeholder = @"Email";
    self.emailField.delegate = self;
    self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailField.returnKeyType = UIReturnKeyNext;
    self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;

    self.usernameField = [[MPTextField alloc] initWithColor:[MPColorManager getLabelColorWhite]];
    self.usernameField.textColor = [MPColorManager getLabelColorWhite];
    self.usernameField.placeholder = @"Username";
    self.usernameField.delegate = self;
    self.usernameField.returnKeyType = UIReturnKeyNext;
    self.usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;

    self.passwordField = [[MPTextField alloc] initWithColor:[MPColorManager getLabelColorWhite]];
    self.passwordField.secureTextEntry = YES;
    self.passwordField.textColor = [MPColorManager getLabelColorWhite];
    self.passwordField.placeholder = @"Password";
    self.passwordField.delegate = self;
    self.passwordField.returnKeyType = UIReturnKeyNext;

    self.confirmPasswordField = [[MPTextField alloc] initWithColor:[MPColorManager getLabelColorWhite]];
    self.confirmPasswordField.secureTextEntry = YES;
    self.confirmPasswordField.textColor = [MPColorManager getLabelColorWhite];
    self.confirmPasswordField.placeholder = @"Confirm password";
    self.confirmPasswordField.delegate = self;

    self.signUpButton = [[UIButton alloc] init];
    self.signUpButton.backgroundColor = [MPColorManager getNavigationBarColor];
    [self.signUpButton setTitle:@"Register" forState:UIControlStateNormal];
    [self.signUpButton setTitleColor:[MPColorManager getLabelColorWhite] forState:UIControlStateNormal];
    [self.signUpButton addTarget:self action:@selector(onSignup) forControlEvents:UIControlEventTouchUpInside];

    self.containerView = [[UIScrollView alloc] init];
    
    [self.containerView addSubview:self.emailField];
    [self.containerView addSubview:self.usernameField];
    [self.containerView addSubview:self.passwordField];
    [self.containerView addSubview:self.confirmPasswordField];
    [self.containerView addSubview:self.signUpButton];

    [self.view addSubview:self.containerView];
}

- (void)setConstraints
{
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    [self.signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.containerView).offset(-20);
        make.left.equalTo(self.containerView).offset(kLeftRightPadding);
        make.right.equalTo(self.containerView).offset(-kLeftRightPadding);
        make.left.equalTo(self.view).offset(kLeftRightPadding);
        make.right.equalTo(self.view).offset(-kLeftRightPadding);
        make.height.equalTo(@(kLoginButtonHeight));
    }];
    [self.confirmPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.signUpButton.mas_top).offset(-20);
        make.height.equalTo(@(kFloatingTextFieldHeight));
        make.left.equalTo(self.containerView).offset(kLeftRightPadding);
        make.right.equalTo(self.containerView).offset(-kLeftRightPadding);
    }];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.confirmPasswordField.mas_top);
        make.left.equalTo(self.containerView).offset(kLeftRightPadding);
        make.right.equalTo(self.containerView).offset(-kLeftRightPadding);
        make.height.equalTo(@(kFloatingTextFieldHeight));
    }];
    [self.usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.passwordField.mas_top);
        make.left.equalTo(self.containerView).offset(kLeftRightPadding);
        make.right.equalTo(self.containerView).offset(-kLeftRightPadding);
        make.height.equalTo(@(kFloatingTextFieldHeight));
    }];
    [self.emailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.usernameField.mas_top);
        make.left.equalTo(self.containerView).offset(kLeftRightPadding);
        make.right.equalTo(self.containerView).offset(-kLeftRightPadding);
        make.height.equalTo(@(kFloatingTextFieldHeight));
        self.emailFieldTopConstraint = make.top.equalTo(self.containerView).offset(kLeftRightPadding);
    }];
}

- (void)tabbarSetup
{
    NSArray *names = @[@"back", kMyMemesString];
    NSArray *images = @[[UIImage imageNamed:@"ic_left_white"], [UIImage new]];
    
    simpleBlock backBlock = ^{
        [self onBack];
    };
    
    simpleBlock myMemesBlock = ^{
        MPMyMemesViewController *myMemesController = [[MPMyMemesViewController alloc] init];
        [self.navigationController pushViewController:myMemesController animated:YES];
    };
    
    NSArray *actionsArray = @[backBlock, myMemesBlock];
    
    [self setupTabbarWithNames:names images:images actions:actionsArray];
}

#pragma mark - text field methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.emailField]) {
        [self.emailField resignFirstResponder];
        [self.usernameField becomeFirstResponder];
    }  else if ([textField isEqual:self.usernameField]){
        [self.usernameField resignFirstResponder];
        [self.passwordField becomeFirstResponder];
    } else if ([textField isEqual:self.passwordField]){
        [self.passwordField resignFirstResponder];
        [self.confirmPasswordField becomeFirstResponder];
    } else {
        [self.view endEditing:YES];
    }
    return YES;
}

#pragma mark - signup methods

- (BOOL)validation
{
    if (self.emailField.text.length<=0 ||
        self.passwordField.text.length<=0 ||
        self.usernameField.text.length<=0) {
        [MPAlertManager showAlertMessage:@"Email cannot be empty" withOKblock:nil hasCancelButton:NO];
        return NO;
    }
    if (![self.passwordField.text isEqualToString:self.confirmPasswordField.text]) {
        [MPAlertManager showAlertMessage:@"Passwords do not match" withOKblock:nil hasCancelButton:NO];
        return NO;
    }
    if (![self isValidEmail:self.emailField.text]) {
        [MPAlertManager showAlertMessage:@"Please enter a valid email" withOKblock:nil hasCancelButton:NO];
        return NO;
    }
    if (self.passwordField.text.length <6) {
        [MPAlertManager showAlertMessage:@"Password is too short" withOKblock:nil hasCancelButton:NO];
        return NO;
    }
    
    return YES;
}

- (BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void)onSignup
{
    [self.view endEditing:YES];
    
    if ([self validation]) {
        
        NSString *emailString = [NSString stringWithFormat:@"%@", [self.emailField.text lowercaseString]];
        NSString *usernameString = [NSString stringWithFormat:@"%@", self.usernameField.text];
        NSString *passwordString = [NSString stringWithFormat:@"%@", self.passwordField.text];
        
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [[MPRequestProvider sharedInstance] registerWithEmail:emailString
//                                                        phone:@""
//                                                     username:usernameString
//                                                     password:passwordString
//                                                   completion:^(id result, NSError *error)
//         {
//             if (result) {
//                 [self login];
//             } else if (error) {
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                 });
//                 
//                 NSString *errorMessage = error.code == 100?error.domain:error.localizedDescription;
//                 
//                 [MPAlertManager showAlertMessage:errorMessage withOKblock:nil hasCancelButton:NO];
//                 NSLog(@"Couldn't register");
//             }
//         }];
    }
}
- (void)login
{
    NSString *usernameString = [NSString stringWithFormat:@"%@", [self.emailField.text lowercaseString]];
    NSString *passwordString = [NSString stringWithFormat:@"%@", self.passwordField.text];
    
//    [[MPAuthenticationManager sharedManager] loginWithUsername:usernameString
//                                                      password:passwordString
//                                                    completion:^(BOOL completed)
//     {
//         dispatch_async(dispatch_get_main_queue(), ^{
//             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//         });
//         
//         if (completed) {
//             AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//             [appDelegate setMainController];
//             [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_PROFILE_NOTIFICATION object:nil];
//         } else {
//             [MPAlertManager showAlertMessage:kSignInFailedString withOKblock:nil hasCancelButton:NO];
//         }
//     }];

}
@end
