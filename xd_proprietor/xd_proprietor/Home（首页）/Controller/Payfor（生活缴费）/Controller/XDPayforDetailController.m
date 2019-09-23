//
//  XDPayforDetailController.m
//  XD业主
//
//  Created by zc on 2017/11/14.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDPayforDetailController.h"
#import "XDLiveChargeDetailCell.h"
#import "XDAddMyCarsFootView.h"
#import "APay.h"
#import "PaaCreater.h"
#import "SDPaymentTool.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

@interface XDPayforDetailController ()<APayDelegate>

@property(nonatomic ,strong)NSArray *titleArray;

@end

@implementation XDPayforDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initParams];
    
    [self setTableViewHeader];
}

- (void)initParams {
    
    self.navigationItem.title = @"缴费详情";
    self.tableView.backgroundColor = backColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.titleArray = [NSArray arrayWithObjects:@"缴费房屋：",@"缴费来源：",@"缴费类型：",@"缴费账期：",@"缴费期限：", nil];
}
- (void)setTableViewHeader {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    backView.backgroundColor = backColor;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth -30, 88)];
    titleLabel.text = [NSString stringWithFormat:@"¥ %@ 元",self.dataModel.fee];
    titleLabel.font = SFont(20);
    titleLabel.textColor = RGB(30, 30, 30);
    [backView addSubview:titleLabel];
    self.tableView.tableHeaderView = backView;
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDLiveChargeDetailCell *cell = [XDLiveChargeDetailCell cellWithTableView:tableView];
    cell.selectionStyle = 0;
    if (indexPath.row == 0) {
        cell.lineView.hidden = YES;
    }
    cell.titlesLabel.text = self.titleArray[indexPath.row];
    
    float payMoney = [self.dataModel.fee floatValue];
    switch (indexPath.row) {
        case 0:
            cell.detailsLabel.text = self.dataModel.adds;
            break;
        case 1:
            cell.detailsLabel.text = @"物业费用";
            break;
        case 2:
            if ([self.dataModel.advancetype isEqualToString:@"1"]) {
                cell.detailsLabel.text = @"补缴费";
            }else {
                cell.detailsLabel.text = @"预缴费";
            }
            
            break;
        case 3:

            cell.detailsLabel.text = [NSString stringWithFormat:@"%0.2f 元",payMoney];
            break;
        case 4:
            cell.detailsLabel.text = self.dataModel.term;
            break;
        case 5:
            cell.detailsLabel.text = self.dataModel.shouldpaydate;
            break;
        default:
            break;
    }

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    XDAddMyCarsFootView *foot = [XDAddMyCarsFootView footerViewWithTableView:tableView];
    [foot.ensureBtn setTitle:@"立即支付" forState: UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    foot.commitBlock = ^{
        
        
        [MBProgressHUD showActivityMessageInWindow:nil];
        XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
        NSString *token = loginModel.token;
        NSString *appMobile = loginModel.userInfo.mobileNumber;
        NSNumber *userid = loginModel.userInfo.userId;
        NSString *StringIP = [weakSelf deviceIPAdress];
        float orderPrice = [weakSelf.dataModel.fee floatValue]*100 ;
        NSString *finalPrice = [NSString stringWithFormat:@"%.0f",orderPrice];
        //请求数据
        NSDictionary *dic = @{
                              @"appTokenInfo":token,
                              @"appMobile":appMobile,
                              @"payid":weakSelf.dataModel.ids,
                              @"totalFee":finalPrice,
                              @"spbillCreateIp":StringIP,
                              @"ownerid":userid,
                              @"phonetype":@"IOS",
                              @"type":@"0",//（0：物业费，1是商城支付）
                              };
        
        //    WEAKSELF
        [[XDAPIManager sharedManager] requestWeixinPayParam:dic CompletionHandle:^(id responseObject, NSError *error) {
            
            [MBProgressHUD hideHUD];
            if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
                
                [[SDPaymentTool sharedSDPaymentTool] WechatPayWithParamer:responseObject[@"data"]];
                [[SDPaymentTool sharedSDPaymentTool] setSuccessBlock:^(NSString *string) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"支付成功！"];
                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                    [SVProgressHUD dismissWithDelay:1.0];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPayforList" object:nil];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    });
                    
                }];
                
            }else {
                
                [SVProgressHUD showErrorWithStatus:@"请求失败,请重试~"];
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD dismissWithDelay:1.0];
            }
        }];
        
        
    };
    
    return foot;
}


//必须在有网的情况下才能获取手机的IP地址
- (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in  *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    
    NSLog(@"%@", address);
    
    return address;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80;
}

- (void)APayResult:(NSString *)result {
    
    NSLog(@"%@", result);
    NSArray *parts = [result componentsSeparatedByString:@"="];
    NSError *error;
    NSData *data = [[parts lastObject] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSInteger payResult = [dic[@"payResult"] integerValue];
    NSString *format_string = @"支付结果::支付%@";
    if (payResult == APayResultSuccess) {
        NSLog(format_string,@"成功");
    } else if (payResult == APayResultFail) {
        NSLog(format_string,@"失败");
    } else if (payResult == APayResultCancel) {
        NSLog(format_string,@"取消");
    }
}

- (void)dealloc {
    NSLog(@"-----shifang");
}

@end
