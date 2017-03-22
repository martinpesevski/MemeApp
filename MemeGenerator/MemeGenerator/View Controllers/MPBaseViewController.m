//
//  MPBaseViewController.m
//  Betting
//
//  Created by Martin Peshevski on 4/29/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import "MPBaseViewController.h"
//#import "MPLoginViewController.h"
#import "MPMainViewController.h"
#import "AppDelegate.h"

@interface MPBaseViewController ()

@property (nonatomic, strong) MPNavigationBarView *navigationView;

@property (nonatomic, strong) NSString *infoTitle;
@property (nonatomic, strong) NSString *infoText;

@end

@implementation MPBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;

    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self == [self.navigationController.viewControllers firstObject] &&
//        ![self isKindOfClass:[MPLoginViewController class]] &&
        ![self isModal])
    {
        [self addMenuButton];
    } else {
        [self addBackButton];
    }
}

- (void)addTitleViewWithTitle:(NSString *)title image:(UIImage *)image
{
    [self addTitleViewWithTitle:title image:image description:@""];
}

- (void)addTitleViewWithTitle:(NSString *)title image:(UIImage *)image description:(NSString *)description
{
    self.navigationView = [[MPNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    [self.navigationView setupWithTitle:title image:image description:description];
    self.navigationItem.titleView = self.navigationView;
}

- (void)addMenuButton
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
    UIImage *menuImage = [UIImage imageNamed:@"ic_menu_white"];
    [backButton setImage:menuImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)addBackButton
{
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_left_white"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    newBackButton.imageInsets = UIEdgeInsetsMake(3, -25, 3, -25);
    self.navigationItem.leftBarButtonItem=newBackButton;
}

- (void)toggleMenu
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MPMainViewController *mainController = (MPMainViewController *)appDelegate.viewController;
    
    if ([mainController isLeftViewShowing]) {
        [mainController hideLeftViewAnimated:YES completionHandler:nil];
    } else {
        [mainController showLeftViewAnimated:YES completionHandler:nil];
    }
}

- (void)onBack
{
    if ([self isModal]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - helper methods

- (BOOL)isModal {
    if([self presentingViewController])
        return YES;
    if([[[self navigationController] presentingViewController] presentedViewController] == [self navigationController])
        return YES;
    if([[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]])
        return YES;
    
    return NO;
}


@end
