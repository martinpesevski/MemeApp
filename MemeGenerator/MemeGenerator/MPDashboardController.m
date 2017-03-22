//
//  ViewController.m
//  MemeGenerator
//
//  Created by Martin Peshevski on 3/22/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import "MPDashboardController.h"
#import "MPDashboardCell.h"
#import "Masonry.h"

#define kDashboardCellHeight 150

@interface MPDashboardController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *cellNamesArray;
@property (nonatomic, strong) NSArray *cellImagesArray;

@property (nonatomic, strong) UITableView *dashboardTableView;

@end

@implementation MPDashboardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cellNamesArray = @[@"From a new photo", @"From an image or pic", @"From a known meme"];
    self.cellImagesArray = @[[UIImage imageNamed:@"ic_camera"],
                             [UIImage imageNamed:@"ic_folder"],
                             [UIImage imageNamed:@"ic_folder_shared"]];

    [self setupViews];
    [self setConstraints];
}

- (void)setupViews
{
    self.dashboardTableView = [[UITableView alloc] init];
    self.dashboardTableView.delegate = self;
    self.dashboardTableView.dataSource = self;
    [self.dashboardTableView registerClass:[MPDashboardCell class] forCellReuseIdentifier:@"dashboarIdentifier"];
    self.dashboardTableView.backgroundColor = [UIColor redColor];
    self.dashboardTableView.separatorColor = [UIColor clearColor];
    self.dashboardTableView.scrollEnabled = NO;

    [self.view addSubview:self.dashboardTableView];
}

- (void)setConstraints
{
    [self.dashboardTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(self.cellNamesArray.count * kDashboardCellHeight));
    }];
}

#pragma mark - tableview methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDashboardCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellNamesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPDashboardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dashboarIdentifier"];
    if (!cell) {
        cell = [[MPDashboardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dashboarIdentifier"];
    }
    
    [cell setupWithText:self.cellNamesArray[indexPath.row] image:self.cellImagesArray[indexPath.row]];
    
    return cell;
}

@end
