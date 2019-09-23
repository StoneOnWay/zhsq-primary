//
//  XDOpenClokController.m
//  XD业主
//
//  Created by zc on 2017/7/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDOpenClokController.h"
#import "UIImageView+WebCache.h"
#import "XDCardInfoModel.h"
#import "XDCardPageModel.h"
#import "XDResponseModel.h"
#import "XDPersonInfoModel.h"
#import <UIImageView+WebCache.h>
#import "XDVisitModel.h"
#import <JMessage/JMessage.h>

@interface XDOpenClokController ()<CustomAlertViewDelegate>
{
    int _index;
    NSArray *_codeArray;
    BOOL _isLeader;
}
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (weak, nonatomic) IBOutlet UIView *remindLabel;

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@end

@implementation XDOpenClokController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"开锁";
    [self loadCodeImage];
//    [self loadCodeImageWithPhoneNum];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"openLClokImageData"];
}

- (void)loadCodeImage {
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *cardNo = loginModel.userInfo.cardNo;
    if (!cardNo) {
        [XDUtil showToast:@"用户不存在！"];
        [MBProgressHUD hideHUD];
        return;
    }
    NSString *effectTime = [XDUtil getNowTimeStrWithFormatter:@"yyMMddHHmmss"];
    NSString *expireTime = [XDUtil getDateStrWithFormatter:@"yyMMddHHmmss" sinceNow:5*60];
    NSDictionary *dic = @{
                          @"cardNo":loginModel.userInfo.cardNo,
                          @"effectTime":effectTime,
                          @"expireTime":expireTime,
                          @"openTimes":@4,
                          @"visitorName":@"",
                          @"userId":loginModel.userInfo.userId,
                          };
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestVisitorQrCodeParameters:dic CompletionHandle:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            [MBProgressHUD hideHUD];
            [weakSelf clickToAlertViewTitle:@"创建失败" withDetailTitle:@"连接超时，请重试！"];
            return ;
        }
        if ([[responseObject objectForKey:@"code"] longLongValue] == 200) {
            NSDictionary *data = responseObject[@"data"];
            NSString *codeUrl = data[@"qrCodeUrl"];
            [self.codeImage sd_setImageWithURL:[NSURL URLWithString:codeUrl] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [MBProgressHUD hideHUD];
            }];
        } else {
            [XDUtil showToast:@"获取开锁二维码失败！"];
            [MBProgressHUD hideHUD];
        }
    }];
}

- (void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:window.bounds WithTitle:title andDetail:detailTitle andBody:nil andCancelTitle:nil andOtherTitle:@"知道了" andIsOneBtn:YES];
    [window addSubview:alertView];
}

- (IBAction)codeBtnClick:(UIButton *)sender {
    [self loadCodeImage];
//    [self loadCodeImageWithPhoneNum];
}

#pragma mark - ISC
- (void)loadCodeImageWithPhoneNum {
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    if (!loginModel.userInfo.mobileNumber) {
        return;
    }
    [MBProgressHUD showActivityMessageInWindow:nil];
    // 根据手机号码获取人员唯一标识
    NSDictionary *dic = @{
                          @"phoneNo":loginModel.userInfo.mobileNumber,
                          };
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestPersonInfoWithPhoneNumParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        if (error) {
            [MBProgressHUD hideHUD];
            [weakSelf clickToAlertViewTitle:@"创建失败" withDetailTitle:@"连接超时，请重试！"];
            return ;
        }
        XDResponseModel *response = [XDResponseModel mj_objectWithKeyValues:responseObject];
        if ([response.code isEqualToString:@"0"]) {
            XDPersonInfoModel *personInfo = [XDPersonInfoModel mj_objectWithKeyValues:response.data];
            if (personInfo.personId) {
                [weakSelf queryCardNoWithPersonId:personInfo.personId];
            } else {
                [MBProgressHUD hideHUD];
                [weakSelf clickToAlertViewTitle:@"创建失败" withDetailTitle:@"创建二维码失败，请重试！"];
            }
        } else {
            [MBProgressHUD hideHUD];
            [weakSelf clickToAlertViewTitle:@"创建失败" withDetailTitle:@"创建二维码失败，请重试！"];
        }
    }];
}

- (void)queryCardNoWithPersonId:(NSString *)personId {
    NSDictionary *dic = @{
                          @"personIds":personId,
                          @"pageNo":@1,
                          @"pageSize":@1000,
                          };
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestCardListParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        if (error) {
            [weakSelf clickToAlertViewTitle:@"获取失败" withDetailTitle:@"获取失败，请检查网络设置！"];
            [MBProgressHUD hideHUD];
            return;
        }
        XDResponseModel *response = [XDResponseModel mj_objectWithKeyValues:responseObject];
        if ([response.code isEqualToString:@"0"]) {
            [MBProgressHUD hideHUD];
            XDCardPageModel *page = [XDCardPageModel mj_objectWithKeyValues:response.data];
            XDCardInfoModel *cardInfo = page.list[0];
            NSString *cardNo = cardInfo.cardNo;
            weakSelf.codeImage.image = [XDUtil createCodeImageView:cardNo];
        } else {
            NSLog(@"获取卡片ID失败! msg--%@", response.msg);
            [MBProgressHUD hideHUD];
        }
    }];
}

@end
