//
//  WWMyBonusViewController.m
//  MicroNetwork
//
//  Created by Lucas on 16/7/11.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWMyBonusViewController.h"

@interface WWMyBonusViewController ()
@property (weak, nonatomic) IBOutlet UILabel *amount;

@end

@implementation WWMyBonusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)withdrawalClick:(UIButton *)sender {
    [self performSegueWithIdentifier:@"ValidationStep1" sender:nil];
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
