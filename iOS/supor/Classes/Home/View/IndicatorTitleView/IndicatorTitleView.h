//
//  IndicatorTitleView.h
//  supor
//
//  Created by Jun Zhou on 2017/10/30.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

/** PM25 */
typedef NS_ENUM(NSInteger, AirPureState) {
    AirPureStateGood   = 0,
    AirPureStateAverage,
    AirPureStateBad,
};

@interface IndicatorTitleView : UIView

@property (assign, nonatomic) AirPureState airPureState;

@end
