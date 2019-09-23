//
//  XDBannerDetailController.m
//  xd_proprietor
//
//  Created by stone on 10/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDBannerDetailController.h"

@interface XDBannerDetailController () <UIWebViewDelegate>

@end

@implementation XDBannerDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self.detailUrl isEqualToString:AppServiceProtocalUrl]) {
        UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, NavHeight)];
        navView.backgroundColor = RGB(44, 52, 71);
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(20, NavHeight - 40, 60, 40);
        [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:cancelBtn];
        [self.view addSubview:navView];
    }
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NavHeight, kScreenWidth, kScreenHeight - NavHeight)];
    webView.delegate = self;
    [self.view addSubview:webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.detailUrl]];
    [webView loadRequest:request];
    [webView sizeToFit];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)cancelAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 处理webView的宽度自适应
    NSString *js= [NSString stringWithFormat:@"changeImage(%f);function changeImage(width) {var image = document.getElementsByTagName('img');for (var i = 0; i <image.length ; i++) {var  style = getComputedStyle(image[i]);if (parseInt(style.width)>=width)  {image[i].style.width = '100%%';image[i].style.height = 'auto';}}}", kScreenWidth];
    [webView stringByEvaluatingJavaScriptFromString:js];
}

@end
