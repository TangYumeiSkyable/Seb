//
//  SelectCityViewController.h
//  supor
//
//  Created by 白云杰 on 2017/5/31.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSInteger, SelectCityVCPopStyle) {
    SelectCityVCPopToLast,
    SelectCityVCPopToRoot,
};


@interface SelectCityViewController : UIViewController

@property (nonatomic, copy) NSString *country;

@property (nonatomic, assign) SelectCityVCPopStyle popStyle;
@end
