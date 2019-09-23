//
//  XDWarrantyDetailController.m
//  XD业主
//
//  Created by zc on 2017/6/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDWarrantyListController.h"
#import "XDMyWarrantyListCell.h"
#import "HBHomeSegmentNavigationBar.h"
#import "XDWarrantyDetailController.h"
#import "XDWarrantyScreenOutController.h"
#import "XDWarrantyListDataModel.h"
#import "XDWarrantyModel.h"
#import "XDCommonEvaluteController.h"
#import "XDSegmentedControlView.h"
#import "XDWarrantyHomeViewController.h"
#import "XDWarrantyModel.h"

@interface XDWarrantyListController()
<
UITableViewDelegate,
UITableViewDataSource,
XDWarrantyScreenOutControllerDelegate,
XDSegmentedControlViewDelegate
>

//列表（待处理）
@property (strong , nonatomic)UITableView *tableView;
//完成的当前页面
@property (assign , nonatomic)NSInteger currentPage;
//完成的数据
@property (strong , nonatomic)NSMutableArray *finishDataArr;
//mjfoot
@property (nonatomic ,strong)MJRefreshAutoNormalFooter *gifFooter;
//用来判断是进行中还是已完成
@property (assign , nonatomic)NSInteger currentIndex;

////刷选的条件
////开始时间
//@property (nonatomic ,strong)NSString *startTime1;
////结束时间
//@property (nonatomic ,strong)NSString *endTime1;
////工单类型
//@property (nonatomic ,assign)NSInteger workOrderType1;
////开始时间
//@property (nonatomic ,strong)NSString *startTime2;
////结束时间
//@property (nonatomic ,strong)NSString *endTime2;
////工单类型
//@property (nonatomic ,assign)NSInteger workOrderType2;

@end

@implementation XDWarrantyListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏
    [self setWarrantyListNavi];
    //加载子控件
    [self setUpListSubViews];
    //获取未完成数据
    [MBProgressHUD showActivityMessageInWindow:nil];
    [self loadDataIsFirstPage:YES];
//    //获取已完成数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshWarrantyList:) name:@"refreshList" object:nil];
}

- (void)loadDataIsFirstPage:(BOOL)isFirstPage {
    if (self.warrantyPageType == XDWarrantyPageTypeWorkOrder) {
        [self loadWarrantyListDataIsFirstPage:isFirstPage];
    } else {
        [self loadComplainListDataIsFirstPage:isFirstPage];
    }
}

#pragma mark -- /*评价回来后刷新数据*/
- (void)refreshWarrantyList:(NSNotification *)info {
    [self loadWarrantyListDataIsFirstPage:YES];
}

