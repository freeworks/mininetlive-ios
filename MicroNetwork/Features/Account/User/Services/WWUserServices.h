//
//  WWUserServices.h
//  MicroNetwork
//
//  Created by Lucas on 16/6/26.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWServices.h"
#import "WWbaseModel.h"


typedef void (^ListResponse)(NSArray *list, NSError *error);
typedef void (^LoginResponse)(WWbaseModel *baseModel, NSError *error);

@interface WWUserServices : WWServices

+ (void)requestLogOutWithResultBlock:(LoginResponse)block;
+ (void)requestListType:(NSInteger)listType resultBlock:(ListResponse)block;
+ (void)requestUploadAvatar:(UIImage *)image resultBlock:(LoginResponse)block;
+ (void)requestUploadNickName:(NSString *)nickName resultBlock:(LoginResponse)block;
+ (void)requestUploadGender:(NSInteger)gender resultBlock:(LoginResponse)block;

@end
