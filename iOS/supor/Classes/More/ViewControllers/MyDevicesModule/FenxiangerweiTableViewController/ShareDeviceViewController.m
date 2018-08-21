//
//  ShareDeviceViewController.m
//  supor
//
//  Created by 刘杰 on 2018/4/21.
//  Copyright © 2018年 XYJ. All rights reserved.
//

#import "ShareDeviceViewController.h"
#import "RenameViewController.h"
#import "ShareDeviceView.h"
#import "UIView+WhenTappedBlocks.h"

@interface ShareDeviceViewController ()

@property(nonatomic,strong)NSTimer *countDownTimer;

@property (nonatomic, strong) ShareDeviceView *shareDeviceView;

@end

@implementation ShareDeviceViewController

#pragma mark - View LifeCycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self initViews];
    [self initData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
}

#pragma mark - Common Methods
- (void)configUI {
    self.navigationItem.title = GetLocalResStr(@"airpurifier_more_show_shareqrcode_text");
}

- (void)initViews {
    [self.view addSubview:self.shareDeviceView];
}

- (void)initData {
    WEAKSELF(weakself);
    
    [ACBindManager fetchShareCodeWithSubDomain:self.device.subDomain
                                      deviceId:self.device.deviceId
                                       timeout:5 * 60.0
                                      callback:^(NSString *shareCode, NSError *error) {
        if (error) {
            NSLog(@"get qrcode error:%@",error);
        } else {
            [weakself drawQRCodeImageViewWithString:shareCode];
        }
        weakself.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(refreshQRCodeImageView) userInfo:nil repeats:YES];
    }];
}

#pragma mark - Target Method
- (void)shareDeviceByEmailAction {
    RenameViewController *sharedeviceVC = [[RenameViewController alloc] init];
    sharedeviceVC.renameType = RenameShareDeviceWithEmailType;
    sharedeviceVC.device = self.device;
    [self.navigationController pushViewController:sharedeviceVC animated:YES];
}

#pragma mark - Private Methods
- (void)drawQRCodeImageViewWithString:(NSString *)string {
    //二维码滤镜
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //恢复滤镜的默认属性
    [filter setDefaults];
    
    //将字符串转换成NSData
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    //通过KVO设置滤镜inputmessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    //获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    //将CIImage转换成UIImage,并放大显示
    [self viewDidLayoutSubviews];
    
    self.shareDeviceView.qrcodeImageView.image = [self changeImageSizeWithCIImage:outputImage size:self.shareDeviceView.qrcodeImageView.width];
}

- (void)refreshQRCodeImageView {
    WEAKSELF(weakself);
    [ACBindManager fetchShareCodeWithSubDomain:self.device.subDomain
                                      deviceId:self.device.deviceId
                                       timeout:5 * 60.0
                                      callback:^(NSString *shareCode, NSError *error) {
        if (error) {
            NSLog(@"get qrcode error:%@",error);
        } else {
            [weakself drawQRCodeImageViewWithString:shareCode];
        }
    }];
}

//改变二维码大小

- (UIImage *)changeImageSizeWithCIImage:(CIImage *)image size:(CGFloat)size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - Lazyload Methods
- (ShareDeviceView *)shareDeviceView {
    if (!_shareDeviceView) {
        _shareDeviceView = [[ShareDeviceView alloc] initWithFrame:CGRectZero];
        _shareDeviceView.titleLabel.text = [NSString stringWithFormat:GetLocalResStr(@"airpurifier_more_show_suporttreater_text"), self.deviceInfoDic[@"name"]];
        WEAKSELF(weakself);
        [_shareDeviceView.shareBackgroundView whenTapped:^{
            [weakself shareDeviceByEmailAction];
        }];
    }
    return _shareDeviceView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.shareDeviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
}

@end
