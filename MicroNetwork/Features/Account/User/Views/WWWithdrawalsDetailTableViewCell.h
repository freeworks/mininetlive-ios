//
//  WWWithdrawalsDetailTableViewCell.h
//  MicroNetwork
//
//  Created by Lucas on 16/6/26.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WWCashModel;

@interface WWWithdrawalsDetailTableViewCell : UITableViewCell

- (void)setCashListData:(WWCashModel *)cashModel;

@end
