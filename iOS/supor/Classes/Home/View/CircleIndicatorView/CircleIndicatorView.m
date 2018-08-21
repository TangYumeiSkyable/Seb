//
//  CircleIndicatorView.m
//  supor
//
//  Created by 赵冰冰 on 2017/5/11.
//  Copyright © 2017年 XYJ. All rights reserved.
//

#import "CircleIndicatorView.h"
#import "UIImage+FlatUI.h"


@implementation CircleIndicatorView
{
    CAShapeLayer * _topLayer;
    CAShapeLayer * _clsLayer;
    BOOL _alreadyDraw;
    UILabel * _pmLbl;
    UILabel * _pmValueLbl;
    UILabel * _tvoc;
    UIImageView * _airQuaIv;
    NSMutableArray * _shapeLayers;
}

- (UIImageView *)tvoc
{
    return _airQuaIv;
}

- (id)init
{
    if (self = [super init]) {
        _shapeLayers = @[].mutableCopy;
        self.opaque = NO;
        _pmLbl = [UILabel new];
        _pmLbl.textAlignment = NSTextAlignmentCenter;
        _pmLbl.textColor = [UIColor whiteColor];
        _pmLbl.font = [UIFont fontWithName:Regular size:14];
        _pmLbl.text = @"PM2.5";
        [self addSubview:_pmLbl];
        [_pmLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_bottom).multipliedBy(0.2);
            make.centerX.mas_equalTo(self);
        }];
        
        _pmValueLbl = [UILabel new];
        _pmValueLbl.text = @"--";
        _pmValueLbl.textColor = [UIColor whiteColor];
        _pmValueLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_pmValueLbl];
        [_pmValueLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
        _pmValueLbl.font = [UIFont fontWithName:Regular size:50];
        
        _tvoc = [UILabel new];
        _tvoc.textColor = [UIColor whiteColor];
        _tvoc.text = @"TVOC";
        _tvoc.textAlignment = NSTextAlignmentCenter;
        _tvoc.font = [UIFont fontWithName:Regular size:13];
        [self addSubview:_tvoc];
        [_tvoc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(self).with.offset(-40);
        }];
        
        _airQuaIv = [UIImageView new];
        _airQuaIv.image = [UIImage imageNamed:@"ico_face_happy"];
        [self addSubview:_airQuaIv];
        [_airQuaIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(_tvoc.mas_bottom).with.offset(RATIO(24));
            make.size.mas_equalTo(CGSizeMake(RATIO(72), RATIO(72)));
        }];
    }
    return self;
}

-(void)refreshWithTVOC:(NSInteger)tvoc
{
    if (tvoc == 0) {
        _tvoc.hidden = YES;
        _airQuaIv.hidden = YES;
    }else{
        _tvoc.hidden = NO;
        _airQuaIv.hidden = NO;
    }
    if (tvoc == 1) {
        _airQuaIv.image = [UIImage imageNamed:@"ico_face_happy"];
    }else if (tvoc == 2){
        _airQuaIv.image = [UIImage imageNamed:@"ico_face_general"];
    }else if (tvoc == 3){
        _airQuaIv.image = [UIImage imageNamed:@"ico_face_sad"];
    }
    [self setNeedsDisplay];
}

- (void)setPrecent:(CGFloat)precent
{
    if (_precent != precent) {
        _precent = precent;

            if (_precent == 0) {
                _pmValueLbl.text = @"--";
            } else {
                _pmValueLbl.text = [NSString stringWithFormat:@"%.0lf", precent];
            }
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    
    //    tvoc 1 good 2
    
    [_clsLayer removeFromSuperlayer];
    [_topLayer removeFromSuperlayer];
    
    while (_shapeLayers.count) {
        CAShapeLayer * sp = [_shapeLayers lastObject];
        [sp removeFromSuperlayer];
        [_shapeLayers removeObject:sp];
    }
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);//添加这句代码
    
    CGFloat w = rect.size.width;
    CGFloat r = w / 2 - 10;
    CGFloat theta1 = M_PI * 2 / 66.0;
    
    CGPoint start;
    CGPoint end;
    CGFloat startAngle = 0;

    UIColor * c = nil;
    

    
    
    if (_pm25_level == 1)
    { // PM good
        
        if (_hcho == 1)
        { // good
            c = [UIColor colorFromHexCode:@"#00c4f0" alapha:0.6]; // blue
        } else if (_hcho == 2)
        { // average
            c = [UIColor colorFromHexCode:@"#a98cf2" alapha:0.7]; // purple
        } else if (_hcho == 3)
        { // bad
            c = [UIColor colorFromHexCode:@"#ff4e33" alapha:0.6]; // red
        } else
        {
            c = [UIColor colorFromHexCode:@"#00c4f0" alapha:0.6]; // blue
        }
        
    } else if (_pm25_level == 2)
    { // PM average
        
        if (_hcho == 1)
        { // good
            c = [UIColor colorFromHexCode:@"#a98cf2" alapha:0.7]; // purple
        } else if (_hcho == 2)
        { // average
            c = [UIColor colorFromHexCode:@"#a98cf2" alapha:0.7]; // purple
        } else if (_hcho == 3)
        { // bad
            c = [UIColor colorFromHexCode:@"#ff4e33" alapha:0.6]; // red
        } else
        {
            c = [UIColor colorFromHexCode:@"#a98cf2" alapha:0.7]; // purple
        }
        
        
    } else if (_pm25_level == 3)
    { // PM bad
        
        if (_hcho == 1)
        { // good
            c = [UIColor colorFromHexCode:@"#ff4e33" alapha:0.6]; // red
        } else if (_hcho == 2)
        { // average
            c = [UIColor colorFromHexCode:@"#ff4e33" alapha:0.6]; // red
        } else if (_hcho == 3)
        { // bad
            c = [UIColor colorFromHexCode:@"#ff4e33" alapha:0.6]; // red
        } else
        {
            c = [UIColor colorFromHexCode:@"#ff4e33" alapha:0.6]; // red
        }
        
    } else
    {
         c = [UIColor colorFromHexCode:@"#f2f2f2" alapha:0.5];
    }
    
    if ([_pmValueLbl.text isEqualToString:@"--"]) {
        c = [UIColor colorFromHexCode:@"#ffffff" alapha:0.5];
    }
    
    for (int i = 0; i < 66; i++) {
        CGFloat theta2 = i * theta1;
        CGFloat x = r * cosf(theta2) + w / 2 - 1.5;
        CGFloat y = r * sinf(theta2) + w / 2 - 1.5;
        
        if (i < (33 - 33 / 4.0) && i > (33 / 4.0)) {
            if (i == 24) {
                start = CGPointMake(x, y);
                startAngle = theta2;
            }
            
            if ( i == (33 - 33 / 4)) {
                end = CGPointMake(x, y);
            }
            
            continue;
        }
        CAShapeLayer * layer = [CAShapeLayer layer];
        UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y, RATIO(12), RATIO(12))];
        layer.path = path.CGPath;
        layer.fillColor = c.CGColor;
        
        [self.layer addSublayer:layer];
        [_shapeLayers addObject:layer];
    }
}

@end
