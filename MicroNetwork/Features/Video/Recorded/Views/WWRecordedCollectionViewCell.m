//
//  WWRecordedCollectionViewCell.m
//  MicroNetwork
//
//  Created by Lucas on 16/6/9.
//  Copyright © 2016年 Lucas. All rights reserved.
//

#import "WWRecordedCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation WWRecordedCollectionViewCell

- (void)setVideoListData:(WWVideoModel *)video {
    self.title.text = video.title;
//    self.videoType.text = video.videoType == 0 ? @"免费": @"收费";
    [self.fontCover setImageWithURL:[NSURL URLWithString:video.frontCover] placeholderImage:[UIImage imageNamed:@"img_default"]];
    self.playCount.text = [NSString stringWithFormat:@"%zd人",video.appointmentCount];
    if (video.streamType == 0) {
        self.playCount.text = [NSString stringWithFormat:@"%zd人",video.appointmentCount];
    } else {
        self.playCount.text = [NSString stringWithFormat:@"%zd次",video.playCount];
    }
}

@end
