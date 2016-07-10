//
//  WWPromptView.h
//  MicroNetwork
//
//  Created by Lucas on 16/7/10.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MyPromptAppointment = 0,
    MyPromptATip,
    MyPromptSuccess,
} MyPrompt;

@interface WWPromptView : UIView
+ (id)loadFromNib;
- (void)showPromptType:(MyPrompt)promptType;
@end
