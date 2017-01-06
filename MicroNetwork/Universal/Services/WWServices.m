//
//  WWServices.m
//  MicroNetwork
//
//  Created by Lucas on 16/5/29.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWServices.h"
#import "WWbaseModel.h"

#define BASE_URL        @"http://www.weiwanglive.com"
#define CONFIG_PATH     @"common/startConfig"

@implementation WWServices

+ (NSString *)baseURL {
    return BASE_URL;
}

+ (void)getConfigResultBlock:(ConfigBlock)block {
    [self startDataTaskWithParameters:nil apiPath:CONFIG_PATH HTTPMethod:@"GET" completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            NSLog(@"配置列表:%@",responseObject);
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
