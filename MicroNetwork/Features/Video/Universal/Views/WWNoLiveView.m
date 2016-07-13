//
//  WWNoLiveView.m
//  MicroNetwork
//
//  Created by Lucas on 16/7/13.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWNoLiveView.h"
#import "FileOwner.h"

@implementation WWNoLiveView

+ (id)loadFromNib {
    
    return [self loadFromNibNamed:NSStringFromClass(self)];
}

+ (id)loadFromNibNamed:(NSString *)nibName {
    
    return [FileOwner viewFromNibNamed:nibName];
}

- (void)layoutSubviews {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
