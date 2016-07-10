//
//  WWPromptView.m
//  MicroNetwork
//
//  Created by Lucas on 16/7/10.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWPromptView.h"
#import "FileOwner.h"

@interface WWPromptView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation WWPromptView

+ (id)loadFromNib {
    
    return [self loadFromNibNamed:NSStringFromClass(self)];
}

+ (id)loadFromNibNamed:(NSString *)nibName {
    
    return [FileOwner viewFromNibNamed:nibName];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = self.frame.size.width * 0.5;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowRadius = self.frame.size.width * 0.5;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.alpha = 0;
    self.frame = CGRectMake(SCREEN_WIDTH * 0.5 - 90, SCREEN_HEIGHT * 0.5 - 90, 180, 180);
}

- (void)showPromptType:(MyPrompt)promptType {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        switch (promptType) {
            case MyPromptAppointment:
                [self.imageView setImage:[UIImage imageNamed:@"ic_reservation"]];
                self.title.text = @"预约成功";
                self.title.textColor = UIColorFromRGB(0x4A90E2);
                break;
            case MyPromptATip:
                [self.imageView setImage:[UIImage imageNamed:@"ic_reward"]];
                self.title.text = @"谢谢打赏";
                self.title.textColor = UIColorFromRGB(0xF67C15);
                break;
            case MyPromptSuccess:
                [self.imageView setImage:[UIImage imageNamed:@"ic_buy"]];
                self.title.text = @"加入直播观看";
                self.title.textColor = UIColorFromRGB(0x0AC653);
                break;
                
            default:
                break;
        }
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:2.0];
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
