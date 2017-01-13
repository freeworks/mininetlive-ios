//
//  WWUserServices.m
//  MicroNetwork
//
//  Created by Lucas on 16/6/26.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWUserServices.h"
#import "WWListModel.h"
#import "WWCashModel.h"
#import "NSUserDefaults+Signin.h"

#define APPOINTMENT_LIST_PATH   @"account/record/appointment/list"
#define PLAY_LIST_PATH          @"account/record/play/list"
#define PAY_LIST_PATH           @"account/record/pay/list"
#define UPLOAD_IMAGE_PATH       @"account/avatar"
#define UPLOAD_NICKNAME_PATH    @"account/nickname"
#define CASH_PATH               @"account/record/transfer/list"
#define TAKE_PATH               @"pay/transfer"
#define TRANSFER_PATH           @"account/transfer/list"
#define DIVIDEND_PATH           @"dividend/list"
#define LOGOUT_PATH             @"auth/logout"
#define DEVICE_TOKEN_PATH       @"auth/bindPush"
#define BALANCE_PATH            @"account/balance"
#define PHONE_PATH              @"account/phone"
#define VCODE_PATH              @"account/vcode"
#define INFO_PATH               @"account/info"

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
    
    NSDictionary *dic = @{@"uid":[[NSUserDefaults standardUserDefaults] uid]};
    [self startDataTaskWithParameters:dic apiPath:path HTTPMethod:kHttpMethodGET completionBlock:^(id responseObject, NSError *error) {
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
    NSDictionary *parameters = @{@"nickname":nickName};
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

+ (void)requestCashListWithResultBlock:(ListResponse)block {
    [self startDataTaskWithParameters:nil apiPath:CASH_PATH HTTPMethod:kHttpMethodGET completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSLog(@"提现明细:%@",responseObject);
            
            NSArray *cashList = responseObject[@"data"];
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in cashList) {
                WWCashModel *cash = [WWCashModel modelWithDictionary:dic];
                [array addObject:cash];
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

+ (void)requestTakeCash:(NSInteger)amount resultBlock:(LoginResponse)block {
    NSDictionary *parameters = @{@"amount":@(amount)};
    [self startDataTaskWithParameters:parameters apiPath:TAKE_PATH completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSLog(@"取现金:%@",responseObject);
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

+ (void)postDeviceToken:(NSString *)deviceToken resultBlock:(ResponseBlock)block {
    NSDictionary *parameters = @{@"deviceId":deviceToken};
    [self startDataTaskWithParameters:parameters apiPath:DEVICE_TOKEN_PATH completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            if (block) {
                block(nil);
            }
        } else {
            block(error);
        }
    }];
}

+ (void)getUserBalanceResultBlock:(BalanceBlock)block {
    [self startDataTaskWithParameters:nil apiPath:BALANCE_PATH HTTPMethod:kHttpMethodGET completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            if (block) {
                block(responseObject[@"data"][@"balance"], nil);
            }
        } else {
            block(nil,error);
        }
    }];
}

+ (void)postBindingPhone:(NSString *)phone vcode:(NSString *)vcode resultBlock:(BindingResponseBlock)block {
    NSDictionary *parameters = @{@"phone":phone,
                                 @"vcode":vcode};
    [self startDataTaskWithParameters:parameters apiPath:PHONE_PATH completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            WWbaseModel *baseModel = [WWbaseModel modelWithJSON:responseObject];
            if (block) {
                block(baseModel,nil);
            }
        } else {
            block(nil,error);
        }
    }];
}

+ (void)postVcodeWithPhone:(NSString *)phone resultBlock:(BindingResponseBlock)block {
    NSDictionary *parameters = @{@"phone":phone};
    [self startDataTaskWithParameters:parameters apiPath:VCODE_PATH completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            WWbaseModel *baseModel = [WWbaseModel modelWithJSON:responseObject];
            if (block) {
                block(baseModel,nil);
            }
        } else {
            block(nil,error);
        }
    }];
}

+ (void)getUserInfoResultBlock:(BindingResponseBlock)block {
    [self startDataTaskWithParameters:nil apiPath:INFO_PATH HTTPMethod:kHttpMethodGET completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            WWbaseModel *model = [WWbaseModel modelWithJSON:responseObject];
            if (block) {
                block(model, nil);
            }
        } else {
            block(nil,error);
        }
    }];
}

@end
