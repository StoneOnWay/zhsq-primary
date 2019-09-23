//
//  XDMyDetailOrderController.m
//  XD业主
//
//  Created by zc on 2018/3/15.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDMyDetailOrderController.h"
#import "XDCreateOrderHead.h"
#import "XDGoodsListModel.h"
#import "KYShopcartBrandModel.h"
#import "XDCreateOrderFootView.h"
#import "XDMyOrderShopModel.h"
#import "XDMyDetailOrderCell.h"
#import "XDAddOrderCommentController.h"
#import "XDMyDetailCommentCell.h"
#import "XDOrderPayController.h"

@interface XDMyDetailOrderController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *orderTableView;


@end

@implementation XDMyDetailOrderController

- (UITableView *)orderTableView {
    if (!_orderTableView) {
        _orderTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_orderTableView registerClass:[XDCreateOrderHead class] forHeaderFooterViewReuseIdentifier:@"XDCreateOrderHead"];
        _orderTableView.delegate = self;
        _orderTableView.dataSource = self;
        [self.view addSubview:_orderTableView];
    }
    return _orderTableView;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    
}
- (void)setIsPayfor:(BOOL)isPayfor {
    _isPayfor = isPayfor;
    self.orderTableView.backgroundColor = backColor;
    if (isPayfor) {
        [self setUpSureOrderButton];
        _orderTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - KYTopNavH-50);
    }else {
        _orderTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - KYTopNavH);
    }
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
    [button setTitle:@"立即支付" forState:UIControlStateNormal];
    button.backgroundColor = RGB(208, 175, 107);
    [button addTarget:self action:@selector(clickSureOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, buttonY, buttonW, buttonH);
    
    [self.view addSubview:button];
}

- (void)clickSureOrderBtn:(UIButton *)sender {
    
    
    XDOrderPayController *payVC = [[XDOrderPayController alloc] init];
    payVC.payMoney = [NSString stringWithFormat:@"%.2f",[self.detailModel.countprice floatValue]];;
    payVC.detailModel = self.detailModel;
    payVC.isPlaceOrder = YES;
    [self.navigationController pushViewController:payVC animated:YES];
    
}
#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.detailModel.shopOrderDetail.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        XDMyDetailCommentCell *cell = [XDMyDetailCommentCell cellWithTableView:tableView];
        cell.selectionStyle = 0;
        XDMyOrderShopModel *shopModel = self.detailModel.shopOrderDetail[indexPath.row];
        cell.shopModel = shopModel;
        if (self.isFinish) {
            cell.btnWidth.constant = 50;
        }else {
            cell.btnWidth.constant = 0;
        }
        WEAKSELF
        cell.commentClickBlock = ^{
            
            XDAddOrderCommentController *addComment = [[XDAddOrderCommentController alloc] init];
            addComment.detailModel = weakSelf.detailModel;
            addComment.shopModel = shopModel;
            [weakSelf.navigationController pushViewController:addComment animated:YES];
        };
        
        return cell;
    }else {
        
        XDMyDetailOrderCell *cell = [XDMyDetailOrderCell cellWithTableView:tableView];
        cell.selectionStyle = 0;
        if (indexPath.section == 1) {
            cell.numLabel.text = @"订  单  号：";
            cell.detailNum.text = @"1234567890";
            cell.payTime.text = @"支付方式：";
            cell.detailTime.text = @"未支付";
            cell.collectLabel.text = @"收货方式：";
            cell.detailCollect.text = @"自提";
        }else {
            cell.numLabel.text = @"下单时间：";
            cell.detailNum.text = self.detailModel.createtime;
            cell.payTime.text = @"支付时间";
            cell.detailTime.text = @"未支付";
            cell.collectLabel.text = @"收货时间：";
            cell.detailCollect.text = @"未收货";
        }
        return cell;
    }
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        XDCreateOrderHead *orderHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"XDCreateOrderHead"];
            XDMyOrderShopModel *shopModel = self.detailModel.shopOrderDetail.firstObject;
            orderHeaderView.titleString = shopModel.homeName;
        
        return orderHeaderView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40;
    }
    return 10;
}

/**
 *  设置tableView每个section的head和foot
 */

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        XDCreateOrderFootView *orderFootView = [XDCreateOrderFootView footerViewWithTableView:tableView];
        orderFootView.countString = [NSString stringWithFormat:@"¥ %.2f",[self.detailModel.countprice floatValue]];
        return orderFootView;
    }
    return nil;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 40;
    }
    return 0.001;
}



@end
