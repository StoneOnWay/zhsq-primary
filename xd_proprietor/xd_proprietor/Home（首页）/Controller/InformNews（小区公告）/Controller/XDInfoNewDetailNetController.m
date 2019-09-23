//
//  XDInfoNewDetailNetController.m
//  XD业主
//
//  Created by zc on 2017/6/30.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDInfoNewDetailNetController.h"
#import "XDWebProgressLayer.h"
#import "XDInfoNewsToolBar.h"
#import "XDAttachmentsListController.h"
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>

@interface XDInfoNewDetailNetController ()<UIWebViewDelegate,XDInfoNewsToolBarDelegate> {
    XDInfoNewsToolBar *toolBar;
}

@property (strong, nonatomic) UIWebView *webView;

@property (nonatomic, strong) XDWebProgressLayer *webProgressLayer;  // 进度条

@property (assign, nonatomic) CGFloat MaxY;

@end

@implementation XDInfoNewDetailNetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backColor;

    //导航栏
    [self setInformNewsDetailNavi];
    
    //设置子控件
    [self setInfoSubViews];
    
    //设置网页
    [self setInfoWebView];
    
    //设置底部工具条
    [self setInfoToolBar];
    
    // 获取公告详情
    [self getNewsDeatilInfos];
    
    //更新阅读数
    [self updateCommentNum];
}

- (void)getNewsDeatilInfos {
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    if (!loginModel.userInfo.userId) {
        // 游客登录，直接使用列表界面带过来的数据
        return;
    }
    NSDictionary *dic = @{
                          @"noticeId":self.infoModel.noticeId,
                          @"ownerId":loginModel.userInfo.userId
                          };
    [MBProgressHUD showActivityMessageInWindow:nil];
    [[XDAPIManager sharedManager] requestSelectNoticesParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [XDUtil showToast:@"获取公告信息失败！"];
            return;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            self.infoModel = [XDInfoNewModel mj_objectWithKeyValues:responseObject[@"data"]];
            toolBar.commentLabel.text = [NSString stringWithFormat:@"%ld",(long)self.infoModel.reads];
            toolBar.zanLabel.text = [NSString stringWithFormat:@"%ld",self.infoModel.upNO.integerValue];
            if (self.infoModel.praises == 0) {
                toolBar.zanBtn.selected = NO;
            } else if (self.infoModel.praises == 1) {
                toolBar.zanBtn.selected = YES;
            }
        } else {
            [XDUtil showToast:@"获取公告信息失败！"];
        }
    }];
}

- (void)setInfoWebView {
    NSString *Url = [self.infoModel.detailUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", K_BASE_URL, Url]];

    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.MaxY +5, kScreenWidth, kScreenHeight-NavHeight -(self.MaxY +5) - TabbarHeight -TabbarSafeBottomMargin)];
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    [_webView sizeToFit];
    _webView.backgroundColor = backColor;
    _webView.scrollView.backgroundColor = backColor;
    NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];
    
    [_webView loadRequest:request];
    
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    _webProgressLayer = [[XDWebProgressLayer alloc] init];
    if ([XDUtil isIPad]) {
        _webProgressLayer.frame = CGRectMake(0, navHeight - 2, kScreenHeight, 2);
    } else {
        _webProgressLayer.frame = CGRectMake(0, 42, kScreenHeight, 2);
    }
    [self.navigationController.navigationBar.layer addSublayer:_webProgressLayer];
    
    [self.view addSubview:_webView];
}
    
/**
 *  设置导航栏
 */
-(void)setInformNewsDetailNavi{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = CFont(19, 17);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"公告详情";
    self.navigationItem.titleView = titleLabel;
}

- (void)setInfoSubViews {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, kScreenWidth, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.infoModel.title;
    titleLabel.font = SFont(15);
    titleLabel.textColor = RGB(79, 79, 79);
    [self.view addSubview:titleLabel];
    
    
    //发布者名字
    CGFloat titleMaxY = CGRectGetMaxY(titleLabel.frame);
    CGFloat wigth = kScreenWidth/2 -25;
    UILabel *publisherNLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, titleMaxY +25, wigth, 20)];
    publisherNLabel.textAlignment = NSTextAlignmentLeft;
    publisherNLabel.text = self.infoModel.publisherName;
    publisherNLabel.font = SFont(11);
    publisherNLabel.textColor = RGB(112, 167, 138);
    [self.view addSubview:publisherNLabel];
    
    //发布时间
    UILabel *publisherTLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth -wigth -15, titleMaxY+25, wigth, 20)];
    publisherTLabel.textAlignment = NSTextAlignmentRight;
    publisherTLabel.text = self.infoModel.publishTime;
    publisherTLabel.font = SFont(11);
    publisherTLabel.textColor = RGB(155, 155, 155);
    [self.view addSubview:publisherTLabel];
    
    self.MaxY = CGRectGetMaxY(publisherNLabel.frame);
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_webProgressLayer startLoad];
    webView.hidden = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 处理webView的宽度自适应
    NSString *js= [NSString stringWithFormat:@"changeImage(%f);function changeImage(width) {var image = document.getElementsByTagName('img');for (var i = 0; i <image.length ; i++) {var  style = getComputedStyle(image[i]);if (parseInt(style.width)>=width)  {image[i].style.width = '100%%';image[i].style.height = 'auto';}}}", kScreenWidth];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [_webProgressLayer finishedLoadWithError:nil];
    webView.hidden = NO;
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

