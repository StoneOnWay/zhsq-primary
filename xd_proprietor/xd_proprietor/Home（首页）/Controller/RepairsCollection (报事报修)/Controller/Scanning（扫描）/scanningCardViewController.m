//
//  scanningWatchViewController.m
//  SmallTadpole
//
//  Created by FOX on 16/9/14.
//  Copyright © 2016年 ky. All rights reserved.
//

#define KBottomViewWight kScaleFrom_iPhone5_Desgin(220)
#define KPadding kScaleFrom_iPhone5_Desgin(30)

#import "scanningCardViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface scanningCardViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate>


/**边框*/
@property (nonatomic,weak) UIImageView *QRImageView;
/**扫描*/
@property (nonatomic,weak) UIImageView *scanImageView;
/**最底层的view*/
@property (nonatomic,weak) UIView *bottomView;

@property (nonatomic,strong) AVCaptureDevice *device;
@property (nonatomic,strong) AVCaptureDeviceInput *input;
@property (nonatomic,strong) AVCaptureMetadataOutput *output;
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *preview;

@property (strong, nonatomic) CIDetector *detector;


@end

@implementation scanningCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor =[UIColor blackColor];
    
    [self setScanWatchNavi];
    
    [self startScan];
    
    [self setupContentView];
    
}
#pragma mark - 设置导航栏
-(void)setScanWatchNavi{
    
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem leftItemWithImageName:@"nav_btn_back" frame:CGRectMake(0, 0, 40, 40) target:self action:@selector(scanGoBackAdd)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = CFont(19, 17);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"扫描";
    self.navigationItem.titleView = titleLabel;
    
}


-(void)scanGoBackAdd{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 开始扫描
- (void)startScan
{
    // 判断有没有相机
    //判断是否可以打开相机，模拟器此功能无法使用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
    //如果没获得权限
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"亲,请先到系统“隐私”中打开相机权限哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    //获取摄像设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    //创建输出流
    self.output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理 在主线程里刷新
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //初始化链接对象
    self.session = [[AVCaptureSession alloc] init];
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    //设置扫码支持的编码格式
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    
    
    
    
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.bounds;
    [self.view.layer addSublayer:layer];
    
    //扫描框
    self.output.rectOfInterest =  CGRectMake(kScreenHeight/5/kScreenHeight,(kScreenWidth-KBottomViewWight)*0.5/kScreenWidth,KBottomViewWight/kScreenHeight,KBottomViewWight/kScreenWidth);
    
    
    //开始捕获
    [self.session startRunning];
    
    
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [self.view addSubview:maskView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    [maskPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake((kScreenWidth-KBottomViewWight)*0.5, kScreenHeight/5, KBottomViewWight, KBottomViewWight) cornerRadius:1] bezierPathByReversingPath]];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.path = maskPath.CGPath;
    
    maskView.layer.mask = maskLayer;
    
    
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count == 0) {
        NSLog(@"%@", metadataObjects);
        return;
    }
    
    if (metadataObjects.count > 0) {
        
        [self.scanImageView.layer removeAllAnimations];
        
        //停止扫描
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
        //扫描得到的文本 可以拿到扫描后的文本做其他操作哦
        if (self.returnTextBlock !=nil) {
            
            typeof(self) __weak weak = self;
            weak.returnTextBlock(metadataObject.stringValue);
            
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}




#pragma mark - 创建UI
- (void)setupContentView
{
    // 最底层的view
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-KBottomViewWight)*0.5, kScreenHeight/5, KBottomViewWight, KBottomViewWight)];
    [self.view addSubview:bottomView];
    bottomView.layer.borderColor = [UIColor clearColor].CGColor;
    bottomView.layer.borderWidth = 1;
    self.bottomView = bottomView;
    
    // 提示
    CGFloat bottomViewMaxY = CGRectGetMaxY(bottomView.frame);
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, bottomViewMaxY+KPadding, kScreenWidth, 20)];
    lable.font = SFont(14);
    lable.text = @"请将二维码置于方框内";
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lable];
    
    // 边框
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:bottomView.bounds];
    imageView.image = [UIImage imageNamed:@"tongyong_saoma_kuang"];
    [bottomView addSubview:imageView];
    self.QRImageView = imageView;
    
    // 扫描效果
    UIImageView *scanView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, bottomView.frame.size.width, 2)];
    scanView.image = [UIImage imageNamed:@"tongyong_saoma_xian"];
    [bottomView addSubview:scanView];
    self.scanImageView = scanView;
    [self startQRAnimation];
    
    //     手动输入编号
    CGFloat lableMaxY = CGRectGetMaxY(lable.frame);
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-36)*0.5, lableMaxY+KPadding, 36, 36)];
    [btn setTitle:@"" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickLight:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"tongyong_sdt"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"tongyong_sdt_open"] forState:UIControlStateSelected];
    
    [btn.layer setCornerRadius:5];
    [self.view addSubview:btn];
    
}

- (void)clickLight:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self turnTorchOn:YES];
    } else {
        [self turnTorchOn:NO];
    }
}

#pragma mark - 开关灯
- (void)turnTorchOn:(bool)on
{
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}


#pragma mark - 开始二维码动画
- (void)startQRAnimation
{
    [self.scanImageView.layer removeAllAnimations];
    
    self.QRImageView.frame = self.bottomView.bounds;
    //    self.bottomView.center = self.view.center;
    
    CGRect frame = self.scanImageView.frame;
    frame.origin.y = 5;
    self.scanImageView.frame = frame;
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        
        CGRect frame = self.scanImageView.frame;
        frame.origin.y = self.bottomView.frame.size.height-10;
        self.scanImageView.frame = frame;
        
    } completion:nil];
}


#pragma mark -- block


-(void)returnInform:(returnInformBlock)block{
    
    self.returnTextBlock = block;
    
}














@end
