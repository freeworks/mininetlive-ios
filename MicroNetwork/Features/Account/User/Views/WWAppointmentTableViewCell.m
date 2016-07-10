//
//  WWUniversalListTableViewCell.m
//  MicroNetwork
//
//  Created by Lucas on 16/7/10.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWAppointmentTableViewCell.h"
#import "WWListModel.h"
#import "UIImageView+AFNetworking.h"


@interface WWAppointmentTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;

@end

@implementation WWAppointmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUniversalListCell:(WWListModel *)listModel {
    self.title.text = listModel.title;
    self.time.text = listModel.date;
    [self.videoImageView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"img_default"]];
}

@end
