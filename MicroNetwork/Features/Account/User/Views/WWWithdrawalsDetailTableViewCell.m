//
//  WWWithdrawalsDetailTableViewCell.m
//  MicroNetwork
//
//  Created by Lucas on 16/6/26.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWWithdrawalsDetailTableViewCell.h"
#import "WWCashModel.h"

//4A90E2

@interface WWWithdrawalsDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *status;

@end

@implementation WWWithdrawalsDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCashListData:(WWCashModel *)cashModel {
    self.amount.text = [NSString stringWithFormat:@"%.2lf",cashModel.amount.doubleValue / 100];
    self.time.text = cashModel.createTime;
    if (cashModel.state == 1) {
        self.status.text = [NSString stringWithFormat:@"提现成功"];
        self.status.textColor = RGBA(74, 144, 226, 1);
    }
}

@end
