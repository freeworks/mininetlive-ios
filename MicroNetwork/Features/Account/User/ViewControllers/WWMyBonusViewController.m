//
//  WWMyBonusViewController.m
//  MicroNetwork
//
//  Created by Lucas on 16/7/11.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWMyBonusViewController.h"
#import "WWUserServices.h"
#import "WWUtils.h"
#import "SVProgressHUD.h"
#import "NSUserDefaults+Signin.h"

@interface WWMyBonusViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UITextField *textAmount;

@end

@implementation WWMyBonusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textAmount.delegate = self;
    __weak __block typeof(self) weakSelf = self;
    [WWUserServices getUserBalanceResultBlock:^(NSString *balance, NSError *error) {
        weakSelf.amount.text = [NSString stringWithFormat:@"%.2lf",balance.doubleValue / 100];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindingSuccess) name:@"BindingMobilePhoneSuccess" object:nil];
}

- (IBAction)withdrawalClick:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.textAmount.hidden = NO;
        [sender setTitle:@"确定提现" forState:UIControlStateNormal];
    } else {
        if ([self.textAmount.text isEqualToString:@""] || !self.textAmount.text) {
            self.textAmount.hidden = YES;
            [sender setTitle:@"提现" forState:UIControlStateNormal];
            
        } else {
            if ([[NSUserDefaults standardUserDefaults].phone isEqualToString:@""] || [NSUserDefaults standardUserDefaults].phone == nil) {
                [self performSegueWithIdentifier:@"ValidationStep1" sender:nil];
            } else {
                [SVProgressHUD show];
                [WWUserServices requestTakeCash:self.textAmount.text.doubleValue * 100 resultBlock:^(WWbaseModel *baseModel, NSError *error) {
                    [SVProgressHUD dismiss];
                    if (error == nil) {
                        if (baseModel.ret == 2007) {
                            [self bindingSuccess];
                        } else if (baseModel.ret == 2006) {
                            [self performSegueWithIdentifier:@"ValidationStep1" sender:nil];
                        } else if (baseModel.ret == 2008) {
                            [WWUtils showTipAlertWithMessage:@"金额不正确"];
                        } else {
                            [WWUtils showTipAlertWithMessage:baseModel.msg];
                        }
                    } else {
                        [WWUtils showTipAlertWithMessage:@"请求失败"];
                    }
                }];
            }
        }
    }
}

#pragma mark - TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string containsString:@"."]) {
        [WWUtils showTipAlertWithMessage:@"禁止输入小数点，提现只支持提现整数"];
        return NO;
    }
    if ([textField.text integerValue] > 2000) {
        [WWUtils showTipAlertWithMessage:@"提现金额不能超于2万"];
        return NO;
    }
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    NSInteger flag=0;
    const NSInteger limited = 2;//小数点后需要限制的个数
    for (NSInteger i = futureString.length-1; i>=0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {

            if (flag > limited) {
                return NO;
            }
            break;
        }
        flag++;
    }
    return YES;
}

- (void)bindingSuccess {
    [WWUtils showTipAlertWithMessage:@"还没有绑定公众账号，请关注公众号“微网LIVE”，输入“提现”"];
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
