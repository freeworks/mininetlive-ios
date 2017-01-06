//
//  UITableView+EmptyView.m
//  MicroNetwork
//
//  Created by Lucas on 2017/1/5.
//  Copyright © 2017年 Lucas. All rights reserved.
//

#import "UITableView+EmptyView.h"
#import <objc/runtime.h>
#import "Masonry.h"

@implementation UITableView (EmptyView)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(reloadData);
        SEL swizzledSelector = @selector(yz_reloadData);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)yz_reloadData {
    [self yz_reloadData];
    [self checkEmptyDataSource];
}

- (UIView *)emptyDataView {
    return objc_getAssociatedObject(self, @selector(emptyDataView));
}

- (void)setEmptyDataView:(UIView *)emptyDataView {
    objc_setAssociatedObject(self, @selector(emptyDataView), emptyDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)checkEmptyDataSource {
    id<UITableViewDataSource> dataSourceHandler = self.dataSource;
    NSInteger sectionsNumber = 1;
    if ([dataSourceHandler respondsToSelector: @selector(numberOfSectionsInTableView:)]) {
        sectionsNumber = [dataSourceHandler numberOfSectionsInTableView:self];
    }
    
    BOOL isEmptyDataSource = YES;
    for (int i = 0; i<sectionsNumber; i++) {
        NSInteger rows = [dataSourceHandler tableView:self numberOfRowsInSection:i];
        if (rows > 0) {
            isEmptyDataSource = NO;
        }
    }
    
    if (self.emptyDataView == nil) {
        return;
    }
    
    if (isEmptyDataSource) {
        [self addSubview:self.emptyDataView];
        
        [self.emptyDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.width.equalTo(self.mas_width);
            make.height.equalTo(self.mas_height);
        }];
    } else {
        [self.emptyDataView removeFromSuperview];
    }
}

@end

