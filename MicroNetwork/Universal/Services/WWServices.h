//
//  WWServices.h
//  MicroNetwork
//
//  Created by Lucas on 16/5/29.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWRequestService.h"
@class WWbaseModel;

static NSString *kIsRelase  = @"isRelase";
static NSString *kEnable    = @"enable";

typedef void(^ConfigBlock)(WWbaseModel *baseModel, NSError *error);

@interface WWServices : WWRequestService

+ (void)getConfigResultBlock:(ConfigBlock)block;

@end
