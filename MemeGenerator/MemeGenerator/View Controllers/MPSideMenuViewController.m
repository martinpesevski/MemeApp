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
#import "MPDashboardController.h"
#import "UIViewController+LGSideMenuController.h"
#import "MPMainViewController.h"
#import "AppDelegate.h"

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
    MPDashboardController *hotelsController = [[MPDashboardController alloc] init];
    MPBaseNavigationViewController *hotelsNavController = [[MPBaseNavigationViewController alloc] initWithRootViewController:hotelsController];
    
    UIViewController *leagueController = [[UIViewController alloc] init];
    MPBaseNavigationViewController *leagueNavController = [[MPBaseNavigationViewController alloc] initWithRootViewController:leagueController];
    
    UIViewController *matesController = [[UIViewController alloc] init];
    MPBaseNavigationViewController *matesNavController = [[MPBaseNavigationViewController alloc] initWithRootViewController:matesController];
    
    self.viewControllerAray = @[hotelsNavController, leagueNavController, matesNavController];
    self.controllerNamesArray = @[@"Your Memes", @"Newest", @"Popular"];
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
    if (indexPath.row < self.viewControllerAray.count) {
        MPMainViewController *mainController = (MPMainViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).viewController;
        mainController.rootViewController = self.viewControllerAray[indexPath.row];
        
        [self hideRightViewAnimated:nil];
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
