//
//  XDOrderPayController.m
//  XD业主
//
//  Created by zc on 2018/4/24.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDOrderPayController.h"
#import "XDOrderPayCell.h"
#import "XDMyOrderResultModel.h"
#import "SDPaymentTool.h"
#import "XDShoppingCartController.h"
#import "DCTabBarController.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

@interface XDOrderPayController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *orderTableView;
@property (strong, nonatomic) NSMutableArray *payWayArray;

@property (strong, nonatomic) UIButton *payBtn;

@property (assign, nonatomic) NSInteger isSelectRow;

@end

@implementation XDOrderPayController
- (NSMutableArray *)payWayArray {
    if (!_payWayArray) {
        _payWayArray = [NSMutableArray array];
    }
    return _payWayArray;
}
- (UITableView *)orderTableView {
    if (!_orderTableView) {
        _orderTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - KYTopNavH-50);
        _orderTableView.delegate = self;
        _orderTableView.dataSource = self;
        [self.view addSubview:_orderTableView];
    }
    return _orderTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支付";
    self.isSelectRow = 0;
    self.orderTableView.backgroundColor = backColor;
    [self setUpSureOrderButton];
}

#pragma mark - 下单
- (void)setUpSureOrderButton
{
    CGFloat buttonW = kScreenWidth;
    CGFloat buttonH = 50;
    CGFloat buttonY = kScreenHeight - buttonH -KYTopNavH;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payBtn = button;
    button.titleLabel.font = SFont(16);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSString *titles = [NSString stringWithFormat:@"确认支付：¥ %@ 元",self.payMoney];
    [button setTitle:titles forState:UIControlStateNormal];
    button.backgroundColor = RGB(208, 175, 107);
    [button addTarget:self action:@selector(clickSureOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, buttonY, buttonW, buttonH);
    [self.view addSubview:button];
}

- (void)clickSureOrderBtn:(UIButton *)sender {
    
//    [[SDPaymentTool sharedSDPaymentTool] WechatPayWithMoney:@"1" OrderName:@"测试商品" OrderNumber:@"12345667"];
//
//
//    return;
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSString *StringIP = [self deviceIPAdress];
    float orderPrice = [self.payMoney floatValue]*100 ;
    NSString *finalPrice = [NSString stringWithFormat:@"%.0f",orderPrice];
    //请求数据
    NSDictionary *dic = @{
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"payid":@(self.detailModel.ids),
                          @"totalFee":finalPrice,
                          @"spbillCreateIp":StringIP,
                          @"ownerid":self.detailModel.userid,
                          @"phonetype":@"IOS",
                          @"type":@"1",//（0：物业费，1是商城支付）
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
                
                if (self.isPlaceOrder) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyPlaceOrderList" object:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }else {
                    [self popToWhichViewVC];
                }
            }];
            
        }else {
            
            [SVProgressHUD showErrorWithStatus:@"请求失败,请重试~"];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD dismissWithDelay:1.0];
        }
    }];
    
}

- (void)popToWhichViewVC {
    NSArray *temArray = self.navigationController.viewControllers;
    for(UIViewController *temVC in temArray) {
        
        if ([temVC isKindOfClass:[XDShoppingCartController class]] || [temVC isKindOfClass:[DCTabBarController class]])
            
        {
            [self.navigationController popToViewController:temVC animated:YES];
        }
        
    }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XDOrderPayCell *cell = [XDOrderPayCell cellWithTableView:tableView];
    cell.selectionStyle = 0;
    if (indexPath.row == 0) {
        cell.iconImage.image = [UIImage imageNamed:@"weixin"];
        cell.payName.text = @"微信支付";
    }else {
        cell.iconImage.image = [UIImage imageNamed:@"zhifubao"];
        cell.payName.text = @"支付宝支付";
    }
    cell.iconBtn.selected = NO;
    if (self.isSelectRow == indexPath.row) {
        cell.iconBtn.selected = YES;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.isSelectRow = indexPath.row;
    [self.orderTableView reloadData];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}
- (void)dealloc {
    
    NSLog(@"zhifu--------");
}
@end
