//
//  WWEmptyDataView.m
//  MicroNetwork
//
//  Created by Lucas on 2017/1/5.
//  Copyright © 2017年 Lucas. All rights reserved.
//

#import "WWEmptyDataView.h"
#import "Masonry.h"

@interface WWEmptyDataView()

@property (strong, nonatomic) UIImageView *messageImageView;
@property (strong, nonatomic) UILabel *messageLabel;

@end

@implementation WWEmptyDataView

- (instancetype)initWithDescription:(NSString *)description type:(WWEmptyDataViewType)type {
    self = [super init];
    if (self) {
        _messageImageView = [[UIImageView alloc] init];
        if(type == WWEmptyDataViewTypeLive) {
            _messageImageView.image = [UIImage imageNamed:@"ic_no_activity"];
        }
        [self addSubview:_messageImageView];
        
        [_messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(-50);
            make.width.equalTo(@(100));
            make.height.equalTo(@(100));
        }];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, _messageImageView.frame.origin.y + _messageImageView.frame.size.height + 30, self.frame.size.width, 22)];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [ UIFont systemFontOfSize:16];
        _messageLabel.textColor = RGBA(156, 156, 156, 1);
        [self addSubview:_messageLabel];
        
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_messageImageView.mas_bottom);
            make.height.equalTo(@(30));
            make.left.equalTo(self.mas_left).offset(20);
            make.right.equalTo(self.mas_right).offset(-20);
        }];
        
        _messageLabel.text = description;
    }
    return self;
}

+ (instancetype)emptyDataViewWithDescription:(NSString *)description type:(WWEmptyDataViewType)type {
    return [[WWEmptyDataView alloc] initWithDescription:description type:type];
}

#pragma mark -- public method
- (void) setErrorMessage:(NSString *)message {
    if(_messageLabel) {
        _messageLabel.text = message;
    }
}

- (void) setErrorMessage:(NSString *)message type:(WWEmptyDataViewType)type {
    if(_messageLabel) {
        _messageLabel.text = message;
    }
    
    if(_messageImageView) {
        if(type == WWEmptyDataViewTypeLive) {
            _messageImageView.image = [UIImage imageNamed:@"ic_no_activity"];
        }
    }
}

@end
