//
//  XDMyOrderAddressController.m
//  XD业主
//
//  Created by zc on 2018/3/16.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDMyOrderAddressController.h"

@interface XDMyOrderAddressController ()
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end

@implementation XDMyOrderAddressController

- (void)viewDidLoad {
    [super viewDidLoad];

    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
     self.addressTextView.text = loginModel.userInfo.receiptAddress;
    self.navigationItem.title = @"收货地址";
    self.view.backgroundColor = backColor;
    self.addressTextView.layer.borderColor = [BianKuang CGColor];
    self.addressTextView.layer.cornerRadius = 5;
    self.addressTextView.layer.borderWidth = 1.0;
    [self.addressTextView.layer setMasksToBounds:YES];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.addressTextView endEditing:YES];
}

- (IBAction)clickEditBtn:(UIButton *)sender {

    NSString *textString = self.addressTextView.text;
    textString = [textString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (textString.length == 0) {
        [KYRefreshView showWithStatus:@"请输入地址后提交"];
        [KYRefreshView dismissDeleyWithDuration:1];
        return;
    }
    
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSNumber *ownerId = loginModel.userInfo.userId;

    NSDictionary *dic = @{
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"ownerId":ownerId,
                          @"Address":self.addressTextView.text,
                          };
    
    WEAKSELF
    [MBProgressHUD showActivityMessageInWindow:nil];
    //请求网络数据
    [[XDAPIManager sharedManager] requestUpdateCollectOrderAddress:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        [MBProgressHUD hideHUD];
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {

            XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
            loginModel.userInfo.receiptAddress = weakSelf.addressTextView.text;
            [XDReadLoginModelTool save:loginModel];
            
            [weakSelf setUpWithAddIsSuccess:YES];

        }else {
            
            [weakSelf setUpWithAddIsSuccess:NO];
        }
    }];
    
}
#pragma mark - 地址修改成功
- (void)setUpWithAddIsSuccess:(BOOL)isSuccess{
    
    if (isSuccess) {
        [SVProgressHUD showSuccessWithStatus:@"地址修改成功~"];
    }else {
        [SVProgressHUD showErrorWithStatus:@"地址修改失败,请重试~"];
    }
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD dismissWithDelay:1.0];
}


@end
