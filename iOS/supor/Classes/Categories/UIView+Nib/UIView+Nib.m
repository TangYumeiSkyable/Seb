//
//  UIView+Nib.m
//  RHYadu
//
//  Created by 赵冰冰 on 2017/4/20.
//  Copyright © 2017年 RiHui. All rights reserved.
//

#import "UIView+Nib.h"

@implementation UIView (Nib)

+ (UINib *)loadNib {
    return [self loadNibNamed:NSStringFromClass([self class])];
}

+ (UINib *)loadNibNamed:(NSString *)nibName {
    return [self loadNibNamed:nibName bludle:[NSBundle mainBundle]];
}

+ (UINib *)loadNibNamed:(NSString *)nibName bludle:(NSBundle *)bundle {
    return [UINib nibWithNibName:nibName bundle:bundle];
}

+ (instancetype)loadInstnceFromNib {
    return [self loadInstanceFromNibWithName:NSStringFromClass([self class])];
}

+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName {
    return  [self loadInstanceFromNibWithName:nibName owner:nil];
}

+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner {
    return [self loadInstanceFromNibWithName:nibName owner:owner bundle:[NSBundle mainBundle]];
}

+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner bundle:(NSBundle *)bundle {
    UIView * result = nil;
    NSArray * elements = [bundle loadNibNamed:nibName owner:owner options:nil];
    
    for (id obj  in elements) {
        if ([obj isKindOfClass:[self class]]) {
            result = obj;
            break;
        }
    }
    return result;
}

@end
