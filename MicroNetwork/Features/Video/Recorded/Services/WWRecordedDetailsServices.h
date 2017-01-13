//
//  WWRecordedDetailsServices.h
//  MicroNetwork
//
//  Created by Lucas on 16/6/29.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWServices.h"
#import "WWbaseModel.h"

typedef void (^PayResponse)(WWbaseModel *baseModel, NSError *error);

typedef void (^MenberListResponse)(NSArray *menberList, NSError *error);

typedef void(^PlayHistoryResponse)(NSError *error);
typedef void (^Response)(WWbaseModel *baseModel, NSError *error);



@interface WWRecordedDetailsServices : WWServices

+ (void)requestPay:(NSDictionary *)parameters resultBlock:(PayResponse)block;

+ (void)requestAppointment:(NSString *)aid resultBlock:(PayResponse)block;

+ (void)requestGroupMemberList:(NSString *)groupId resultBlock:(MenberListResponse)block;

+ (void)requestGroupMemberCount:(NSString *)groupId resultBlock:(PayResponse)block;

+ (void)requestPlayHistory:(NSString *)aid resultBlock:(PlayHistoryResponse)block;

+ (void)postJoin:(NSString *)aid resultBlock:(Response)block;

+ (void)postLeave:(NSString *)aid resultBlock:(Response)block;

+ (void)postMemberList:(NSString *)aid resultBlock:(MenberListResponse)block;

@end
