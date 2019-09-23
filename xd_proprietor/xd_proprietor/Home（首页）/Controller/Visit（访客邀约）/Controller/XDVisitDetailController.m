//
//  XDVisitDetailController.m
//  XD业主
//
//  Created by zc on 2017/8/10.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDVisitDetailController.h"
#import "XDVisitorListController.h"
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "SGActionView.h"

@interface XDVisitDetailController ()

{
    NSArray *_codeArray;
}

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (weak, nonatomic) IBOutlet UILabel *exprieTimeLabels;
@property (weak, nonatomic) IBOutlet UILabel *timesNum;
@property (weak, nonatomic) IBOutlet UILabel *nameLabels;
@property (weak, nonatomic) IBOutlet UILabel *effectTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewAspectConstant;

@property(nonatomic,strong)UIImage *shareImage;
@end

@implementation XDVisitDetailController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.backView.layer.cornerRadius = 10;
    [self.backView.layer setMasksToBounds:YES];
    
    [self setVisitParams];
    
    //创建返回手势
    if (self.isAddNew) {
        UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(backToVisitList:)];
        [self.view addGestureRecognizer:popRecognizer];
    }
}

/**
 *  设置参数
 */
- (void)setVisitParams {

    self.navigationItem.title = @"邀请码";
    self.view.backgroundColor = litterBackColor;
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem leftItemWithImageName:@"nav_btn_back" frame:CGRectMake(0, 0, 40, 40) target:self action:@selector(goVisitListBack)];
    
    self.effectTimeLabel.text = self.visitModel.effectTime;
    self.exprieTimeLabels.text = self.visitModel.expireTime;
    self.timesNum.text = [NSString stringWithFormat:@"%d", self.visitModel.effectNum];
    self.nameLabels.text = self.visitModel.visitorName;
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    [self.codeImage sd_setImageWithURL:[NSURL URLWithString:self.visitModel.codeUrlStr] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [MBProgressHUD hideHUD];
    }];
    
    if ([XDUtil isIPad]) {
        [XDUtil changeMultiplierOfConstraint:self.backViewAspectConstant multiplier:1.1];
    }
}

- (void)backToVisitList:(UIPanGestureRecognizer *)recognize{
    switch (recognize.state) {
           case UIGestureRecognizerStateBegan:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshVisitList" object:nil];
            [self popToWhichViewVC];
            break;
            
        default:
           break;
    }
}

- (void)goVisitListBack {
    if (self.isAddNew) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshVisitList" object:nil];
        [self popToWhichViewVC];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)popToWhichViewVC {
    NSArray *temArray = self.navigationController.viewControllers;
    for(UIViewController *temVC in temArray) {
        if ([temVC isKindOfClass:[XDVisitorListController class]]) {
            [self.navigationController popToViewController:temVC animated:YES];
        }
    }
}

- (IBAction)shareBtnAction:(UIButton *)sender {
    if (!self.shareImage) {
        self.shareImage = [self imageWithScreenshot];
    }
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_QQ),
                                               /*@(UMSocialPlatformType_Sina)*/]];
    // 显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {

        // 根据获取的platformType确定所选平台进行下一步操作
        // 创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        // 创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        // 如果有缩略图，则设置缩略图
        shareObject.thumbImage = self.shareImage;
        [shareObject setShareImage:self.shareImage];
        messageObject.shareObject = shareObject;
        // 调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            } else {
                NSLog(@"response data is %@",data);
            }
        }];
    }];
//    if (!self.shareImage) {
//        self.shareImage = [self imageWithScreenshot];
//    }
//    __weak typeof(self) weakSelf = self;
//    [SGActionView showGridMenuWithTitle:@"分享"
//                             itemTitles:@[ @"微信", @"QQ"]
//                                 images:@[ [UIImage imageNamed:@"weixin"],
//                                           [UIImage imageNamed:@"qq"]]
//                         selectedHandle:^(NSInteger index) {
//
//                             if (index == 0) {
//                                 return ;
//                             }
//                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                 [weakSelf shareToThirdApp:index];
//                             });
//
//
//                         }];
}

- (void)shareToThirdApp:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    UIImage *image = weakSelf.shareImage;
    shareObject.thumbImage = image;
    [shareObject setShareImage:image];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    UMSocialPlatformType type;
    NSString *typeString;
    if (index == 1) {
        typeString = @"微信";
        type = UMSocialPlatformType_WechatSession;
    }else {
        typeString = @"QQ";
        type = UMSocialPlatformType_QQ;
       
    }
    //调用分享接口 UMSocialPlatformType_QQ  UMSocialPlatformType_WechatSession
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:weakSelf completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
        
        [weakSelf alertWithError:error withString:typeString];
        
    }];
}


- (void)alertWithError:(NSError *)error withString:(NSString *)type
{
    __weak typeof(self) weakSelf = self;
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功"];
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if ([str containsString:@"message = APP Not Install"]) {
            result = [NSString stringWithFormat:@"请检查是否安装了%@",type];
        }else{
            result = [NSString stringWithFormat:@"分享失败"];
        }
    }
    
    [weakSelf clickToAlertViewTitle:@"分享" withDetailTitle:result];

}

/**
 *  返回截取到的图片
 *
 *  @return UIImage *
 */
- (UIImage *)imageWithScreenshot
{
    NSData *imageData = [XDUtil dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}

- (IBAction)savePhotoAction:(UIButton *)sender {
    //参数1:图片对象
    //参数2:成功方法绑定的target
    //参数3:成功后调用方法
    //参数4:需要传递信息(成功后调用方法的参数)
    UIImageWriteToSavedPhotosAlbum([self imageWithScreenshot], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark -- <保存到相册>
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if (error) {
        msg = @"保存图片失败" ;
    } else {
        msg = @"保存图片成功" ;
    }
    NSLog(@"%@", msg);
    [XDUtil showToast:@"保存成功！"];
}

- (void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:window.bounds WithTitle:title andDetail:detailTitle andBody:nil andCancelTitle:nil andOtherTitle:@"知道了" andIsOneBtn:YES];
    [window addSubview:alertView];
}

- (void)dealloc {

}

@end
