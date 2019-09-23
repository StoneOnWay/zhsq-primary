//
//  XDServeceController.m
//  XD业主
//
//  Created by zc on 2018/3/22.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDServeceController.h"
#import "DCTabBarController.h"
#import "XDShoppingCell.h"
#import "XDShoppingModel.h"

@interface XDServeceController ()

{
    NSInteger _currentPage;//当前页码
}

//@property (nonatomic ,strong)MJRefreshAutoNormalFooter *Footer;
//数据
@property (nonatomic ,strong)NSMutableArray *infoArray;

@end

@implementation XDServeceController

- (NSMutableArray *)infoArray {
    if (!_infoArray) {
        self.infoArray = [NSMutableArray array];
    }
    return _infoArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = backColor;
    self.title = @"服务";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 0.0f;
    _currentPage = 1;
    //添加刷新
    //    [self prepareTableViewRefresh];
    //请求数据
    [self loadShoppingList];
}

- (void)loadShoppingList {
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSString *projectId = loginModel.userInfo.projectId;
    //请求数据
    NSDictionary *dic = @{
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"projectId":projectId,
                          @"homeType":@"1"
                          };
    
    WEAKSELF
    [[XDAPIManager sharedManager] requestShoppingList:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        [MBProgressHUD hideHUD];
        if (error) {
            [KYRefreshView showWithStatus:@"查询失败，请检查后重试"];
            [KYRefreshView dismissDeleyWithDuration:1];
            return ;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            NSArray *dicArray = responseObject[@"data"];
            if (dicArray.count == 0) {
                [KYRefreshView showWithStatus:@"暂无数据"];
                [KYRefreshView dismissDeleyWithDuration:1];
            }
            for (int i = 0; i<dicArray.count; i++) {
                XDShoppingModel *model = [XDShoppingModel mj_objectWithKeyValues:dicArray[i]];
                [weakSelf.infoArray addObject:model];
            }
            [weakSelf.tableView reloadData];
        }else {
            [KYRefreshView showWithStatus:responseObject[@"msg"]];
            [KYRefreshView dismissDeleyWithDuration:1];
        }
    }];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.infoArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDShoppingCell *cell = [XDShoppingCell cellWithTableView:tableView];
    cell.selectionStyle = 0;
    cell.shopModel = _infoArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DCTabBarController *tabbar = [[DCTabBarController alloc] init];
    
    tabbar.shopModel = _infoArray[indexPath.row];
    [self.navigationController pushViewController:tabbar animated:YES];
}

@end
