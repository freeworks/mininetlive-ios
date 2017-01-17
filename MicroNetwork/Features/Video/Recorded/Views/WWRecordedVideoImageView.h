//
//  WWRecordedVideoImageView.h
//  MicroNetwork
//
//  Created by Lucas on 16/7/5.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PlayClickBlock)();

@interface WWRecordedVideoImageView : UIImageView

- (instancetype)initWithFrame:(CGRect)frame imageURL:(NSString *)imageURL isButton:(BOOL)isButton clickBlock:(PlayClickBlock)block;

@end
