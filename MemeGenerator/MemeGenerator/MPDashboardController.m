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
#import "MPMemeMakerViewController.h"
#import "MPSearchMemesViewController.h"
#import "MPMyMemesViewController.h"
#import "MPRequestProvider.h"
#import "AppDelegate.h"
#import "MPAlertManager.h"
#import "Strings.h"

#define kDashboardCellHeight 150

@interface MPDashboardController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSArray *cellNamesArray;
@property (nonatomic, strong) NSArray *cellImagesArray;

@property (nonatomic, strong) UITableView *dashboardTableView;

@end

@implementation MPDashboardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kDashboardTitleString;
    
    self.cellNamesArray = @[kFromAPhotoString, kFromAnImageString, kFromAKnownMemeString];
    self.cellImagesArray = @[[UIImage imageNamed:@"camera-icon"],
                             [UIImage imageNamed:@"folder-icon"],
                             [UIImage imageNamed:@"meme-icon"]];

    [self setupViews];
    [self setConstraints];
    [self tabbarSetup];
}

- (void)setupViews
{
    self.dashboardTableView = [[UITableView alloc] init];
    self.dashboardTableView.delegate = self;
    self.dashboardTableView.dataSource = self;
    [self.dashboardTableView registerClass:[MPDashboardCell class] forCellReuseIdentifier:@"dashboarIdentifier"];
    self.dashboardTableView.separatorColor = [UIColor clearColor];
    self.dashboardTableView.scrollEnabled = NO;
    self.dashboardTableView.backgroundColor = [UIColor clearColor];

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

- (void)tabbarSetup
{
    BOOL isLoggedIn = [[MPAuthenticationManager sharedManager] isLoggedIn];
    NSArray *names = @[kMyMemesString, isLoggedIn?kLogoutString:kLoginRegisterString];
    NSArray *images = @[[UIImage new], [UIImage new]];
    
    simpleBlock myMemesBlock = ^{
        MPMyMemesViewController *myMemesController = [[MPMyMemesViewController alloc] init];
        [self.navigationController pushViewController:myMemesController animated:YES];
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
    
    NSArray *actionsArray = @[myMemesBlock, loginBlock];
    
    [self setupTabbarWithNames:names images:images actions:actionsArray];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        case 1:
        {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
            break;
        case 2:
        {
            MPSearchMemesViewController *searchMemesController = [[MPSearchMemesViewController alloc] init];
            [self.navigationController pushViewController:searchMemesController animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - imagePicker methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    MPMeme *meme = [[MPMeme alloc] initWithImage:image name:@"asdf"];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        MPMemeMakerViewController *memeMakerController = [[MPMemeMakerViewController alloc] initWithMeme:meme];
        [self.navigationController pushViewController:memeMakerController animated:YES];
    }];
}

@end
