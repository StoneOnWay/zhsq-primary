//
//  XDCreateOrderController.m
//  XD业主
//
//  Created by zc on 2018/3/14.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDCreateOrderController.h"
#import "XDCreateOrderHead.h"
#import "XDCreateOrderCell.h"
#import "XDGoodsListModel.h"
#import "KYShopcartBrandModel.h"
#import "XDCreateOrderFootView.h"
#import "XDOrderPayController.h"
#import "XDMyOrderDetailModel.h"

@interface XDCreateOrderController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *orderTableView;

/** 模型 */
@property (nonatomic, strong) XDMyOrderDetailModel *detailModel;

@end

@implementation XDCreateOrderController

- (UITableView *)orderTableView {
    if (!_orderTableView) {
        _orderTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - KYTopNavH-50);
        [_orderTableView registerClass:[XDCreateOrderHead class] forHeaderFooterViewReuseIdentifier:@"XDCreateOrderHead"];
        _orderTableView.delegate = self;
        _orderTableView.dataSource = self;
        [self.view addSubview:_orderTableView];
    }
    return _orderTableView;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"订单";
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
    button.titleLabel.font = SFont(16);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"确认下单" forState:UIControlStateNormal];
    button.backgroundColor = RGB(208, 175, 107);
    [button addTarget:self action:@selector(clickSureOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, buttonY, buttonW, buttonH);
    
    [self.view addSubview:button];
}

- (void)clickSureOrderBtn:(UIButton *)sender {
    
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSNumber *userid = loginModel.userInfo.userId;
    
    KYShopcartProductModel *cartModel = self.cartModelArray.firstObject;
    NSInteger cartid = cartModel.cartid;
    NSInteger homeid = cartModel.homeid;
     NSMutableString *goodsids = [NSMutableString string];
    float countprice = 0.f;
    for (KYShopcartProductModel *cartModel in self.cartModelArray) {
        NSString *countIds = [NSString stringWithFormat:@"%ld=%ld,",cartModel.ids,cartModel.count];
        [goodsids appendString:countIds];
        countprice += cartModel.count *[cartModel.discountprice floatValue];
    }
    NSString *finalPrice = [NSString stringWithFormat:@"%0.2f",countprice];
    [goodsids deleteCharactersInRange:NSMakeRange(goodsids.length-1, 1)];
    
    NSDictionary *dic = @{
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"userid":userid,
                          @"cartid":@(cartid),
                          @"goodsids":goodsids,
                          @"homeid":@(homeid),
                          @"countprice":finalPrice,
                          
                          };
    
    
    WEAKSELF
    [MBProgressHUD showActivityMessageInWindow:nil];
    //请求网络数据
    [[XDAPIManager sharedManager] requestCreateOrder:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        [MBProgressHUD hideHUD];
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            XDMyOrderDetailModel *model = [XDMyOrderDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.detailModel = model;
            sender.userInteractionEnabled = NO;
            sender.backgroundColor = [UIColor lightGrayColor];
            [weakSelf setUpWithAddIsSuccess:YES];
            if (self.refreshCart) {
                self.refreshCart();
            }
            
        }else if ([responseObject[@"resultCode"] isEqualToString:@"1"]) {
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD dismissWithDelay:1.0];
        
        }else {
            
            [weakSelf setUpWithAddIsSuccess:NO];

        }
     
    }];
    
}
#pragma mark - 下单成功
- (void)setUpWithAddIsSuccess:(BOOL)isSuccess{
    
    if (isSuccess) {
        
        XDOrderPayController *payVC = [[XDOrderPayController alloc] init];
        payVC.payMoney = self.totalString;
        payVC.detailModel = self.detailModel;
        [self.navigationController pushViewController:payVC animated:YES];
        
    }else {
        [SVProgressHUD showErrorWithStatus:@"下单失败,请重试~"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD dismissWithDelay:1.0];
    }
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.shopModelArray.count? self.shopModelArray.count:self.cartModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XDCreateOrderCell *cell = [XDCreateOrderCell cellWithTableView:tableView];
    if (self.shopModelArray.count != 0) {
        cell.listModel = self.shopModelArray[indexPath.row];
    }else {
        cell.cartModel = self.cartModelArray[indexPath.row];

    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    XDCreateOrderHead *orderHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"XDCreateOrderHead"];
    if (self.shopModelArray.count != 0) {
        XDGoodsListModel *listModel = self.shopModelArray.firstObject;
        orderHeaderView.titleString = listModel.shopType.name;
    }else {
        KYShopcartProductModel *cartModel = self.cartModelArray.firstObject;
        orderHeaderView.titleString = cartModel.homename;
    }
    
    return orderHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 40;
}

/**
 *  设置tableView每个section的head和foot
 */

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    XDCreateOrderFootView *orderFootView = [XDCreateOrderFootView footerViewWithTableView:tableView];
    orderFootView.countString = self.totalString;
    
    return orderFootView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}



@end
