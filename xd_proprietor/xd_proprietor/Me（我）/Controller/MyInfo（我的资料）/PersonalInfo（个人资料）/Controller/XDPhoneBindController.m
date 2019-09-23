//
//  XDPhoneBindController.m
//  xd_proprietor
//
//  Created by cfsc on 2019/7/4.
//  Copyright © 2019年 zc. All rights reserved.
//

#import "XDPhoneBindController.h"
#import "XDLoginUserRoomInfoModel.h"
#import "XDThirdInfoModel.h"

@interface XDPhoneBindController () <UITextFieldDelegate> {
    NSString *phoneNumStr;
    NSString *codeNumStr;
}
@property (weak, nonatomic) IBOutlet UILabel *roomInfoLable;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
// 记录倒计时
@property (nonatomic, assign) NSInteger countDownTime;
@property (nonatomic, strong) NSTimer *time;

@end

@implementation XDPhoneBindController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绑定业主";
    [self configTextField];
    self.countDownTime = 60;
}

- (void)configTextField {
    self.phoneNumTextField.delegate = self;
    self.codeTextField.delegate = self;
    self.phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.codeTextField) {
        codeNumStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (codeNumStr.length > 4) {
            return NO;
        } else if (codeNumStr.length == 4) {
            self.confirmBtn.enabled = YES;
            return YES;
        } else {
            self.confirmBtn.enabled = NO;
            return YES;
        }
    } else {
        phoneNumStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (phoneNumStr.length > 11) {
//            self.getCodeBtn.enabled = YES;
            return NO;
        } else if (phoneNumStr.length == 11) {
            if (!self.time) {
//                self.getCodeBtn.enabled = YES;
                // 获取业主信息
                [self loadOwnerInfo];
            }
            return YES;
        } else {
            self.getCodeBtn.enabled = NO;
            return YES;
        }
    }
}

- (void)loadOwnerInfo {
    NSDictionary *dic = @{
                          @"mobileNumber":phoneNumStr,
                          };
    WEAKSELF
    [[XDAPIManager sharedManager] updateOwnerInfoParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        weakSelf.roomInfoLable.hidden = NO;
        if (error) {
            weakSelf.roomInfoLable.text = @"该手机号未注册，请联系物业";
            weakSelf.getCodeBtn.enabled = NO;
            return;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            XDLoginUseModel *loginModel = [XDLoginUseModel mj_objectWithKeyValues:responseObject[@"data"]];
            XDLoginUserRoomInfoModel *model = loginModel.roominfo.firstObject;
            weakSelf.roomInfoLable.text = model.address;
            weakSelf.getCodeBtn.enabled = YES;
        } else {
            weakSelf.roomInfoLable.text = @"该手机号未注册，请联系物业";
            weakSelf.getCodeBtn.enabled = NO;
        }
    }];
}

- (IBAction)getCodeAction:(id)sender {
    [self.codeTextField becomeFirstResponder];
    self.getCodeBtn.enabled = NO;
    NSDictionary *dic = @{@"mobile":phoneNumStr};
//    WEAKSELF
    [[XDAPIManager sharedManager] requestsendCfSmsExtWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        if (error) {
            self.getCodeBtn.enabled = YES;
            [self clickToAlertViewTitle:@"链接超时" withDetailTitle:@"请检查网络设置"];
            return ;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
//            weakSelf.confirmBtn.enabled = YES;
            [self countDown];
        } else {
            self.getCodeBtn.enabled = YES;
            [self clickToAlertViewTitle:@"获取验证失败" withDetailTitle:responseObject[@"msg"]];
        }
    }];
}

- (void)countDown {
    __weak typeof(self) weakSelf = self;
    [weakSelf.getCodeBtn setTitle:@"60 (s)" forState:UIControlStateDisabled];
    weakSelf.time = [NSTimer timerWithTimeInterval:1 target:weakSelf selector:@selector(countDownNumbers) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:weakSelf.time forMode:NSDefaultRunLoopMode];
}

- (void)countDownNumbers {
    self.countDownTime -= 1;
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%ld (s)",(long)self.countDownTime] forState:UIControlStateDisabled];
    if (self.countDownTime == 0) {
        self.getCodeBtn.enabled = YES;
        [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateDisabled];
        [self.time invalidate];
        self.time = nil;
        self.countDownTime = 60;
    }
}

- (void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:window.bounds WithTitle:title andDetail:detailTitle andBody:nil andCancelTitle:nil andOtherTitle:@"知道了" andIsOneBtn:YES];
    [window addSubview:alertView];
}

- (IBAction)confirmAciton:(id)sender {
    [self.view endEditing:YES];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    if (!loginModel.thirdInfo) {
        [XDUtil showToast:@"第三方登录失败！"];
        return;
    }
    XDThirdInfoModel *thirdInfo = loginModel.thirdInfo.firstObject;
    if (!thirdInfo.nickname || !thirdInfo.accountId || !thirdInfo.sex || !thirdInfo.type || !thirdInfo.faceImg) {
        [XDUtil showToast:@"绑定失败！"];
        return;
    }
    [MBProgressHUD showActivityMessageInWindow:nil];
    NSDictionary *dic = @{
                          @"nickname":thirdInfo.nickname,
                          @"accountId":thirdInfo.accountId,
                          @"sex":thirdInfo.sex,
                          @"type":thirdInfo.type,
                          @"faceImg":thirdInfo.faceImg,
                          @"phoneNo":phoneNumStr,
                          @"vcerificationCode":codeNumStr,
                          };
    WEAKSELF
    [[XDAPIManager sharedManager] requestLinkPhoneNoWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [XDUtil showToast:@"绑定失败！"];
        } else {
            if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
                // 更新本地用户信息，回调刷新各个页面
                [weakSelf updateOwnerInfo];
            } else {
                [XDUtil showToast:[NSString stringWithFormat:@"%@", responseObject[@"msg"]]];
            }
        }
    }];
}

- (void)updateOwnerInfo {
    NSDictionary *dic = @{
                          @"mobileNumber":phoneNumStr
                          };
    [[XDAPIManager sharedManager] updateOwnerInfoParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        if (error) {
            return;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            XDLoginUseModel *newLoginModel = [XDLoginUseModel mj_objectWithKeyValues:responseObject[@"data"]];
            [XDReadLoginModelTool save:newLoginModel];
            [XDUtil showToast:@"绑定成功！"];
            // 回调刷新页面
            if (self.bindSuccessBlock) {
                self.bindSuccessBlock();
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hasBindOwnerSuccessNoti" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
        }
    }];
}

- (void)dealloc {
    [self.time invalidate];
    self.time = nil;
    self.countDownTime = 60;
}

@end
