//
//  SProgressView.m
//  supor
//
//  Created by 白云杰 on 2017/6/21.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "SProgressView.h"

@implementation SProgressView

- (void)setGgTrackImage:(UIImage *)ggTrackImage {
    _ggTrackImage = ggTrackImage;
    
    UIImageView *trackImageView = self.subviews.firstObject;
    
    CGRect trackProgressFrame = trackImageView.frame;
    
    trackProgressFrame.size.height = self.frame.size.height;
    
    trackImageView.frame = trackProgressFrame;
    
    CGFloat width = _ggTrackImage.size.width/2.0;
    
    CGFloat height = _ggTrackImage.size.height/2.0;
    
    UIImage *imgTrack = [_ggTrackImage resizableImageWithCapInsets:UIEdgeInsetsMake(height, width, height, width)];

    trackImageView.image = imgTrack;
}

- (void)setGgProgressImage:(UIImage *)ggProgressImage {
    _ggProgressImage = ggProgressImage;
    
    CGFloat width = _ggProgressImage.size.width/2.0;
    
    CGFloat height = _ggProgressImage.size.height/2.0;
    
    UIImageView *progressImageView = self.subviews.lastObject;
    
    CGRect ProgressFrame = progressImageView.frame;
    
    ProgressFrame.size.height = self.frame.size.height;
    
    progressImageView.frame = ProgressFrame;
    
    UIImage *imgProgress = [_ggProgressImage resizableImageWithCapInsets:UIEdgeInsetsMake(height, width, height, width)];
    
    progressImageView.image = imgProgress;
}

@end
