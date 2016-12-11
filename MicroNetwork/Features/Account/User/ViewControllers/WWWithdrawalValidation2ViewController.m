//
//  WWWithdrawalValidation2ViewController.m
//  MicroNetwork
//
//  Created by Lucas on 16/7/11.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWWithdrawalValidation2ViewController.h"
#import "NSUserDefaults+Signin.h"
#import "SVProgressHUD.h"
#import "WWUserServices.h"
#import "WWUtils.h"
#import "WWMyBonusViewController.h"


@interface WWWithdrawalValidation2ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelPhone;
@property (weak, nonatomic) IBOutlet UITextField *textCode;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UIButton *sendAgainButton;


@end

@implementation WWWithdrawalValidation2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.phone isEqualToString:@""] || !self.phone) {
        self.labelPhone.text = [NSUserDefaults standardUserDefaults].phone;
    } else {
        self.labelPhone.text = self.phone;
    }
    
    [self startTime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)onceAgainSend:(UIButton *)sender {
    [self sendSmsCode];
}

- (IBAction)nextStepClick:(UIButton *)sender {
    if (![self checkIfCodeIsCorrect]) {
        return;
    }
    __weak __block typeof(self) weakSelf = self;
    [WWUserServices postBindingPhone:self.phone vcode:self.textCode.text resultBlock:^(WWbaseModel *baseModel, NSError *error) {
        if (!error) {
            [SVProgressHUD dismiss];
            if (baseModel.ret == KERN_SUCCESS) {
                for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[WWMyBonusViewController class]]) {
                        [weakSelf.navigationController popToViewController:vc animated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"BindingMobilePhoneSuccess" object:nil];
                    }
                }
            } else {
                [WWUtils showTipAlertWithMessage:baseModel.msg];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"连接服务器失败"];
        }
    }];
}

- (BOOL)checkIfCodeIsCorrect {
    if (!self.textCode.text || [self.textCode.text isEqualToString:@""]) {
        [WWUtils showTipAlertWithMessage:@"请输入验证码"];
        return NO;
    }
    
    if (!self.textPassword.text || [self.textPassword.text isEqualToString:@""] || self.textPassword.text.length < 6) {
        [WWUtils showTipAlertWithMessage:@"请输入6位数密码"];
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
        [_sendAgainButton setTitle:[NSString stringWithFormat:@"%d秒", time--] forState:UIControlStateNormal];
        [_sendAgainButton setEnabled:NO];
    });
    
    dispatch_source_set_cancel_handler(timer, ^{
        NSLog(@"cancel");
        [_sendAgainButton setTitle:@"重新发送" forState:UIControlStateNormal];
        [_sendAgainButton setEnabled:YES];
    });
    //启动
    dispatch_resume(timer);
}

- (void)sendSmsCode {
    [SVProgressHUD show];
    [WWUserServices postVcodeWithPhone:self.phone resultBlock:^(WWbaseModel *baseModel, NSError *error) {
        if (!error) {
            [SVProgressHUD dismiss];
            if (baseModel.ret == KERN_SUCCESS) {
            } else {
                [WWUtils showTipAlertWithMessage:baseModel.msg];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"连接服务器失败"];
        }
    }];
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
