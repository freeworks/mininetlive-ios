//
//  WWRewardTableViewCell.m
//  MicroNetwork
//
//  Created by Lucas on 2017/1/14.
//  Copyright © 2017年 Lucas. All rights reserved.
//

#import "WWRewardTableViewCell.h"
#import "WWListModel.h"

@implementation WWRewardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setListModel:(WWListModel *)listModel {
    self.title.text = listModel.nickname;
    self.desc.text = listModel.createTime;
    self.price.text = [NSString stringWithFormat:@"%.2lf",(double)listModel.amount / 100];
}

@end
