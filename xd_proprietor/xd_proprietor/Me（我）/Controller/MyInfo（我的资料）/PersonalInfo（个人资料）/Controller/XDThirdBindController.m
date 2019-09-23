//
//  XDThirdBindController.m
//  xd_proprietor
//
//  Created by cfsc on 2019/7/5.
//  Copyright © 2019年 zc. All rights reserved.
//

#import "XDThirdBindController.h"
#import <UMShare/UMShare.h>
#import <UIButton+WebCache.h>
#import "XDThirdInfoModel.h"

@interface XDThirdBindController ()
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UILabel *qqNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *qqCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
@property (weak, nonatomic) IBOutlet UILabel *weixinNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *weixinCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (nonatomic, strong) XDThirdInfoModel *qqModel;
@property (nonatomic, strong) XDThirdInfoModel *weixinModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *whiteViewWidthConstant;

@end

@implementation XDThirdBindController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([XDUtil isIPad]) {
        [XDUtil changeMultiplierOfConstraint:self.whiteViewWidthConstant multiplier:0.5];
    }
    [self refreshUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)refreshUI {
    self.qqModel = nil;
    self.weixinModel = nil;
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    if (loginModel.thirdInfo) {
        // 如果有绑定
        for (XDThirdInfoModel *model in loginModel.thirdInfo) {
            if ([model.type isEqualToString:@"1"]) {
                self.qqModel = model;
            } else if ([model.type isEqualToString:@"0"]) {
                self.weixinModel = model;
            }
        }
        if (self.qqModel) {
            [self.qqBtn sd_setImageWithURL:[NSURL URLWithString:self.qqModel.faceImg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"umsocial_qq"]];
            self.qqNameLabel.text = self.qqModel.nickname;
            self.qqCancelBtn.hidden = NO;
        } else {
            [self.qqBtn setImage:[UIImage imageNamed:@"umsocial_qq"] forState:UIControlStateNormal];
            self.qqNameLabel.text = @"QQ";
            self.qqCancelBtn.hidden = YES;
        }
        if (self.weixinModel) {
            [self.weixinBtn sd_setImageWithURL:[NSURL URLWithString:self.weixinModel.faceImg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"umsocial_wechat"]];
            self.weixinNameLabel.text = self.weixinModel.nickname;
            self.weixinCancelBtn.hidden = NO;
        } else {
            [self.weixinBtn setImage:[UIImage imageNamed:@"umsocial_wechat"] forState:UIControlStateNormal];
            self.weixinNameLabel.text = @"微信";
            self.weixinCancelBtn.hidden = YES;
        }
    } else {
        // 没绑定
        self.qqCancelBtn.hidden = YES;
        self.weixinCancelBtn.hidden = YES;
    }
}

- (IBAction)qqBindAction:(id)sender {
    [MBProgressHUD showActivityMessageInWindow:nil];
    WEAKSELF
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            [MBProgressHUD hideHUD];
            [XDUtil showToast:@"获取QQ信息失败！"];
            return;
        }
        UMSocialUserInfoResponse *resp = result;
        __block XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
        if (!loginModel.userInfo.mobileNumber) {
            [MBProgressHUD hideHUD];
            [XDUtil showToast:@"用户不存在！"];
            return;
        }
        NSDictionary *dic = @{
                              @"nickname":resp.name,
                              @"accountId":resp.uid,
                              @"sex":resp.unionGender,
                              @"type":@"1",
                              @"faceImg":resp.iconurl,
                              @"phoneNo":loginModel.userInfo.mobileNumber
                              };
        [[XDAPIManager sharedManager] requestLinkThirdPartyAccountWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
            [MBProgressHUD hideHUD];
            if (error) {
                [XDUtil showToast:@"绑定QQ失败！"];
                return;
            }
            if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
                [XDUtil showToast:@"绑定QQ成功！"];
                [weakSelf updateOwnerInfo];
            } else {
                [XDUtil showToast:[NSString stringWithFormat:@"%@", responseObject[@"msg"]]];
            }
        }];
    }];
}

- (IBAction)qqCancelAction:(id)sender {
    if (!self.qqModel) {
        [self refreshUI];
        return;
    }
    NSDictionary *dic = @{
                          @"accountId": self.qqModel.accountId,
                          @"type": @"1"
                          };
    [MBProgressHUD showActivityMessageInWindow:nil];
    WEAKSELF
    [[XDAPIManager sharedManager] requestDeleteThirdPartyAccountWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [XDUtil showToast:@"QQ解绑失败！"];
            return;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            [XDUtil showToast:@"QQ解绑成功！"];
            [weakSelf updateOwnerInfo];
        } else {
            [XDUtil showToast:[NSString stringWithFormat:@"%@", responseObject[@"msg"]]];
        }
    }];
}

- (IBAction)weixinBindAction:(id)sender {
    [MBProgressHUD showActivityMessageInWindow:nil];
    WEAKSELF
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            [MBProgressHUD hideHUD];
            [XDUtil showToast:@"获取微信信息失败！"];
            return;
        }
        UMSocialUserInfoResponse *resp = result;
        __block XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
        if (!loginModel.userInfo.mobileNumber) {
            [MBProgressHUD hideHUD];
            [XDUtil showToast:@"用户不存在！"];
            return;
        }
        NSDictionary *dic = @{
                              @"nickname":resp.name,
                              @"accountId":resp.uid,
                              @"sex":resp.unionGender,
                              @"type":@"0",
                              @"faceImg":resp.iconurl,
                              @"phoneNo":loginModel.userInfo.mobileNumber
                              };
        [[XDAPIManager sharedManager] requestLinkThirdPartyAccountWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
            [MBProgressHUD hideHUD];
            if (error) {
                [XDUtil showToast:@"绑定微信失败！"];
                return;
            }
            if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
                [XDUtil showToast:@"绑定微信成功！"];
                [weakSelf updateOwnerInfo];
            } else {
                [XDUtil showToast:[NSString stringWithFormat:@"%@", responseObject[@"msg"]]];
            }
        }];
    }];
}

- (IBAction)weixinCancelAction:(id)sender {
    if (!self.weixinModel) {
        [self refreshUI];
        return;
    }
    NSDictionary *dic = @{
                          @"accountId": self.weixinModel.accountId,
                          @"type": @"0"
                          };
    [MBProgressHUD showActivityMessageInWindow:nil];
    WEAKSELF
    [[XDAPIManager sharedManager] requestDeleteThirdPartyAccountWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [XDUtil showToast:@"微信解绑失败！"];
            return;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            [XDUtil showToast:@"微信解绑成功！"];
            [weakSelf updateOwnerInfo];
        } else {
            [XDUtil showToast:[NSString stringWithFormat:@"%@", responseObject[@"msg"]]];
        }
    }];
}

- (IBAction)okAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)updateOwnerInfo {
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    if (!loginModel.userInfo.mobileNumber) {
        return;
    }
    NSDictionary *dic = @{
                          @"mobileNumber":loginModel.userInfo.mobileNumber
                          };
    WEAKSELF
    [[XDAPIManager sharedManager] updateOwnerInfoParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        if (error) {
            return;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            XDLoginUseModel *newLoginModel = [XDLoginUseModel mj_objectWithKeyValues:responseObject[@"data"]];
            [XDReadLoginModelTool save:newLoginModel];
            [weakSelf refreshUI];
        } else {
        }
    }];
}


@end
