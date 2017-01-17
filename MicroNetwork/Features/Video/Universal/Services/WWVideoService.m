//
//  WWVideoService.m
//  MicroNetwork
//
//  Created by Lucas on 16/6/18.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWVideoService.h"

#define VIDEO_LIST_PATH     @"activity/list"
#define LOAD_MORE_PATH      @"activity/list/more"
#define LIVE_LIST_PAGE      @"activity/live/list"
#define VIDEO_DETAIL        @"activity/detail"

@implementation WWVideoService

+ (void)requestVideoList:(NSDictionary *)parameters resultBlock:(VideoListResponse)block {
    
    [self startDataTaskWithParameters:parameters apiPath:VIDEO_LIST_PATH HTTPMethod:@"GET" completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSLog(@"视频列表:%@",responseObject);
            WWbaseModel *baseModel = [WWbaseModel modelWithJSON:responseObject];
            WWVideoListModel *video = [WWVideoListModel modelWithDictionary:baseModel.data];
            
            if (block) {
                block(baseModel, video, nil);
            }
        } else {
            NSLog(@"error:%@",error);
            block(nil, nil, error);
        }
    }];
}

+ (void)requstLoadMoreVideo:(NSString *)tailVideoId resultBlock:(VideoListResponse)block {
    
    [self startDataTaskWithParameters:nil apiPath:[NSString stringWithFormat:@"%@/%@",LOAD_MORE_PATH, tailVideoId] HTTPMethod:@"GET" completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSLog(@"加载视频列表:%@",responseObject);
            WWbaseModel *baseModel = [WWbaseModel modelWithJSON:responseObject];
            WWVideoListModel *video = [WWVideoListModel modelWithDictionary:baseModel.data];
            
            if (block) {
                block(baseModel, video, nil);
            }
        } else {
            NSLog(@"error:%@",error);
            block(nil, nil, error);
        }
    }];
}

+ (void)requstLiveList:(NSDictionary *)parameters resultBlock:(LiveListResponse)block {
    [self startDataTaskWithParameters:parameters apiPath:LIVE_LIST_PAGE HTTPMethod:@"GET" completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSLog(@"直播视频列表:%@",responseObject);
            NSArray *liveList = responseObject[@"data"];
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in liveList) {
                WWVideoModel *model = [WWVideoModel modelWithDictionary:dic];
                [array addObject:model];
            }
            if (block) {
                block(array, nil);
            }
        } else {
            NSLog(@"error:%@",error);
            block(nil, error);
        }
    }];
}

+ (void)requestVideoDetail:(NSString *)aid resultBlock:(VideoDetailResponse)block {
    NSString *path = [NSString stringWithFormat:@"%@/%@",VIDEO_DETAIL, aid];
    [self startDataTaskWithParameters:nil apiPath:path HTTPMethod:kHttpMethodGET completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSLog(@"视频详情:%@",responseObject);
            if ([responseObject[@"ret"] integerValue] == 0) {
                WWVideoModel *model = [WWVideoModel modelWithJSON:responseObject[@"data"]];
                if (block) {
                    block(model,nil);
                }
            }
        } else {
            NSLog(@"error:%@",error);
            block(nil, error);
        }
    }];
}

@end
