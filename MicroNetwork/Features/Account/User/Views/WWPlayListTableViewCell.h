//
//  WWPlayListTableViewCell.h
//  MicroNetwork
//
//  Created by Lucas on 16/7/11.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WWListModel;

@interface WWPlayListTableViewCell : UITableViewCell
- (void)setPlayList:(WWListModel *)listModel;
@end
