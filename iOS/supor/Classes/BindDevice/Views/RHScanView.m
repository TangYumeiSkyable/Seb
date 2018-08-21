//
//  RHScanView.m
//  supor
//
//  Created by 赵冰冰 on 16/6/22.
//  Copyright © 2016年 XYJ. All rights reserved.
//

#import "RHScanView.h"
#import <AVFoundation/AVFoundation.h>

@interface RHScanView ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreViewLayer;

@property (nonatomic, strong) UIImageView *line;

@property (nonatomic, strong) MASConstraint *top;

@property (nonatomic, assign) BOOL isDown;

@property (nonatomic, strong) UIImageView * bgImageView;

@end

@implementation RHScanView

- (AVCaptureSession *)session {
    if (_session == nil) {
        _session = [[AVCaptureSession alloc] init];
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //初始化输入流
        NSError * error = nil;
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (input == nil) {
            RHLog(@"%@", [error localizedDescription]);
            _session = nil;
        }
        if (_session) {
            [_session addInput:input];
            //添加输出流
            AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
            [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            [_session addOutput:output];
            
            [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
            //创建输出对象
            self.videoPreViewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:_session];
            [self.videoPreViewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            [self.videoPreViewLayer setFrame:self.layer.bounds];
            [self.bgImageView.layer addSublayer:self.videoPreViewLayer];
        }
    }
    return _session;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAKSELF(ws);
    UIImageView * imageView = [UIImageView new];
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    self.bgImageView = imageView;
    
    UIImageView * scanImageView = [UIImageView new];
    scanImageView.userInteractionEnabled = YES;
    scanImageView.image = [UIImage imageNamed:@"erweima_biankuang"];
    scanImageView.tag = 100;
    [self addSubview:scanImageView];
    
    UILabel * la = [UILabel new];
    la.numberOfLines = 0;
    la.textColor = [UIColor colorFromHexCode:@"#f2f2f2"];
    la.font = [UIFont fontWithName:Regular size:18];
    la.text = GetLocalResStr(@"airpurifier_cm_san_qrcode");
    [self addSubview:la];
    
    self.line = [[UIImageView alloc]init];
    self.line.image = [UIImage imageNamed:@"img_scanning_line"];
    [self addSubview:self.line];
    
    self.isDown = YES;
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(ws);
    }];
    
    [scanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.centerY.mas_equalTo(ws);
        make.height.mas_equalTo(scanImageView.mas_width);
    }];
    
    [la mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scanImageView.mas_bottom).with.offset(15);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.centerX.mas_equalTo(ws);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        ws.top = make.top.mas_equalTo(scanImageView);
        make.left.and.right.mas_equalTo(scanImageView);
        make.height.mas_equalTo(2);
    }];
}

- (void)scan:(NSTimer *)timer {
    //是否向下扫描
   
    UIImageView * scanView = [self viewWithTag:100];
    if (CGRectGetMaxY(scanView.frame) <= CGRectGetMaxY(self.line.frame)) {
        _isDown = NO;
    }
    if (CGRectGetMinY(self.line.frame) <= CGRectGetMinY(scanView.frame)) {
        _isDown = YES;
    }
    
    static CGFloat offSet = 0;
    
    if (_isDown) {
        offSet += 10;
    }else{
        offSet -= 10;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(scanView.mas_top).with.offset(offSet);
        }];
        
        [self layoutIfNeeded];
    }];
}

- (void)startScan {
    UIImageView * scanImageView = [self viewWithTag:100];
    WEAKSELF(ws);
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        ws.top = make.top.mas_equalTo(scanImageView);
        make.left.and.right.mas_equalTo(scanImageView);
        make.height.mas_equalTo(4);
    }];
    [self layoutIfNeeded];
    if (self.session) {
         [self.session startRunning];
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:GetLocalResStr(@"airpurifier_cm_san_qrcode_msg") message:nil delegate:nil cancelButtonTitle:GetLocalResStr(@"airpurifier_public_ok") otherButtonTitles:nil, nil];
        [alert show];
    }
    [self addAni];
}

- (void)addAni {
    [self.line.layer removeAllAnimations];
    UIView * v = [self viewWithTag:100];
    NSValue * value1 = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width / 2, CGRectGetMinY(v.frame) + CGRectGetHeight(self.line.frame) / 2)];
    NSValue * value2 = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width / 2, CGRectGetMaxY(v.frame) - CGRectGetHeight(self.line.frame) / 2)];
    CAKeyframeAnimation * ani = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    ani.values = @[value1, value2 , value1];
    ani.duration = 1.8;
    ani.removedOnCompletion = NO;
    ani.repeatCount = MAXFLOAT;
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.line.layer addAnimation:ani forKey:@"a"];
}

- (void)stopScan {
    [self.session stopRunning];
    
     UIImageView * scanView = [self viewWithTag:100];
    [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scanView.mas_top);
    }];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
        RHLog(@"%@", object.stringValue);
        // 停止扫描
        [self stopScan];
        // 将预览图层移除

        if ([self.delegate respondsToSelector:@selector(scanScuess:)]) {
            [self.delegate scanScuess:object.stringValue];
        }
    } else {
        RHLog(@"no data");
        if ([self.delegate respondsToSelector:@selector(scanFailure:)]) {
            [self.delegate scanFailure:nil];
        }
    }
}

@end
