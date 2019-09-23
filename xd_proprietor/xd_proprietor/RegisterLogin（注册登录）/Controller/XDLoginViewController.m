//
//  XDLoginViewController.m
//  登录
//
//  Created by zc on 17/3/30.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDLoginViewController.h"
#import "MJExtension.h"
#import "JPUSHService.h"
#import <UMShare/UMShare.h>
#import "XDBannerDetailController.h"
#import "XDThirdInfoModel.h"
#import "XDSelectProjectController.h"

@interface XDLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *TelephoneTF;
@property (weak, nonatomic) IBOutlet UITextField *CodeTF;
@property (nonatomic,strong) NSString *smscode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTopConstraint;
// 发送短信按钮
@property (weak, nonatomic) IBOutlet UIButton *smsCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
// 记录倒计时
@property (nonatomic,assign) NSInteger countDownTime;
@property (nonatomic,strong)NSTimer *time;
@end

@implementation XDLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.countDownTime = 60;
    self.TelephoneTF.keyboardType = UIKeyboardTypeNumberPad;
    self.CodeTF.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.TelephoneTF.delegate = self;
    self.CodeTF.delegate = self;
    self.TelephoneTF.keyboardType = UIKeyboardTypeNumberPad;
    self.CodeTF.keyboardType = UIKeyboardTypeNumberPad;
    self.TelephoneTF.placeholder = @"请输入手机号";
    [self.TelephoneTF setValue:textsColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.TelephoneTF setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    self.CodeTF.placeholder = @"验证码";
    [self.CodeTF setValue:textsColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.CodeTF setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    UIButton *button = [self.TelephoneTF valueForKey:@"_clearButton"];
    [button setImage:[UIImage imageNamed:@"login_btn_close"] forState:UIControlStateNormal];
    _TelephoneTF.clearButtonMode = UITextFieldViewModeAlways;
    if (kScreenWidth == 320) {
        self.iconTopConstraint.constant = 50;
    }

    // 所选项目名称
    NSDictionary *curPro = [[NSUserDefaults standardUserDefaults] valueForKey:CUR_PROJECT];
    if (!curPro) {
        self.projectNameLabel.text = @"请选择小区";
    } else {
        self.projectNameLabel.text = curPro[@"projectName"];
    }
}

//获取验证码
- (IBAction)sendcode:(id)sender {
    NSDictionary *curPro = [[NSUserDefaults standardUserDefaults] valueForKey:CUR_PROJECT];
    if (!curPro) {
        [XDUtil showToast:@"请先选择小区！"];
        return;
    }
    
    [self.CodeTF becomeFirstResponder];
    self.smsCodeBtn.enabled = NO;

    NSDictionary *dic = @{@"mobile":_TelephoneTF.text};
    [[XDAPIManager sharedManager] requestsendCfSmsExtWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        if (error) {
            self.smsCodeBtn.enabled = YES;
            [self clickToAlertViewTitle:@"链接超时" withDetailTitle:@"请检查网络设置"];
            return ;
        }

        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            [self countDown];
            
        } else {
            self.smsCodeBtn.enabled = YES;
           [self clickToAlertViewTitle:@"获取验证失败" withDetailTitle:responseObject[@"msg"]];
        }
    }];
}

- (IBAction)thirdLoginWeChat:(id)sender {
    [self loginWithThirdPlatform:UMSocialPlatformType_WechatSession];
}

- (IBAction)thridLoginQQ:(id)sender {
    [self loginWithThirdPlatform:UMSocialPlatformType_QQ];
}

- (void)loginWithThirdPlatform:(UMSocialPlatformType)type {
    NSDictionary *curPro = [[NSUserDefaults standardUserDefaults] valueForKey:CUR_PROJECT];
    if (!curPro) {
        [XDUtil showToast:@"请先选择小区！"];
        return;
    }
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:type currentViewController:nil completion:^(id result, NSError *error) {
        if (!result || error) {
            return;
        }
        UMSocialUserInfoResponse *resp = result;
        // 第三方登录数据(为空表示平台未提供)
        XDLoginUseModel *model = [[XDLoginUseModel alloc] init];
        XDThirdInfoModel *thirdInfo = [[XDThirdInfoModel alloc] init];
        thirdInfo.accountId = resp.uid;
        thirdInfo.nickname = resp.name;
        thirdInfo.sex = resp.unionGender;
        thirdInfo.faceImg = resp.iconurl;
        if (type == UMSocialPlatformType_QQ) {
            thirdInfo.type = @"1";
        } else if (type == UMSocialPlatformType_WechatSession) {
            thirdInfo.type = @"0";
        }
        model.thirdInfo = @[thirdInfo];
        [XDReadLoginModelTool save:model];
        
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        [AppDelegate shareAppDelegate].tabBarViewController = [[BaseTabBarViewController alloc]init];
        window.rootViewController = [AppDelegate shareAppDelegate].tabBarViewController;
    }];
}

