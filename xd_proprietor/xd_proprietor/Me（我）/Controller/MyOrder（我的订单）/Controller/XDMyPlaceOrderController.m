//
//  XDMyPlaceOrderController.m
//  XD业主
//
//  Created by zc on 2018/3/15.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDMyPlaceOrderController.h"
#import "XDMyPlaceOrderCell.h"
#import "XDMyOrderResultModel.h"
#import "XDMyOrderModel.h"
#import "XDMyOrderDetailModel.h"
#import "XDMyOrderShopModel.h"
#import "XDMyDetailOrderController.h"
#import "XDOrderPayController.h"
#import "XDOrderPayController.h"
@interface XDMyPlaceOrderController ()
{
    NSInteger _currentPage;//当前页码
}



@end

@implementation XDMyPlaceOrderController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpInit];
    
    [self loadplaceOrderList];
}

- (void)setUpInit {
    
    _currentPage = 1;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadplaceOrderList) name:@"refreshMyPlaceOrderList" object:nil];
}

- (void)loadplaceOrderList {
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSNumber *ownerid = loginModel.userInfo.userId;
    //请求数据
    NSDictionary *dic = @{
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"page":@(_currentPage),
                          @"pagesize":@PageSiz,
                          @"ownerid":ownerid,
                          @"ident":@"0",//（0已下单/1已支付/2已取消/3已完成）
                          };
    
    WEAKSELF
    [[XDAPIManager sharedManager] requestGetMyOrder:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        [MBProgressHUD hideHUD];
        XDMyOrderResultModel *model = [XDMyOrderResultModel mj_objectWithKeyValues:responseObject];
        if ([model.resultCode isEqualToString:@"0"]) {
            
            [weakSelf.orderModelArray removeAllObjects];
            if (model.data.orderDetail.count == 0) {
                weakSelf.Footer.hidden = YES;
                self.tableView.backgroundView = self.emptyOrderView;
                [weakSelf.tableView reloadData];
                return ;
            }
            if (model.data.orderDetail.count < PageSiz) {
                [weakSelf.Footer endRefreshingWithNoMoreData];
            }
            weakSelf.Footer.hidden = NO;
            [weakSelf.orderModelArray addObjectsFromArray:model.data.orderDetail];
            [weakSelf.tableView reloadData];
        }else {
            [KYRefreshView showWithStatus:@"抱歉！访问错误请重试"];
            [KYRefreshView dismissDeleyWithDuration:1];
        }
    }];
    
}

#pragma mark -- 刷新数据 -- tablView
- (void)loadRefreshNewOrderListData{
    _currentPage = 1;
    [self loadOrderList:@"head"];
}
#pragma mark -- 加载更多 -- tablView
- (void)loadMoreNewOrderListData {
    _currentPage += 1;
    [self loadOrderList:@"foot"];
}

- (void)loadOrderList:(NSString *)name {
    
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSNumber *ownerid = loginModel.userInfo.userId;
    //请求数据
    NSDictionary *dic = @{
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"page":@(_currentPage),
                          @"pagesize":@PageSiz,
                          @"ownerid":ownerid,
                          @"ident":@"0",//（0已下单/1已支付/2已取消/3已完成）
                          };
    
    WEAKSELF
    //请求网络数据
    [[XDAPIManager sharedManager] requestGetMyOrder:dic CompletionHandle:^(id responseObject, NSError *error) {

        XDMyOrderResultModel *model = [XDMyOrderResultModel mj_objectWithKeyValues:responseObject];
        if ([model.resultCode isEqualToString:@"0"]) {
            
            if ([name isEqualToString:@"foot"]) {
                [weakSelf.tableView.mj_footer endRefreshing];
                if (model.data.orderDetail.count < PageSiz) {
                    [weakSelf.Footer endRefreshingWithNoMoreData];
                }
            }
            if ([name isEqualToString:@"head"]) {
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.orderModelArray removeAllObjects];
                if (model.data.orderDetail.count == 0) {
                    weakSelf.Footer.hidden = YES;
                    self.tableView.backgroundView = self.emptyOrderView;
                    [weakSelf.tableView reloadData];
                    return ;
                }else {
                    self.tableView.backgroundView = nil;
                }
                [weakSelf.Footer resetNoMoreData];
                weakSelf.Footer.hidden = NO;
                if ( model.data.orderDetail.count < PageSiz ) {
                    [weakSelf.Footer endRefreshingWithNoMoreData];
                }
            }
            
            [weakSelf.orderModelArray addObjectsFromArray:model.data.orderDetail];
            [weakSelf.tableView reloadData];
            
        }else {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            if ([name isEqualToString:@"foot"]) {
                weakSelf.Footer.stateLabel.text = @"数据加载失败";
                _currentPage -= 1;
            }
            
        }
    }];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderModelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDMyPlaceOrderCell *cell = [XDMyPlaceOrderCell cellWithTableView:tableView];
    cell.selectionStyle = 0;
    XDMyOrderDetailModel *detailModel = self.orderModelArray[indexPath.row];
    cell.detailModel = detailModel;
    WEAKSELF
    cell.cancelClickBlock = ^{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"取消提示" message:@"您确定要取消该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf updateOrderStatus:detailModel indexPath:indexPath];
            
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    };
    
    cell.payforClickBlock = ^{
        
        XDOrderPayController *payVC = [[XDOrderPayController alloc] init];
        payVC.payMoney = [NSString stringWithFormat:@"%.2f",[detailModel.countprice floatValue]];;
        payVC.detailModel = detailModel;
        payVC.isPlaceOrder = YES;
        [self.navigationController pushViewController:payVC animated:YES];
        
//        XDMyDetailOrderController *detailVC = [[XDMyDetailOrderController alloc] init];
//        detailVC.detailModel = detailModel;
//        detailVC.isPayfor = YES;
//        [weakSelf.navigationController pushViewController:detailVC animated:YES];
        
    };
    return cell;
}

- (void)updateOrderStatus:(XDMyOrderDetailModel *)detailModel indexPath:(NSIndexPath *)indexPath {
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    //请求数据
    NSDictionary *dic = @{
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"id":@(detailModel.ids),
                          @"status":@"2",//（0已下单/1已支付/2已取消/3已完成）
                          };
    
//    WEAKSELF
    [[XDAPIManager sharedManager] requestUpdateOrderStatus:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        [MBProgressHUD hideHUD];
        XDMyOrderResultModel *model = [XDMyOrderResultModel mj_objectWithKeyValues:responseObject];
        if ([model.resultCode isEqualToString:@"0"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyCancelOrderList" object:nil];
            
            NSLog(@"----- %ld",indexPath.row);
            [self.orderModelArray removeObjectAtIndex:indexPath.row];
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
            [self.tableView reloadData];
            
            if (self.orderModelArray.count == 0) {
                self.Footer.hidden = YES;
                self.tableView.backgroundView = self.emptyOrderView;
            }
            
        }else {
            [KYRefreshView showWithStatus:@"抱歉！访问错误请重试"];
            [KYRefreshView dismissDeleyWithDuration:1];
        }
    }];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDMyDetailOrderController *detailVC = [[XDMyDetailOrderController alloc] init];
    detailVC.detailModel = self.orderModelArray[indexPath.row];
    detailVC.isPayfor = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
}
/**
 *  设置tableView每个section的head和foot
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (void)dealloc {
    NSLog(@"shifang l e");
}


@end
