//
//  XDNameEditController.m
//  xd_proprietor
//
//  Created by stone on 14/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDNameEditController.h"

@interface XDNameEditController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextFielf;

@end

@implementation XDNameEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑昵称";
    
    self.nameTextFielf.text = self.nickName;
    [self.nameTextFielf addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
}

- (void)changedTextField:(UITextField *)textField {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:(UIBarButtonItemStylePlain) target:self action:@selector(okAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)okAction {
    [self.view endEditing:YES];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    if (!appMobile || !userId || !token) {
        [XDUtil showToast:@"绑定业主后，才有权限修改昵称！"];
        return;
    }
    NSDictionary *dic = @{
                          @"appMobile" : appMobile,
                          @"appTokenInfo":token,
                          @"ownerid":userId,
                          @"nickname":self.nameTextFielf.text
                          };
    [MBProgressHUD showActivityMessageInWindow:nil];
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestEditPersonalInformationParameters:dic constructingBodyWithBlock:nil CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [XDUtil showToast:@"修改昵称失败！"];
            return ;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            [XDUtil showToast:@"修改昵称成功！"];
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:weakSelf.nameTextFielf.text forKey:@"nickName"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"nickNameChangedNoti" object:self.nameTextFielf.text userInfo:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            NSString *msg = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
            [XDUtil showToast:msg];
        }
    }];
}

@end
