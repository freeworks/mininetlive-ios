//
//  WWWithdrawalValidation1ViewController.m
//  MicroNetwork
//
//  Created by Lucas on 16/7/11.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWWithdrawalValidation1ViewController.h"
#import "WWWithdrawalValidation2ViewController.h"
#import "SVProgressHUD.h"
#import "WWUtils.h"
#import "WWUserServices.h"

@interface WWWithdrawalValidation1ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textPhone;

@end

@implementation WWWithdrawalValidation1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextStepClick:(UIButton *)sender {
    if (self.textPhone.text.length != 11) {
        [WWUtils showTipAlertWithMessage:@"请输入正确手机号"];
        return;
    }
    [self sendSmsCode];
}

- (void)sendSmsCode {
    [SVProgressHUD show];
    __weak __block typeof(self) weakSelf = self;

    [WWUserServices postVcodeWithPhone:self.textPhone.text resultBlock:^(WWbaseModel *baseModel, NSError *error) {
        if (!error) {
            [SVProgressHUD dismiss];
            if (baseModel.ret == KERN_SUCCESS) {
                [weakSelf performSegueWithIdentifier:@"ValidationStep2" sender:nil];
            } else {
                [WWUtils showTipAlertWithMessage:baseModel.msg];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"连接服务器失败"];
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[WWWithdrawalValidation2ViewController class]]) {
        WWWithdrawalValidation2ViewController *step2VC = (WWWithdrawalValidation2ViewController *)segue.destinationViewController;
        step2VC.phone = self.textPhone.text;
    }
}


@end
