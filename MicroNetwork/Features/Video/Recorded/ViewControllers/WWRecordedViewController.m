//
//  WWRecordedViewController.m
//  MicroNetwork
//
//  Created by Lucas on 16/6/5.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWRecordedViewController.h"
#import "WWRecordedCollectionViewCell.h"
#import "WWTapRecordedCollectionViewCell.h"
#import "WWUtils.h"
#import "MJRefresh.h"
#import "WWRecordedDetailsViewController.h"
#import "WWVideoService.h"
#import "SVProgressHUD.h"
#import "NSUserDefaults+Signin.h"


typedef enum : NSUInteger {
    kPlayTypesLive = 0,
    kPlayTypesRecorded,
} kPlayTypes;

#define STATUS_LIVE     1

@interface WWRecordedViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *generalList;
@property (strong, nonatomic) NSMutableArray *videos;
@property (nonatomic) NSInteger partition;
@property (nonatomic) BOOL isLoading;
@end

@implementation WWRecordedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.generalList = [NSMutableArray array];
    self.videos = [NSMutableArray array];
    if (self.isLoading == NO) {
        [self refreshNewListData];
    }
    [self addMJRefresh];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD setBackgroundColor:RGBA(255, 255, 255, 0.7)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isLoading) {
        [self getNewListData];
    }
}

#pragma mark - Private Method
- (void)addMJRefresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewListData)];
    
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    
    self.collectionView.mj_header = header;
}

- (void)refreshNewListData {
    
    [self.collectionView.mj_header  endRefreshing];

    __weak __block typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [WWVideoService requestVideoList:nil resultBlock:^(WWbaseModel *baseModel, WWVideoListModel *videoList, NSError *error) {
        [SVProgressHUD dismiss];
        self.isLoading = YES;
        if (!error) {
            if (baseModel.ret == KERN_SUCCESS) {
                weakSelf.recommendList = videoList.recommend;
                [weakSelf.generalList setArray:videoList.general];
                weakSelf.partition = weakSelf.recommendList.count == 0 ? 1: 2;

                if (videoList.hasmore) {
                    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreVideo)];
                    footer.automaticallyRefresh = NO;
                    self.collectionView.mj_footer = footer;
                }
            } else{
                [WWUtils showTipAlertWithMessage:baseModel.msg];
            }
            [weakSelf.collectionView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:@"连接服务器失败"];
        }
    }];
}

- (void)getNewListData {
    
    [self.collectionView.mj_header  endRefreshing];
    
    __weak __block typeof(self) weakSelf = self;
    [WWVideoService requestVideoList:nil resultBlock:^(WWbaseModel *baseModel, WWVideoListModel *videoList, NSError *error) {
        if (!error) {
            if (baseModel.ret == KERN_SUCCESS) {
                weakSelf.recommendList = videoList.recommend;
                [weakSelf.generalList setArray:videoList.general];
                weakSelf.partition = weakSelf.recommendList.count == 0 ? 1: 2;
                
                if (videoList.hasmore) {
                    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreVideo)];
                    footer.automaticallyRefresh = NO;
                    self.collectionView.mj_footer = footer;
                }
            } else{
                [WWUtils showTipAlertWithMessage:baseModel.msg];
            }
            [weakSelf.collectionView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:@"连接服务器失败"];
        }
    }];
}

- (void)loadMoreVideo {
    __weak __block typeof(self) weakSelf = self;
    [SVProgressHUD show];

    WWVideoModel *video = self.generalList[self.generalList.count-1];
    [WWVideoService requstLoadMoreVideo:video.aid resultBlock:^(WWbaseModel *baseModel, WWVideoListModel *videoList, NSError *error) {
        if (!error) {
            [SVProgressHUD dismiss];
            if (baseModel.ret == KERN_SUCCESS) {
                [weakSelf.generalList addObjectsFromArray:videoList.general];
                if (videoList.hasmore) {
                    [weakSelf.collectionView.mj_footer  endRefreshing];
                } else {
                    [weakSelf.collectionView.mj_footer  endRefreshingWithNoMoreData];
                }
                [weakSelf.collectionView reloadData];
            } else {
                [WWUtils showTipAlertWithMessage:baseModel.msg];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"连接服务器失败"];
        }
    }];
}

#pragma mark - Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.partition;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.recommendList.count;
    } else {
        return self.generalList.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WWTapRecordedCollectionViewCell *tapCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Tap Recorded Cell" forIndexPath:indexPath];
        [tapCell setVideoListData:self.recommendList[indexPath.row]];
        return tapCell;
    } else {
        WWRecordedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Recorded Cell" forIndexPath:indexPath];
        [cell setVideoListData:self.generalList[indexPath.row]];
        return cell;
    }
}

#pragma mark - Collection View Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(self.view.frame.size.width, 277);
    } else {
        return CGSizeMake(self.view.frame.size.width * 0.5 - 26, 158);
    }
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0,0);
    } else {
        return UIEdgeInsetsMake(15, 15, 15,15);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    WWRecordedDetailsViewController *recordedDetailsVC = (WWRecordedDetailsViewController *)[WWUtils getVCWithStoryboard:@"Recorded" viewControllerId:@"RecordedDetailsVC"];
    if (indexPath.section == 0) {
        recordedDetailsVC.video = self.recommendList[indexPath.row];;
    } else {
        recordedDetailsVC.video = self.generalList[indexPath.row];
    }
    [self.navigationController pushViewController:recordedDetailsVC animated:YES];

}




@end