- (void)countDown {
    __weak typeof(self) weakSelf = self;
    [weakSelf.smsCodeBtn setTitle:@"60 (s)" forState:UIControlStateNormal];
    weakSelf.time = [NSTimer timerWithTimeInterval:1 target:weakSelf selector:@selector(countDownNumbers) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:weakSelf.time forMode:NSDefaultRunLoopMode];
}

- (void)countDownNumbers {
    self.countDownTime -=1;
    [self.smsCodeBtn setTitle:[NSString stringWithFormat:@"%ld (s)",(long)self.countDownTime] forState:UIControlStateNormal];
    if (self.countDownTime == 0) {
        [self.smsCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.smsCodeBtn.enabled = YES;
        [self.time invalidate];
        self.time = nil;
        self.countDownTime = 60;
    }
}

//判断手机号码格式是否正确
- (BOOL)valiMobile:(NSString *)mobile {
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11) {
        return NO;
    } else {
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

// 游客登录
- (IBAction)customerBtn:(UIButton *)sender {
}

// 登录
- (IBAction)login:(id)sender {
    NSDictionary *curPro = [[NSUserDefaults standardUserDefaults] valueForKey:CUR_PROJECT];
    if (!curPro) {
        [XDUtil showToast:@"请先选择小区！"];
        return;
    }
    if ([_TelephoneTF.text isEqualToString:@""]||[_CodeTF.text isEqualToString:@""]) {
        [self clickToAlertViewTitle:@"登录失败" withDetailTitle:@"请输入手机号码和验证码"];
        return;
    }
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    NSDictionary *dic = @{@"mobileNumber":_TelephoneTF.text,
                          @"vcerificationCode":_CodeTF.text};
    
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestLoginWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        if (error) {
            [weakSelf clickToAlertViewTitle:@"登录失败" withDetailTitle:@"数据请求超时，请重试！"];
            [MBProgressHUD hideHUD];
            return ;
        }
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            XDLoginUseModel *loginModel = [XDLoginUseModel mj_objectWithKeyValues:responseObject[@"data"]];
            [XDReadLoginModelTool save:loginModel];
            NSString *string = [NSString stringWithFormat:@"ZH000%@",loginModel.userInfo.userId];
            [JPUSHService setTags:nil alias:string callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
            [MBProgressHUD hideHUD];
            UIWindow *window = [[UIApplication sharedApplication].delegate window];
            [AppDelegate shareAppDelegate].tabBarViewController = [[BaseTabBarViewController alloc]init];
            window.rootViewController = [AppDelegate shareAppDelegate].tabBarViewController;
        } else {
            NSString *string = responseObject[@"msg"];
            [weakSelf clickToAlertViewTitle:@"登录失败" withDetailTitle:string];
            [MBProgressHUD hideHUD];
        }
    }];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:window.bounds WithTitle:title andDetail:detailTitle andBody:nil andCancelTitle:nil andOtherTitle:@"知道了" andIsOneBtn:YES];
    [window addSubview:alertView];
}

- (IBAction)appServiceAction:(id)sender {
    XDBannerDetailController *appService = [[XDBannerDetailController alloc] init];
    appService.detailUrl = AppServiceProtocalUrl;
    [self presentViewController:appService animated:YES completion:nil];
}

- (IBAction)selectProjectAction:(id)sender {
    XDSelectProjectController *projectVC = [[XDSelectProjectController alloc] init];
    WEAKSELF
    projectVC.didSelectedProject = ^(XDProjectModel * _Nonnull model) {
        weakSelf.projectNameLabel.text = model.name;
        K_BASE_URL = model.ip;
        NSDictionary *dic = @{
                              @"ip": model.ip,
                              @"projectName": model.name
                              };
        [[NSUserDefaults standardUserDefaults] setValue:dic forKey:CUR_PROJECT];
    };
    [self presentViewController:projectVC animated:YES completion:nil];
}

#pragma mark - 隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_TelephoneTF resignFirstResponder];
    [_CodeTF resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_TelephoneTF resignFirstResponder];
    [_CodeTF resignFirstResponder];
    return YES;
}

- (void)dealloc {
    [self.time invalidate];
    self.time = nil;
    self.countDownTime = 60;
}

@end
