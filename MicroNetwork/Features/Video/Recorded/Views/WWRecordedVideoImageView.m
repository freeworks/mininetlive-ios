//
//  WWRecordedVideoImageView.m
//  MicroNetwork
//
//  Created by Lucas on 16/7/5.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWRecordedVideoImageView.h"
#import "UIImageView+AFNetworking.h"

@interface WWRecordedVideoImageView ()
@property (copy, nonatomic) PlayClickBlock block;
@end

@implementation WWRecordedVideoImageView

- (instancetype)initWithFrame:(CGRect)frame imageURL:(NSString *)imageURL isButton:(BOOL)isButton clickBlock:(PlayClickBlock)block {
    if (self = [super initWithFrame:frame]) {
        self.block = block;
        [self setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"img_default"]];
        self.userInteractionEnabled = YES;
        if (isButton) {
            [self addBuyButton];
        }
    }
    return  self;
}

- (void)addBuyButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.5 - 49, self.frame.size.height * 0.5 - 15, 98, 30)];
    [button setTitle:@"购买观看" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_buy"] forState:UIControlStateNormal];
    button.layer.cornerRadius = 6;
    [button addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)buyAction:(UIButton *)button {
    if (self.block) {
        self.block();
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.block) {
        self.block();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
