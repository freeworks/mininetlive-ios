//
//  WWMyQrCodeViewController.m
//  MicroNetwork
//
//  Created by Lucas on 16/7/10.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWMyQrCodeViewController.h"
#import "NSUserDefaults+Signin.h"
#import "UIImageView+AFNetworking.h"


@interface WWMyQrCodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *qeCodeImageView;

@end

@implementation WWMyQrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.userImageView setImageWithURL:[NSURL URLWithString:[NSUserDefaults standardUserDefaults].avatar] placeholderImage:[UIImage imageNamed:@"ic_head"]];
    self.name.text = [NSUserDefaults standardUserDefaults].nickName;
    [self.qeCodeImageView setImageWithURL:[NSURL URLWithString:[NSUserDefaults standardUserDefaults].qrcode] placeholderImage:[UIImage imageNamed:@""]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)shareQrCode:(UIBarButtonItem *)sender {
    
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
