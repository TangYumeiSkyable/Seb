//
//  SProgressView.h
//  supor
//
//  Created by 白云杰 on 2017/6/21.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SProgressView : UIProgressView

@property (nonatomic,strong)UIImage *ggTrackImage;

@property (nonatomic,strong)UIImage *ggProgressImage;

-(void)setGgTrackImage:(UIImage *)ggTrackImage;

-(void)setGgProgressImage:(UIImage *)ggProgressImage;

@end
