//
//  XDHomeNearController.m
//  XD业主
//
//  Created by zc on 2017/7/2.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDHomeNearController.h"
#import "XDWebProgressLayer.h"
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "XDJsInteraction.h"

#define kCardQueryBaseUrl @"http://szjw.changsha.gov.cn/ywcx/"
#define kWorkProgressUrl @"https://cs.news.fang.com/open/31830817.html"

@interface XDHomeNearController ()<UIWebViewDelegate>

@property (strong, nonatomic)UIWebView *webView;
@property (nonatomic, strong) XDWebProgressLayer *webProgressLayer;  //  进度条

@end

@implementation XDHomeNearController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = backColor;
    //设置导航栏
//    [self setHomeNearNavi];
    
    //设置网页
    [self setHomeNearWebView];
    
    JSContext *context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    XDJsInteraction *ZHSQApp = [[XDJsInteraction alloc] init];
    context[@"$ZHSQApp"] = ZHSQApp;
}

- (void)setHomeNearWebView {
    NSURL *baseURL = nil;
    if ([self.title isEqualToString:@"周边服务"]) {
        baseURL = [NSURL URLWithString:@"http://map.baidu.com/mobile/webapp/index/index"];
    } else if ([self.title isEqualToString:@"工程进度"]) {
        baseURL = [NSURL URLWithString:kWorkProgressUrl];
    } else if ([self.title isEqualToString:@"产证查询"]) {
        baseURL = [NSURL URLWithString:kCardQueryBaseUrl];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_share"] style:(UIBarButtonItemStylePlain) target:self action:@selector(shareAction)];
    }
    
    //
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
//    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.webView.scalesPageToFit = YES;
    NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];
    [self.webView loadRequest:request];
    
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    _webProgressLayer = [[XDWebProgressLayer alloc] init];
    if ([XDUtil isIPad]) {
        _webProgressLayer.frame = CGRectMake(0, navHeight - 2, kScreenHeight, 2);
    } else {
        _webProgressLayer.frame = CGRectMake(0, 42, kScreenHeight, 2);
    }
    [self.navigationController.navigationBar.layer addSublayer:_webProgressLayer];
    [self.view addSubview:self.webView];
}

- (void)shareAction {
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_QQ),
                                               /*@(UMSocialPlatformType_Sina)*/]];
    // 显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"产证查询" descr:@"长沙市住房和城乡建设局-商品房合同签订查询" thumImage:[UIImage imageNamed:@"login_icon"]];
        //设置网页地址
        shareObject.webpageUrl = kCardQueryBaseUrl;
        //分享消息对象设置分享内容对象
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
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_webProgressLayer startLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_webProgressLayer finishedLoadWithError:nil];
    // 调用js
    NSString *str = @"iOSTestaa";
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"testFun('%@')", str]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_webProgressLayer finishedLoadWithError:error];
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    NSLog(@"shouldStartLoadWithRequest-%@", request.URL.absoluteString);
//    if ([request.URL.absoluteString containsString:@"textJS"]) {
//        [self testJS:@"js"];
//    }
//    return YES;
//}
//
//- (void)testJS:(NSString *)str {
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        picker.delegate = self;
//        picker.allowsEditing = YES;
//        [self presentViewController:picker animated:YES completion:nil];
//    }
//}

- (void)dealloc {
    [_webProgressLayer closeTimer];
    [_webProgressLayer removeFromSuperlayer];
    _webProgressLayer = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_webProgressLayer closeTimer];
    [_webProgressLayer removeFromSuperlayer];
    _webProgressLayer = nil;
}

/**
 *  设置导航栏
 */
- (void)setHomeNearNavi{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = CFont(19, 17);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"周边";
    self.navigationItem.titleView = titleLabel;
}


@end
