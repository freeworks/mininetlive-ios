//
//  WWPayListTableViewCell.m
//  MicroNetwork
//
//  Created by Lucas on 16/7/11.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWPayListTableViewCell.h"
#import "WWListModel.h"
#import "UIImageView+AFNetworking.h"

@interface WWPayListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *payType;
@property (weak, nonatomic) IBOutlet UILabel *payDate;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *videoDate;
@property (weak, nonatomic) IBOutlet UILabel *status;

@end

@implementation WWPayListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPayListDada:(WWListModel *)listModel {
    [self.videoImageView setImageWithURL:[NSURL URLWithString:listModel.frontCover] placeholderImage:[UIImage imageNamed:@"img_default"]];
    self.payType.text = [listModel.channel isEqualToString:@"wx"] ? @"微信支付": @"支付宝支付";
    self.amount.text = [NSString stringWithFormat:@"%zd", listModel.amount];
    self.payDate.text = listModel.createTime;
    self.type.text = listModel.nickname;
    self.videoDate.text = listModel.date;
    self.title.text = listModel.title;
}

@end
