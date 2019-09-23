//
//  XDAttachmentsDetailController.m
//  XD业主
//
//  Created by zc on 2018/5/8.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDAttachmentsDetailController.h"
#import "XDWebProgressLayer.h"

@interface XDAttachmentsDetailController ()<UIWebViewDelegate,UIDocumentInteractionControllerDelegate,NSURLSessionTaskDelegate>

@property (strong, nonatomic)UIWebView *webView;

@property (nonatomic, strong) XDWebProgressLayer *webProgressLayer;  //  进度条

@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;

@end

@implementation XDAttachmentsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附件详情";
    
    [self setAttachWebView];
    [self downLoadFile];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_btn_screen" frame:CGRectMake(0, 0, 30, 30) target:self action:@selector(loadFile)];
}

- (void)loadFile {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *strUrl = [self.urlString stringByReplacingOccurrencesOfString:@"/upload/noticesResources" withString:@""];
    NSString *savePath = [cachePath stringByAppendingPathComponent:strUrl];
    NSURL *url = [NSURL fileURLWithPath:savePath];

    _documentInteractionController = [UIDocumentInteractionController
                                      interactionControllerWithURL:url];
    [_documentInteractionController setDelegate:self];
    [_documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}

- (void)setAttachWebView {
    NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",K_BASE_URL, self.urlString]];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    [_webView sizeToFit];
    _webView.backgroundColor = backColor;
    _webView.scrollView.backgroundColor = backColor;
    NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];
    [_webView loadRequest:request];
    
    _webProgressLayer = [[XDWebProgressLayer alloc] init];
    _webProgressLayer.frame = CGRectMake(0, 42, kScreenHeight, 2);
    [self.navigationController.navigationBar.layer addSublayer:_webProgressLayer];
    
    [self.view addSubview:_webView];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_webProgressLayer startLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 处理webView的宽度自适应
    NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.width = %f;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-15];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    [_webProgressLayer finishedLoadWithError:nil];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_webProgressLayer finishedLoadWithError:error];
}

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
 *  下载文件
 */
- (void)downLoadFile {
    // 创建一个自定义存储路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *strUrl = [self.urlString stringByReplacingOccurrencesOfString:@"/upload/noticesResources" withString:@""];
    NSString *savePath = [cachePath stringByAppendingPathComponent:strUrl];
    BOOL isFileExist = [[NSFileManager defaultManager] fileExistsAtPath:savePath];
    if (isFileExist) {
        return;
    }
    
    // 1. 创建url
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", K_BASE_URL, self.urlString];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:urlStr];
    
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    
    // 创建会话
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downLoadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            // 下载成功
            // 注意 location是下载后的临时保存路径, 需要将它移动到需要保存的位置
            NSError *saveError;
            NSURL *saveURL = [NSURL fileURLWithPath:savePath];
            // 文件复制到cache路径中
            [[NSFileManager defaultManager] copyItemAtURL:location toURL:saveURL error:&saveError];
            if (!saveError) {
                NSLog(@"保存成功");
            } else {
                NSLog(@"error is %@", saveError.localizedDescription);
            }
        } else {
            NSLog(@"error is : %@", error.localizedDescription);
        }
    }];

    // 恢复线程, 启动任务
    [downLoadTask resume];
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    // 记录下载进度
}

// 下载完成
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSError *error;
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *savePath = [cachePath stringByAppendingPathComponent:@"savename"];
    
    NSURL *saveUrl = [NSURL fileURLWithPath:savePath];
    // 通过文件管理 复制文件
    [[NSFileManager defaultManager] copyItemAtURL:location toURL:saveUrl error:&error];
    if (error) {
        NSLog(@"Error is %@", error.localizedDescription);
    }
}

@end
