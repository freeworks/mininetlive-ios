//
//  WWBindingPhoneViewController.m
//  MicroNetwork
//
//  Created by Lucas on 2017/1/10.
//  Copyright © 2017年 Lucas. All rights reserved.
//

#import "WWBindingPhoneViewController.h"
#import "WWUserServices.h"
#import "SVProgressHUD.h"
#import "WWUtils.h"

@interface WWBindingPhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *againSendButton;

@end

@implementation WWBindingPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)againSendClick:(UIButton *)sender {
    if (![self checkIfPhoneNumberIsCorrect]) {
        return;
    }
    [SVProgressHUD show];
    [WWUserServices postVcodeWithPhone:self.phoneTextField.text resultBlock:^(WWbaseModel *baseModel, NSError *error) {
        if (!error) {
            [SVProgressHUD dismiss];
            if (baseModel.ret == KERN_SUCCESS) {
                [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
                [self startTime];
            } else {
                [WWUtils showTipAlertWithMessage:baseModel.msg];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"连接服务器失败"];
        }
    }];
}

- (IBAction)determineClick:(UIButton *)sender {
    
    if (![self checkIfPhoneNumberIsCorrect]) {
        return;
    }
    
    if (self.verificationCodeTextField.text.length == 0) {
        NSString *strTip = [NSString stringWithFormat:@"请输入验证码"];
        [WWUtils showTipAlertWithMessage:strTip];
        return;
    }
    [SVProgressHUD show];
    [WWUserServices postBindingPhone:self.phoneTextField.text vcode:self.verificationCodeTextField.text resultBlock:^(WWbaseModel *baseModel, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            if (baseModel.ret == KERN_SUCCESS) {
                [WWUtils showTipAlertWithMessage:@"绑定成功"];
            } else {
                [WWUtils showTipAlertWithMessage:baseModel.msg];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"连接服务器失败"];
        }
    }];
}

#pragma mark - Private Method
- (BOOL)checkIfPhoneNumberIsCorrect {
    if (!self.phoneTextField.text || [self.phoneTextField.text isEqualToString:@""]) {
        NSString *strTip = [NSString stringWithFormat:@"请输入手机号码"];
        [WWUtils showTipAlertWithMessage:strTip];
        
        return NO;
    }
    
    return YES;
}

- (void)startTime {
    __block int time = 60;
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC), 1 * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(timer, ^{
        if (time == 0) {
            dispatch_source_cancel(timer);
        }
        [self.againSendButton setTitle:[NSString stringWithFormat:@"%d秒", time--] forState:UIControlStateNormal];
        [self.againSendButton setEnabled:NO];
    });
    
    dispatch_source_set_cancel_handler(timer, ^{
        [self.againSendButton setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.againSendButton setEnabled:YES];
    });
    //启动
    dispatch_resume(timer);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
