//
//  WWVideoService.h
//  MicroNetwork
//
//  Created by Lucas on 16/6/18.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWServices.h"
#import "WWbaseModel.h"
#import "WWVideoListModel.h"
#import "WWVideoModel.h"


typedef void (^VideoListResponse)(WWbaseModel *baseModel, WWVideoListModel *videoList, NSError *error);
typedef void (^LiveListResponse)(NSArray *liveArray, NSError *error);
typedef void (^VideoDetailResponse)(WWVideoModel *videoDetail, NSError *error);

@interface WWVideoService : WWServices

+ (void)requestVideoList:(NSDictionary *)parameters resultBlock:(VideoListResponse)block;

+ (void)requstLoadMoreVideo:(NSString *)tailVideoId resultBlock:(VideoListResponse)block;

+ (void)requstLiveList:(NSDictionary *)parameters resultBlock:(LiveListResponse)block;

+ (void)requestVideoDetail:(NSString *)aid resultBlock:(VideoDetailResponse)block;

@end
