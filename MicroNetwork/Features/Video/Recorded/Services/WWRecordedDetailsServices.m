//
//  WWRecordedDetailsServices.m
//  MicroNetwork
//
//  Created by Lucas on 16/6/29.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWRecordedDetailsServices.h"
#import "AFNetworking.h"
#import "WWUserInfoModel.h"

#define PAY_PING_PATH               @"pay/charge"
#define APPOINTMENT_PATH            @"activity/appointment/"
#define GROUP_MEMBER_LIST_PATH      @"activity/group/member/list"
#define GROUP_MEMBER_COUNT_PATH     @"activity/group/member/count"
#define PLAY_HISTORY_PATH           @"activity/play"


@implementation WWRecordedDetailsServices

+ (void)requestPay:(NSDictionary *)parameters resultBlock:(PayResponse)block {
    
    [self startDataTaskWithParameters:parameters apiPath:PAY_PING_PATH completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            WWbaseModel *baseModel = [WWbaseModel modelWithJSON:responseObject];
            NSLog(@"支付对象:%@",responseObject);
            if (block) {
                block(baseModel, nil);
            }
        } else {
            NSLog(@"支付error:%@",error);
            block(nil, error);
        }
    }];

}

+ (void)requestAppointment:(NSString *)aid resultBlock:(PayResponse)block {
    NSDictionary *parameters = @{@"aid":aid};
    [self startDataTaskWithParameters:parameters apiPath:APPOINTMENT_PATH completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            WWbaseModel *baseModel = [WWbaseModel modelWithJSON:responseObject];
            NSLog(@"预约:%@",responseObject);
            if (block) {
                block(baseModel, nil);
            }
        } else {
            NSLog(@"error:%@",error);
            block(nil, error);
        }
    }];
}

+ (void)requestGroupMemberList:(NSString *)groupId resultBlock:(MenberListResponse)block {
    NSDictionary *parameters = @{@"groupId":groupId};
    [self startDataTaskWithParameters:parameters apiPath:GROUP_MEMBER_LIST_PATH completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSLog(@"群成员资料:%@",responseObject);
            NSArray *menbers = responseObject[@"data"];
            NSMutableArray *menberList = [NSMutableArray array];
            for (NSDictionary *dic in menbers) {
                WWUserInfoModel *menber = [WWUserInfoModel modelWithDictionary:dic];
                [menberList addObject:menber];
            }

            if (block) {
                block(menberList, nil);
            }
        } else {
            NSLog(@"error:%@",error);
            block(nil, error);
        }
    }];
}

+ (void)requestGroupMemberCount:(NSString *)groupId resultBlock:(PayResponse)block {
    NSDictionary *parameters = @{@"groupId":groupId};
    [self startDataTaskWithParameters:parameters apiPath:GROUP_MEMBER_COUNT_PATH completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSLog(@"群人数:%@",responseObject);
            WWbaseModel *baseModel = [WWbaseModel modelWithJSON:responseObject];
            if (block) {
                block(baseModel, nil);
            }
        } else {
            NSLog(@"error:%@",error);
            block(nil, error);
        }
    }];
}

+ (void)requestPlayHistory:(NSString *)aid resultBlock:(PlayHistoryResponse)block {
    [self startDataTaskWithParameters:@{@"aid":aid} apiPath:PLAY_HISTORY_PATH completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            if (block) {
                block(nil);
            }
        } else {
            NSLog(@"error:%@",error);
            block(error);
        }
    }];
}

@end
