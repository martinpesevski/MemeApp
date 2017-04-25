//
//  MPSideMenuViewController.m
//  Betting
//
//  Created by Martin Peshevski on 4/29/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import "MPSideMenuViewController.h"
#import "MPBaseNavigationViewController.h"
#import "Masonry.h"
#import "MPSideMenuCell.h"
#import "MPAlertManager.h"
#import "MPColorManager.h"
#import "MPMyMemesViewController.h"
#import "MPSearchMemesViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "MPMainViewController.h"
#import "AppDelegate.h"
#import "MPAuthenticationManager.h"

#define kReuseIdentifier @"sideMenuCell"

@interface MPSideMenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *viewControllerAray;
@property (nonatomic, strong) NSArray *controllerNamesArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIViewController *profileNavController;

@end

@implementation MPSideMenuViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViewControllersArray];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self setConstraints];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupViewControllersArray
{
    MPMyMemesViewController *myMemesController = [[MPMyMemesViewController alloc] init];
//    MPBaseNavigationViewController *myMemesNavController = [[MPBaseNavigationViewController alloc] initWithRootViewController:myMemesController];
    
    MPSearchMemesViewController *searchNewestController = [[MPSearchMemesViewController alloc] init];
//    MPBaseNavigationViewController *searchNewestNavController = [[MPBaseNavigationViewController alloc] initWithRootViewController:searchNewestController];
    
    MPSearchMemesViewController *searchPopularController = [[MPSearchMemesViewController alloc] init];
//    MPBaseNavigationViewController *searchPopularNavController = [[MPBaseNavigationViewController alloc] initWithRootViewController:searchPopularController];
    
    self.viewControllerAray = @[myMemesController, searchNewestController, searchPopularController];
    self.controllerNamesArray = @[@"Your Memes", @"Newest", @"Popular", @"Logout"];
}

- (void)setupViews
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [MPColorManager getBackgroundColor];

    [self.view addSubview:self.tableView];
}

- (void)setConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(self.view);
    }];
}

- (UIViewController *)getFirstController
{
    return self.viewControllerAray[0];
}

#pragma mark - Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.controllerNamesArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.controllerNamesArray.count - 1) {
        MPMainViewController *mainController = (MPMainViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).viewController;
        [(MPBaseNavigationViewController *)mainController.rootViewController pushViewController:self.viewControllerAray[indexPath.row] animated:YES];
        
        [self hideRightViewAnimated:nil];
    } else if (indexPath.row == self.controllerNamesArray.count-1) {
        [MPAlertManager showAlertMessage:@"Are you sure you wish to logout?" withOKblock:^{
            [[MPAuthenticationManager sharedManager] signOut];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            [appDelegate setSignIn];
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPSideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    
    if (!cell) {
        cell = [[MPSideMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReuseIdentifier];
    }
    
    [cell setupWithTitle:indexPath.row];
    
    return cell;
}

@end