- (void)updateCommentNum {
//    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
//    NSString *token = loginModel.token;
    //更新浏览数
    NSDictionary *dic = @{
                          /*@"appTokenInfo":token,*/
                          @"noticeId":self.infoModel.noticeId,
                          };
    
    [[XDAPIManager sharedManager] requestUpDateReadNumParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            if (self.readCountDidUpdate) {
                self.readCountDidUpdate();
            }
        }
    }];
}

/**
 *  设置底部工具条
 */
- (void)setInfoToolBar {

    CGFloat webViewMaxY = CGRectGetMaxY(self.webView.frame);
    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, webViewMaxY, kScreenWidth, 50)];
    toolBar = [[NSBundle mainBundle] loadNibNamed:@"XDInfoNewsToolBar" owner:nil options:nil].lastObject;
    toolBar.frame = backview.bounds;
    if (self.infoModel.resources.length == 0) {
        toolBar.listBtn.hidden = YES;
    }
    toolBar.delegate = self;
    [backview addSubview:toolBar];
    [self.view addSubview:backview];
    
}
#pragma mark -- toolBarDelegate
/**
 *  浏览量
 */
- (void)clickCommentBtn:(UIButton *)button {


}
/**
 *  点赞
 */
- (void)clickZanBtn:(UIButton *)button {
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    //        NSString *token = loginModel.token;
    if (!loginModel.userInfo.userId) {
        [XDUtil showToast:@"没有点赞权限，请先绑定业主！"];
        return;
    }
    if (!button.isSelected) {
        NSDictionary *dic = @{
                              /*@"appTokenInfo":token,*/
                              @"noticeId":self.infoModel.noticeId,
                              @"ownerId":loginModel.userInfo.userId
                              };
        
        [[XDAPIManager sharedManager] requestUpDateZanNumParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
            if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
                if (self.readCountDidUpdate) {
                    self.readCountDidUpdate();
                }
            } else {
                [XDUtil showToast:@"点赞失败！"];
                NSInteger zanNum = toolBar.zanLabel.text.integerValue;
                zanNum -= 1;
                toolBar.zanLabel.text = [NSString stringWithFormat:@"%ld",(long)zanNum];
                button.selected = !button.selected;
            }
        }];
    } else {
        NSDictionary *dic = @{
                              /*@"appTokenInfo":token,*/
                              @"noticeId":self.infoModel.noticeId,
                              @"ownerId":loginModel.userInfo.userId
                              };
        [[XDAPIManager sharedManager] requestDeleteNoticesUpParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
            if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
                if (self.readCountDidUpdate) {
                    self.readCountDidUpdate();
                }
            } else {
                [XDUtil showToast:@"取消点赞失败！"];
                NSInteger zanNum = toolBar.zanLabel.text.integerValue;
                zanNum += 1;
                toolBar.zanLabel.text = [NSString stringWithFormat:@"%ld",(long)zanNum];
                button.selected = !button.selected;
            }
        }];
    }
    button.selected = !button.selected;
}

/**
 *  分享
 */
- (void)clickShareBtn:(UIButton *)button {
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_QQ),
                                               /*@(UMSocialPlatformType_Sina)*/]];
    // 显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        NSString *Url = [self.infoModel.detailUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        NSString *urlStr = [NSString stringWithFormat:@"%@/%@", K_BASE_URL, Url];
        // 根据获取的platformType确定所选平台进行下一步操作
        // 创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        // 创建图片内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"通知公告" descr:self.infoModel.title thumImage:self.infoModel.noticeImg];
        shareObject.webpageUrl = urlStr;
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

/**
 *  附件列表
 */
- (void)clickListBtn:(UIButton *)button {
    
    XDAttachmentsListController *list = [[XDAttachmentsListController alloc] init];
    list.resourceArray = self.infoModel.resourceList;
    [self.navigationController pushViewController:list animated:YES];
}


@end
