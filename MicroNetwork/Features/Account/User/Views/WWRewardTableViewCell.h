//
//  WWRewardTableViewCell.h
//  MicroNetwork
//
//  Created by Lucas on 2017/1/14.
//  Copyright © 2017年 Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WWListModel;

@interface WWRewardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (nonatomic, strong) WWListModel *listModel;
@end
