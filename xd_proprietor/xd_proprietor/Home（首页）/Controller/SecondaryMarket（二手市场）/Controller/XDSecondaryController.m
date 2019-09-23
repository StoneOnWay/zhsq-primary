//
//  XDSecondaryController.m
//  xd_proprietor
//
//  Created by stone on 29/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDSecondaryController.h"

@interface XDSecondaryController ()

@end

@implementation XDSecondaryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - NavHeight)];
    [self.view addSubview:webView];
    
    NSString *urlStr = nil;
    if ([self.title isEqualToString:@"二手市场"]) {
        urlStr = @"https://org.modao.cc/app/5caf71e795fc26360b51e2a84274a85c#screen=s30DFB142691554965424121";
    } else {
        urlStr = @"https://org.modao.cc/app/5caf71e795fc26360b51e2a84274a85c#screen=s0156419e993d3cde7e19fb";
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [webView loadRequest:request];
    [webView sizeToFit];
}

@end
