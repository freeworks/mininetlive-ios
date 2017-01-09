//
//  WWUserCenterViewController.m
//  MicroNetwork
//
//  Created by Lucas on 16/6/7.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWUserCenterViewController.h"
#import "WWUtils.h"
#import "WWUserInfoModel.h"
#import "UIImageView+AFNetworking.h"
#import "WWUserServices.h"
#import "NSUserDefaults+Signin.h"
#import "SVProgressHUD.h"
#import "WWMyInviteCodeViewController.h"
#import "WWUniversalListTableViewController.h"
#import "WWUserCentreTableViewCell.h"
#import "WWUserCentre1TableViewCell.h"

@interface WWUserCenterViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (nonatomic, assign) BOOL isRelase;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *cellTitles;
@end

@implementation WWUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2;
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.borderWidth = 1;
    self.userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    NSNumber *isRelaseNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kIsRelase];
    self.isRelase = [isRelaseNumber boolValue];
}

- (void)initializeTheUserDataShow {
    [self.userImageView setImageWithURL:[NSURL URLWithString:[NSUserDefaults standardUserDefaults].avatar] placeholderImage:[UIImage imageNamed:@"ic_head"]];
    self.nickName.text = [NSUserDefaults standardUserDefaults].nickName;
    self.phone.text = [NSUserDefaults standardUserDefaults].phone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initializeTheUserDataShow];
}

- (NSArray *)images {
    if (!_images) {
        if (self.isRelase) {
            _images = @[@[@"ic_money",
                          @"ic_living"],
                        @[@"ic_Invitation_code",
                          @"ic_about"]];
        } else {
            _images = @[@[@"ic_money",
                          @"ic_ reserva",
                          @"ic_living",
                          @"ic_play_history"],
                        @[@"ic_Invitation_code",
                          @"ic_about"]];
        }
    }
    return _images;
}

- (NSArray *)cellTitles {
    if (!_cellTitles) {
        if (self.isRelase) {
            _cellTitles = @[@[@"直播预约",
                              @"播放历史"],
                            @[@"我的邀请码",
                              @"关于微网"],
                            @[@"退出登录"]];
        } else {
            _cellTitles = @[@[@"我的分红",
                              @"直播预约",
                              @"购买列表",
                              @"播放历史"],
                            @[@"我的邀请码",
                              @"关于微网"],
                            @[@"退出登录"]];
        }
    }
    return _cellTitles;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.cellTitles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        static NSString *rid= @"UserCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
        }
        return cell;
    } else {
        static NSString *rid= @"UserCell";
        WWUserCentreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if(cell == nil) {
            cell = [[WWUserCentreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
        }
        
        cell.titleLabel.text = self.cellTitles[indexPath.section][indexPath.row];
        cell.titleImageView.image = [UIImage imageNamed:self.images[indexPath.section][indexPath.row]];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.isRelase) {
            WWUniversalListTableViewController *universalListVC = (WWUniversalListTableViewController *)[WWUtils getVCWithStoryboard:@"User" viewControllerId:@"UniversalListVC"];
            if (indexPath.row == 0) {
                universalListVC.listType = 1;
            } else {
                universalListVC.listType = 3;
            }
            [self.navigationController pushViewController:universalListVC animated:YES];
        } else {
            if (indexPath.row == 1 || indexPath.row == 3) {
                WWUniversalListTableViewController *universalListVC = (WWUniversalListTableViewController *)[WWUtils getVCWithStoryboard:@"User" viewControllerId:@"UniversalListVC"];
                universalListVC.listType = indexPath.row;
                [self.navigationController pushViewController:universalListVC animated:YES];
            } else if (indexPath.row == 0) {
                [self performSegueWithIdentifier:@"showMyBonus" sender:nil];
            } else {
                [self performSegueWithIdentifier:@"showPayList" sender:nil];
            }
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"showCode" sender:nil];
        } else {
            [self performSegueWithIdentifier:@"MicroNetwork" sender:nil];
        }
    } else {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"是否确定要注销登录"
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:@"确定"
                                                        otherButtonTitles:nil, nil];
        [actionSheet showInView:self.view];
        
    }
}

#pragma mark Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        __weak __block typeof(self) weakSelf = self;
        [SVProgressHUD show];
        [WWUserServices requestLogOutWithResultBlock:^(WWbaseModel *baseModel, NSError *error) {
            if (!error) {
                [SVProgressHUD dismiss];
                if (baseModel.ret == KERN_SUCCESS) {
                    [[NSUserDefaults standardUserDefaults] removeUserInfo];
                    [weakSelf initializeTheUserDataShow];
                    weakSelf.tabBar.selectedIndex = 0;
                } else {
                    [WWUtils showTipAlertWithMessage:baseModel.msg];
                }
            } else {
                [SVProgressHUD showErrorWithStatus:@"连接服务器失败"];
            }
        }];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
}


@end
