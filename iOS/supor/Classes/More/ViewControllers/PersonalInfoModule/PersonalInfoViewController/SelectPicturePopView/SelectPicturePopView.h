//
//  SelectPicturePopView.h
//  supor
//
//  Created by 刘杰 on 2018/4/27.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PopViewSelectType) {
    PopViewSelectCamera,
    PopViewSelectAlbum,
    PopViewSelectCancel
};

typedef void(^SelectCompletion)(PopViewSelectType);

@interface SelectPicturePopView : UIView

@property (nonatomic, assign) PopViewSelectType selectType;

@property (nonatomic, copy) SelectCompletion completion;

- (void)showPopView;

- (void)hidePopView;

@end
