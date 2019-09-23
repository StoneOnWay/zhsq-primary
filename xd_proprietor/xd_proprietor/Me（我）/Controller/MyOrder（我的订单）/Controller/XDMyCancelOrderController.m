//
//  XDMyCancelOrderController.m
//  XD业主
//
//  Created by zc on 2018/3/15.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDMyCancelOrderController.h"
#import "XDMyCancelOrderCell.h"
#import "XDMyOrderResultModel.h"
#import "XDMyOrderModel.h"
#import "XDMyOrderDetailModel.h"
#import "XDMyOrderShopModel.h"
#import "XDMyDetailOrderController.h"

@interface XDMyCancelOrderController ()
{
    NSInteger _currentPage;//当前页码
}


@end

@implementation XDMyCancelOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpInit];
    
    [self loadCancelOrderList];
    
}

- (void)setUpInit {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadCancelOrderList) name:@"refreshMyCancelOrderList" object:nil];
}
- (void)loadCancelOrderList {
    
    _currentPage = 1;
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
                          @"ident":@"2",//（0已下单/1已支付/2已取消/3已完成）
                          };
    
    WEAKSELF
    [[XDAPIManager sharedManager] requestGetMyOrder:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        [MBProgressHUD hideHUD];
        XDMyOrderResultModel *model = [XDMyOrderResultModel mj_objectWithKeyValues:responseObject];
        if ([model.resultCode isEqualToString:@"0"]) {
            if (model.data.orderDetail.count == 0) {
                self.tableView.backgroundView = self.emptyOrderView;
                return ;
            }
            if (model.data.orderDetail.count < PageSiz) {
                [weakSelf.Footer endRefreshingWithNoMoreData];
            }
            weakSelf.Footer.hidden = NO;
            [weakSelf.orderModelArray removeAllObjects];
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
                          @"ident":@"2",//（0已下单/1已支付/2已取消/3已完成）
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
                    self.tableView.backgroundView = self.emptyOrderView;
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
    return self.orderModelArray.count;;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDMyCancelOrderCell *cell = [XDMyCancelOrderCell cellWithTableView:tableView];
    cell.selectionStyle = 0;
    cell.detailModel = self.orderModelArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDMyDetailOrderController *detailVC = [[XDMyDetailOrderController alloc] init];
    detailVC.detailModel = self.orderModelArray[indexPath.row];
    detailVC.isPayfor = NO;
    [self.navigationController pushViewController:detailVC animated:YES];
    
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



@end
