//
//  WWLiveTableViewController.m
//  MicroNetwork
//
//  Created by Lucas on 16/7/9.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWLiveTableViewController.h"
#import "WWLiveTableViewCell.h"
#import "WWRecordedDetailsViewController.h"
#import "WWUtils.h"
#import "NSUserDefaults+Signin.h"
#import "WWNoLiveView.h"
#import "WWVideoService.h"
#import "WWVideoModel.h"
#import "SVProgressHUD.h"

typedef enum : NSUInteger {
    kPlayTypesLive = 0,
    kPlayTypesRecorded,
} kPlayTypes;


@interface WWLiveTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) WWNoLiveView *noLiveView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) NSArray *liveList;
@end

@implementation WWLiveTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    self.noLiveView = [WWNoLiveView loadFromNib];
    self.noLiveView.frame = self.view.bounds;
    [SVProgressHUD show];
    __weak __block typeof(self) weakSelf = self;
    [WWVideoService requstLiveList:nil resultBlock:^(NSArray *liveArray, NSError *error) {
        [SVProgressHUD dismiss];
        weakSelf.liveList = liveArray;
        [weakSelf.topView removeAllSubviews];
        [weakSelf.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.liveList.count;
}

static NSString *kIdentifier = @"Live Cell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WWLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier forIndexPath:indexPath];
    [cell setLiveData:self.liveList[indexPath.row]];
    if (self.noLiveView) {
        [self.noLiveView removeFromSuperview];
        self.noLiveView = nil;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WWRecordedDetailsViewController *recordedDetailsVC = (WWRecordedDetailsViewController *)[WWUtils getVCWithStoryboard:@"Recorded" viewControllerId:@"RecordedDetailsVC"];
    WWVideoModel *video = self.liveList[indexPath.row];
    recordedDetailsVC.video = video;
    if (video.streamType == kPlayTypesLive) {
        if ([NSUserDefaults standardUserDefaults].userToken.length == 0) {
            [WWUtils showTipAlertWithMessage:@"直播需要登录后才能观看"];
            [WWUtils showLoginVCWithTargetVC:self];
            return;
        }
    }
    [self.navigationController pushViewController:recordedDetailsVC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
