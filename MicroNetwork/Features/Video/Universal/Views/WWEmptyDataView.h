//
//  WWEmptyDataView.h
//  MicroNetwork
//
//  Created by Lucas on 2017/1/5.
//  Copyright © 2017年 Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,WWEmptyDataViewType) {
    WWEmptyDataViewTypeLive,
};

@interface WWEmptyDataView : UIView

+ (instancetype)emptyDataViewWithDescription:(NSString *)description type:(WWEmptyDataViewType)type;

@end
