//
//  WWListModel.h
//  MicroNetwork
//
//  Created by Lucas on 16/7/9.
//  Copyright © 2016年 Lucas. All rights reserved.
//


/**
 *  预约列表、播放列表、购买列表通用模型。
 */

#import "YYKit.h"

@interface WWListModel : NSObject

@property (strong, nonatomic) NSString *aid;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *nickname;
@property (assign, nonatomic) NSInteger activityState;
@property (nonatomic, assign) NSInteger activityType;
@property (strong, nonatomic) NSString *date;
@property (assign, nonatomic) NSInteger amount;
@property (nonatomic,strong) NSString *frontCover;
@property (nonatomic,strong) NSString *channel;
@property (nonatomic,assign) NSInteger playCount;
@property (strong, nonatomic) NSString *create_time;


@end
