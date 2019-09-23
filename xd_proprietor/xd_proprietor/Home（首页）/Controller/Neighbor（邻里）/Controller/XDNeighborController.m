//
//  XDNeighborController.m
//  XD业主
//
//  Created by zc on 2017/7/28.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDNeighborController.h"
#import "XDWebProgressLayer.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "XDPostMessageController.h"


@protocol JSObjcDelegate <JSExport>

- (void)backToApp;

- (void)editPost;

@end

@interface XDNeighborController ()<UIWebViewDelegate,JSObjcDelegate>

@property (strong, nonatomic)UIWebView *webView;
@property (nonatomic, strong) XDWebProgressLayer *webProgressLayer;  //  进度条
@property(nonatomic,strong)UIView *backView;
@end

@implementation XDNeighborController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //各个参数
    [self initWithParams];
    
}

/**
 *  参数
 */
- (void)initWithParams {

    self.view.backgroundColor = backColor;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    self.backView = view;
    view.backgroundColor = RGB(203, 174, 118);
    [self.view addSubview:view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //设置网页
        [self setNeighborWebView];
    });
    
}

- (void)setNeighborWebView {
    //初始化webView
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.bounces = NO;
    [self.view addSubview:self.webView];
    [self.view bringSubviewToFront:self.backView];

    //获取账号信息
    XDLoginUseModel *loginAccout = [XDReadLoginModelTool loginModel];
    NSString *ownerid = [NSString stringWithFormat:@"%@",loginAccout.userInfo.userId];
    NSString *nickname = loginAccout.userInfo.nickName;
    
    NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/nearby/index.html",K_BASE_URL]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];
    [self.webView loadRequest:request];
    
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
//    NSString *alertJS=@"window.myInfo = { id: '4504', nickname: 'id-4504'}"; //准备执行的js代码
    NSString *alertJS=[NSString stringWithFormat:@"window.myInfo = {id: '%@', nickname: '%@'};",ownerid,nickname]; //准备执行的js代码
    [context evaluateScript:alertJS];//通过oc方法调用js的alert
    
    //添加进度条
    _webProgressLayer = [[XDWebProgressLayer alloc] init];
    _webProgressLayer.frame = CGRectMake(0, 18, kScreenWidth, 2);

    [self.backView.layer addSublayer:_webProgressLayer];

    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [_webProgressLayer startLoad];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [_webProgressLayer finishedLoadWithError:nil];
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
  
    context[@"toYun"] = self;
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        
    };
    
    context[@"editPost"] = self;
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        
    };
    
    

}

- (void)backToApp {
    NSLog(@"%@",[NSThread currentThread]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}

- (void)editPost {
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        XDPostMessageController *postMess = [[XDPostMessageController alloc] init];
        postMess.refreshWebview = ^{
            //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
            JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
            NSString *alertJS=@"_getMyPostList();"; //准备执行的js代码
            [context evaluateScript:alertJS];//通过oc方法调用js的alert
            
        };
        [self.navigationController pushViewController:postMess animated:YES];
        
    });
    
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [_webProgressLayer finishedLoadWithError:error];
    
}


- (void)dealloc {
    
    [_webProgressLayer closeTimer];
    [_webProgressLayer removeFromSuperlayer];
    _webProgressLayer = nil;
}



-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    [_webProgressLayer closeTimer];
    [_webProgressLayer removeFromSuperlayer];
    _webProgressLayer = nil;
}



@end