#pragma mark -- 初始化未完成的数据
- (void)loadWarrantyListDataIsFirstPage:(BOOL)isFirstPage {
    //我的报修工单列表
    __weak typeof(self) weakSelf = self;
    if (isFirstPage) {
        self.currentPage = 0;
    }
    self.currentPage++;
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    
    NSMutableDictionary *dic = @{
                                 @"handerstatu":@(self.warrantyTaskStatus),
                                 @"userId":userId,
                                 @"appTokenInfo":token,
                                 @"appMobile":appMobile,
                                 @"page":@(self.currentPage),
                                 @"pageSize":@PageSiz
                                 }.mutableCopy;
    for (NSString *key in self.parameter.allKeys) {
        [dic setObject:self.parameter[key] forKey:key];
    }

    [[XDAPIManager sharedManager]requestWorkOrderListParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        weakSelf.gifFooter.hidden = NO;
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            NSArray *dataModelArray = [NSArray modelArrayWithClass:[XDWarrantyModel class] json:responseObject[@"data"][@"repairsEntityList"]];
            XDPageModel *pageModel = [XDPageModel modelWithJSON:responseObject[@"data"][@"pagination"]];
            if (isFirstPage) {
                [weakSelf.finishDataArr removeAllObjects];
            }
            [weakSelf.finishDataArr addObjectsFromArray:dataModelArray];
            [weakSelf.gifFooter resetNoMoreData];
            if (dataModelArray.count < [pageModel.pageSize integerValue]) {
                [weakSelf.gifFooter endRefreshingWithNoMoreData];
            }
        } else {
            [weakSelf.gifFooter endRefreshingWithNoMoreData];
            weakSelf.gifFooter.stateLabel.text = @"数据加载失败";
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark -- 初始化数据
- (void)loadComplainListDataIsFirstPage:(BOOL)isFirstPage {
    //我的报修工单列表未处理---1
    __weak typeof(self) weakSelf = self;
    if (isFirstPage) {
        self.currentPage = 0;
    }
    self.currentPage++;
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSMutableDictionary *dic = @{
                                 @"disposeStatus":@(self.warrantyTaskStatus + 1),
                                 @"userId":userId,
                                 @"appTokenInfo":token,
                                 @"appMobile":appMobile,
                                 @"page":@(weakSelf.currentPage),
                                 @"pageSize":@PageSiz
                                 }.mutableCopy;
    for (NSString *key in self.parameter.allKeys) {
        [dic setObject:self.parameter[key] forKey:key];
    }
    [[XDAPIManager sharedManager]requestComplainListWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        weakSelf.gifFooter.hidden = NO;
        [MBProgressHUD hideHUD];
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            NSArray *dataModelArray = [NSArray modelArrayWithClass:[XDWarrantyModel class] json:responseObject[@"data"][@"complainEntityList"]];
            XDPageModel *pageModel = [XDPageModel modelWithJSON:responseObject[@"data"][@"pagination"]];
            if (isFirstPage) {
                [weakSelf.finishDataArr removeAllObjects];
            }
            [weakSelf.finishDataArr addObjectsFromArray:dataModelArray];
            [weakSelf.gifFooter resetNoMoreData];
            if (dataModelArray.count < [pageModel.pageSize integerValue]) {
                [weakSelf.gifFooter endRefreshingWithNoMoreData];
            }
        }else {
            [weakSelf.gifFooter endRefreshingWithNoMoreData];
            weakSelf.gifFooter.stateLabel.text = @"数据加载失败";
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)customerEnsureWarranty:(NSNumber *)repairsId andTask:(NSString *)taskid outComes:(NSString *)outCome{
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSDictionary *dic = @{@"workOrderId":repairsId,
                          @"taskId":taskid,
                          @"outcome":outCome,
                          @"userId":userId,
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          };
    
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestWarrantyCustomerEnSure:dic CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            NSArray *array = responseObject[@"data"][@"jbpmOutcomes"];
            NSString *string = [array componentsJoinedByString:@""];
            if ([string isEqualToString:@"评价"]) {
                XDCommonEvaluteController *evalute = [[XDCommonEvaluteController alloc] init];
                evalute.repairsId = repairsId;
                evalute.taskId = responseObject[@"data"][@"taskId"];
                evalute.navTitle = @"工单评价";
                [weakSelf.navigationController pushViewController:evalute animated:YES];
            }
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.finishDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDMyWarrantyListCell *cell = [XDMyWarrantyListCell cellWithTableView:tableView];
    XDWarrantyModel *dataModel = self.finishDataArr[indexPath.row];
    cell.titleLabels.text = dataModel.title;
    cell.timeLabels.text = dataModel.time;
    cell.conditionLabels.text = dataModel.status;
    if ([dataModel.status isEqualToString:@"未受理"]) {
        cell.conditionLabels.textColor = [UIColor redColor];
    }
    cell.idsLabel.text = [NSString stringWithFormat:@"编号：%@",dataModel.ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDWarrantyDetailController *detail = [[XDWarrantyDetailController alloc] init];
    __weak typeof(self) weakSelf = self;
    detail.backToRefresh = ^{
        [weakSelf loadDataIsFirstPage:YES];
    };
    XDWarrantyModel *dataModel = self.finishDataArr[indexPath.row];
    detail.repairsId = dataModel.ID;
    detail.taskid = dataModel.taskid;
    detail.warrantyPageType = self.warrantyPageType;
    //用来判断 那种操作 付费 评价还是隐藏footView
    NSArray *array = dataModel.jbpmOutcomes;
    NSString *string = [array componentsJoinedByString:@""];
    detail.jbpmOutcomes = string;
    [self.navigationController pushViewController:detail animated:YES];

//        XDWarrantyListModel *dataModel = self.finishDataArr[indexPath.row];
//        NSArray *array = dataModel.jbpmOutcomes;
//        NSString *string = [array componentsJoinedByString:@""];
//        if ([string isEqualToString:@"客户确认"]||[string isEqualToString:@"客户付费"]) {
//            [self customerEnsureWarranty:dataModel.repairsId andTask:dataModel.taskid outComes:string];
//        }else {
//            XDWarrantyDetailController *detail = [[XDWarrantyDetailController alloc] init];
//            __weak typeof(self) weakSelf = self;
//            detail.backToRefresh = ^{
//                [weakSelf loadWarrantyListFinishData];
//            };
//            detail.repairsId = dataModel.repairsId;
//            detail.taskid = dataModel.taskid;
//            detail.jbpmOutcomes = string;
//            [self.navigationController pushViewController:detail animated:YES];
//        }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

#pragma mark -- XDWarrantyScreenOutControllerDelegate
- (void)XDWarrantyScreenOutControllerWithStartTime:(NSString *)startTime endTime:(NSString *)endTime workOrderType:(NSInteger)workOrderType {
//    if (self.currentIndex == 1) {
//        self.startTime2 = startTime;
//        self.endTime2 = endTime;
//        self.workOrderType2 = workOrderType;
//        self.isScreen2 = YES;
//        [self.finishDataArr removeAllObjects];
//        //刷选已完成的数据
//        [self loadWarrantyListFinishData];
//    }else {
//        self.startTime1 = startTime;
//        self.endTime1 = endTime;
//        self.workOrderType1 = workOrderType;
//        self.isScreen1 = YES;
//        [self.unFinishDataArr removeAllObjects];
        //刷选进行中的数据
//        [self loadWarrantyListData];
//    }
}

/**
 *  设置导航栏
 */
-(void)setWarrantyListNavi{
    self.title = @"我的工单";
}

- (void)setUpListSubViews {
    //未完成的tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - NavHeight - 20.f)];
    _tableView.tag = 1;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [self prepareTableViewRefresh];
}

//准备未完成的刷新控件--tableView
- (void)prepareTableViewRefresh
{
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 0.0f;
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *gifHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataIsFirstPage:YES];
    }];
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = gifHeader;
    [_tableView.mj_header endRefreshing];
    
    MJRefreshAutoNormalFooter *gifFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataIsFirstPage:NO];
    }];
    self.gifFooter = gifFooter;
    gifFooter.hidden = YES;
    _tableView.mj_footer = gifFooter;
    [_tableView.mj_footer endRefreshing];
}

- (void)WGoScreenView {
//    XDWarrantyScreenOutController *screen = [[XDWarrantyScreenOutController alloc] init];
//    screen.delegate = self;
//    [self.navigationController pushViewController:screen animated:YES];
}

- (NSMutableArray *)finishDataArr {
    if (!_finishDataArr) {
        _finishDataArr = [NSMutableArray array];
    }
    return _finishDataArr;
}

@end
