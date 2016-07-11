//
//  WWUserServices.m
//  MicroNetwork
//
//  Created by Lucas on 16/6/26.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWUserServices.h"
#import "WWListModel.h"

#define LOGOUT_PATH             @"auth/logout"
#define APPOINTMENT_LIST_PATH   @"account/record/appointment/list"
#define PLAY_LIST_PATH          @"account/record/play/list"
#define PAY_LIST_PATH           @"account/record/pay/list"
#define UPLOAD_IMAGE_PATH       @"account/avatar"
#define UPLOAD_NICKNAME_PATH    @"account/nickname"


typedef enum : NSUInteger {
    MyListTypeAppointment = 1,
    MyListTypePlay,
    MyListTypePay,
} MyListType;

@implementation WWUserServices

+ (void)requestLogOutWithResultBlock:(LoginResponse)block {

    [self startDataTaskWithParameters:nil apiPath:LOGOUT_PATH completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSLog(@"退出:%@",responseObject);
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

+ (void)requestListType:(NSInteger)listType resultBlock:(ListResponse)block {
    
    NSString *path;
    switch (listType) {
        case MyListTypeAppointment:
            path = APPOINTMENT_LIST_PATH;
            break;
        case MyListTypePlay:
            path = PAY_LIST_PATH;
            break;
        case MyListTypePay:
            path = PLAY_LIST_PATH;
            break;
            
        default:
            break;
    }
    
    [self startDataTaskWithParameters:nil apiPath:path HTTPMethod:@"GET" completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSLog(@"列表:%@",responseObject);
            NSArray *list = responseObject[@"data"];
            NSMutableArray *listModels = [NSMutableArray array];
            for (NSDictionary *dic in list) {
                WWListModel *listModel = [WWListModel modelWithDictionary:dic];
                [listModels addObject:listModel];
            }
            if (block) {
                block(listModels, nil);
            }
        } else {
            NSLog(@"error:%@",error);
            block(nil, error);
        }
    }];
}

+ (void)requestUploadAvatar:(UIImage *)image resultBlock:(LoginResponse)block {
    
    [self uploadImage:image apiPath:UPLOAD_IMAGE_PATH serviceResponseBlock:^(id responseObject, NSError *error) {
        NSLog(@"%@-----error:%@",responseObject, error);
    }];
    
}

+ (void)requestUploadNickName:(NSString *)nickName resultBlock:(LoginResponse)block {
    NSDictionary *parameters = @{@"nickName":nickName};
    [self startDataTaskWithParameters:parameters apiPath:UPLOAD_NICKNAME_PATH completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSLog(@"昵称更改:%@",responseObject);
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

+ (void)requestUploadGender:(NSInteger)gender resultBlock:(LoginResponse)block {
    NSDictionary *parameters = @{@"gender":@(gender)};
    [self startDataTaskWithParameters:parameters apiPath:UPLOAD_NICKNAME_PATH completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSLog(@"性别更改:%@",responseObject);
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


@end
