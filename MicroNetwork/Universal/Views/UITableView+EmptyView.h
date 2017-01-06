//
//  UITableView+EmptyView.h
//  MicroNetwork
//
//  Created by Lucas on 2017/1/5.
//  Copyright © 2017年 Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (EmptyView)

@property (nonatomic, strong) UIView *emptyDataView;

- (void)checkEmptyDataSource;

@end
