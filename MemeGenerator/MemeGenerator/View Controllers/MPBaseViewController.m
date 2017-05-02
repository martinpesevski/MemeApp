//
//  MPBaseViewController.m
//  Betting
//
//  Created by Martin Peshevski on 4/29/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import "MPBaseViewController.h"
#import "MPLoginViewController.h"
#import "MPMainViewController.h"
#import "AppDelegate.h"
#import "MPColorManager.h"
#import "Masonry.h"
#import "Constants.h"

@interface MPBaseViewController ()

@property (nonatomic, strong) MPNavigationBarView *navigationView;

@property (nonatomic, strong) NSArray *tabBarNamesArray;
@property (nonatomic, strong) NSArray *tabBarImagesArray;
@property (nonatomic, strong) NSArray *tabBarBlocksArray;

@property (nonatomic, strong) NSString *infoTitle;
@property (nonatomic, strong) NSString *infoText;

@end

@implementation MPBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [MPColorManager colorFromHexString:@"#838BFF"];
    
    self.navigationItem.hidesBackButton = YES;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarSetup) name:USER_LOGGED_OUT_NOTIFICATION object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;

    [self.view addGestureRecognizer:tap];
    
    [self setupTabbar];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self == [self.navigationController.viewControllers firstObject] &&
        ![self isKindOfClass:[MPLoginViewController class]] &&
        ![self isModal])
    {
//        [self addMenuButton];
    } else if(![self isKindOfClass:[MPLoginViewController class]]){
//        [self addBackButton];
    }
    [self.view bringSubviewToFront:self.tabBar];
}

- (void)tabbarSetup
{
    //override in child view controllers
}

- (void)setupTabbar
{
    self.tabBar = [[UITabBar alloc] init];
    self.tabBar.barTintColor = [MPColorManager getNavigationBarColor];
    self.tabBar.tintColor = [UIColor whiteColor];
    [self.tabBar setTranslucent:NO];
    self.tabBar.delegate = self;
    
    [self.view addSubview:self.tabBar];
    
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kTabbarHeight));
    }];
}

- (void)setupTabbarWithNames:(NSArray *)names images:(NSArray *)images actions:(NSArray *)actions
{
    self.tabBarNamesArray = names;
    self.tabBarImagesArray = images;
    self.tabBarBlocksArray = actions;
    
    NSMutableArray *tabsArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<names.count; i++) {
        NSString *name = names[i];
        UIImage *image = images[i];
        
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:name image:image tag:i];
        [tabsArray addObject:item];
    }
    
    [self.tabBar setItems:tabsArray];
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
    self.navigationController.navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
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
    
    if ([mainController isRightViewShowing]) {
        [mainController hideRightViewAnimated:YES completionHandler:nil];
    } else {
        [mainController showRightViewAnimated:YES completionHandler:nil];
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

- (void)showLogin
{
    MPLoginViewController *loginController = [[MPLoginViewController alloc] init];
    [self.navigationController pushViewController:loginController animated:YES];
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

#pragma mark - tabbar methods

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger index = [self.tabBarNamesArray indexOfObject:item.title];
    simpleBlock simpleBlock = self.tabBarBlocksArray[index];
    simpleBlock();
}

@end
