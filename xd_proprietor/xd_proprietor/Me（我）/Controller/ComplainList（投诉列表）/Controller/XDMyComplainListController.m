//
//  XDMyComplainListController.m
//  XD业主
//
//  Created by zc on 2017/6/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDMyComplainListController.h"
#import "XDMyComplainListCell.h"
#import "HBHomeSegmentNavigationBar.h"
#import "XDMyComplainDetailController.h"
#import "XDComplainScreenOutController.h"
#import "XDMyComplainListDataModel.h"
#import "XDMyComplainListModel.h"


@interface XDMyComplainListController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,HBHomeSegmentNavigationBarDelegate,XDComplainScreenOutControllerDelegate>
{
    UIScrollView *_scrollView;//滑动视图
}

@property(nonatomic ,assign)BOOL unIsFinish;//未完成的时候完成
@property(nonatomic ,assign)BOOL isFinish;//完成的时候已完成

@property (strong , nonatomic)HBHomeSegmentNavigationBar * segment;//进度／详情

//列表（待处理）
@property (strong , nonatomic)UITableView *tableView1;

//列表（已处理）
@property (strong , nonatomic)UITableView *tableView2;

//未完成的数据
@property (strong , nonatomic)NSMutableArray *unFinishDataArr;

//完成的数据
@property (strong , nonatomic)NSMutableArray *finishDataArr;

//未完成的当前页面
@property (assign , nonatomic)NSInteger UnCurrentPage;

//完成的当前页面
@property (assign , nonatomic)NSInteger currentPage;

//mjfoot
@property (nonatomic ,strong)MJRefreshAutoNormalFooter *gifFooter1;
//mjfoot
@property (nonatomic ,strong)MJRefreshAutoNormalFooter *gifFooter2;

//用来判断是进行中还是已完成
@property (assign , nonatomic)NSInteger currentIndex;

//用来判断table1是否是处于刷选状态
@property (assign , nonatomic)NSInteger isScreen1;
//用来判断table2是否是处于刷选状态
@property (assign , nonatomic)NSInteger isScreen2;


//刷选的条件
//开始时间
@property (nonatomic ,strong)NSString *startTime1;
//结束时间
@property (nonatomic ,strong)NSString *endTime1;
//投诉类型
@property (nonatomic ,assign)NSInteger complainType1;
//开始时间
@property (nonatomic ,strong)NSString *startTime2;
//结束时间
@property (nonatomic ,strong)NSString *endTime2;
//投诉类型
@property (nonatomic ,assign)NSInteger complainType2;


@end

@implementation XDMyComplainListController

- (NSMutableArray *)finishDataArr {
    
    if (!_finishDataArr) {
        self.finishDataArr = [NSMutableArray array];
    }
    return _finishDataArr;
}

- (NSMutableArray *)unFinishDataArr {
    
    if (!_unFinishDataArr) {
        self.unFinishDataArr = [NSMutableArray array];
    }
    return _unFinishDataArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backColor;
    [self setComplainListNavi];
    
    [self setUpListSubViews];
    
    
    self.UnCurrentPage = 1;
    
    self.currentPage = 1;
    
    //获取未完成数据初始化数据
    [self loadComplainListUnfinishData];
    
    //获取已完成数据初始化数据
    [self loadComplainListFinishData];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshComplainList:) name:@"refreshList" object:nil];
}
#pragma mark -- /*评价回来后刷新数据*/
- (void)refreshComplainList:(NSNotification *)info {
    self.isFinish = NO;
    self.unIsFinish = NO;
    
    _segment.currentIndex = 1;
    self.currentIndex = 1;
    [_scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
    [self loadComplainListUnfinishData];
    [self loadComplainListFinishData];
    
}

#pragma mark -- 初始化未完成的数据
- (void)loadComplainListUnfinishData {
    
    //我的报修工单列表未处理---1
    __weak typeof(self) weakSelf = self;
    weakSelf.UnCurrentPage = 1;
    [weakSelf.unFinishDataArr removeAllObjects];
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    
    NSMutableDictionary *dic = @{
                                 @"disposeStatus":@"1",
                                 @"userId":userId,
                                 @"appTokenInfo":token,
                                 @"appMobile":appMobile,
                                 @"page":@(weakSelf.UnCurrentPage),
                                 @"pageSize":@PageSiz
                                 }.mutableCopy;
    
    if (self.isScreen1) {
        //处于刷选状态
        dic[@"complainTypeId"] = @(self.complainType1);
        dic[@"startTime"] = self.startTime1;
        dic[@"endTime"] = self.endTime1;
    }
   
    [[XDAPIManager sharedManager]requestComplainListWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        weakSelf.unIsFinish = YES;
        weakSelf.gifFooter1.hidden = NO;
        if (weakSelf.isFinish) {
            [MBProgressHUD hideHUD];
        }
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
        
            XDMyComplainListDataModel *dataModel = [XDMyComplainListDataModel mj_objectWithKeyValues:responseObject[@"data"]];
            [weakSelf.unFinishDataArr addObjectsFromArray:dataModel.complainEntityList];
            
            [weakSelf.gifFooter1 resetNoMoreData];
            if (dataModel.complainEntityList.count < PageSiz) {
                [weakSelf.gifFooter1 endRefreshingWithNoMoreData];
            }
        }else {
            [weakSelf.gifFooter1 endRefreshingWithNoMoreData];
            weakSelf.gifFooter1.stateLabel.text = @"数据加载失败";
        }
        [weakSelf.tableView1 reloadData];

    }];
    
}

#pragma mark -- 初始化完成的数据
- (void)loadComplainListFinishData {
    
    __weak typeof(self) weakSelf = self;
    weakSelf.UnCurrentPage = 1;
    [weakSelf.finishDataArr removeAllObjects];
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    //我的报修工单列表已处理----2
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    
    NSMutableDictionary *dic = @{
                                 @"disposeStatus":@"2",
                                 @"userId":userId,
                                 @"appTokenInfo":token,
                                 @"appMobile":appMobile,
                                 @"page":@(weakSelf.currentPage),
                                 @"pageSize":@PageSiz
                                 }.mutableCopy;
    
    if (self.isScreen2) {
        //处于刷选状态
        dic[@"complainTypeId"] = @(self.complainType2);
        dic[@"startTime"] = self.startTime2;
        dic[@"endTime"] = self.endTime2;
    }
    
    [[XDAPIManager sharedManager]requestComplainListWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        weakSelf.isFinish = YES;
        if (weakSelf.unIsFinish) {
            [MBProgressHUD hideHUD];
        }
        weakSelf.gifFooter2.hidden = NO;
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            
            XDMyComplainListDataModel *dataModel = [XDMyComplainListDataModel mj_objectWithKeyValues:responseObject[@"data"]];
            [weakSelf.finishDataArr addObjectsFromArray:dataModel.complainEntityList];
            [weakSelf.gifFooter2 resetNoMoreData];
            if (dataModel.complainEntityList.count < PageSiz) {
                [weakSelf.gifFooter2 endRefreshingWithNoMoreData];
            }
        }else {
            [weakSelf.gifFooter2 endRefreshingWithNoMoreData];
            weakSelf.gifFooter2.stateLabel.text = @"数据加载失败";
        }
        [weakSelf.tableView2 reloadData];

    }];
    
}
/**
 *  设置导航栏
 */
-(void)setComplainListNavi{
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_btn_screen" frame:CGRectMake(0, 0, 30, 30) target:self action:@selector(goScreenView)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = CFont(19, 17);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我的投诉";
    self.navigationItem.titleView = titleLabel;
}

- (void)goScreenView {
    
    XDComplainScreenOutController *screen = [[XDComplainScreenOutController alloc] init];
    screen.delegate = self;
    [self.navigationController pushViewController:screen animated:YES];

}
- (void)setUpListSubViews {
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0 + self.segment.frame.size.height,kScreenWidth,kScreenHeight)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 2, 0);
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.tag = 1000;
    [self.view addSubview:_scrollView];
    
    _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight-64-_segment.bounds.size.height)];
    _tableView1.tag = 1;
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    _tableView1.backgroundColor = backColor;
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_tableView1];
    
    _tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-64-_segment.bounds.size.height)];
    _tableView2.tag = 2;
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    _tableView2.backgroundColor = backColor;
    _tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_tableView2];
    
    [self prepareTableView1Refresh];
    [self prepareTableView2Refresh];
}

//准备未完成的刷新控件--tableView1
- (void)prepareTableView1Refresh
{
    self.tableView1.rowHeight = UITableViewAutomaticDimension;
    self.tableView1.estimatedRowHeight = 0.0f;
    
    MJRefreshNormalHeader *gifHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadComplainRefreshUnFinishedData)];
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    _tableView1.mj_header = gifHeader;
    [_tableView1.mj_header endRefreshing];
    
    MJRefreshAutoNormalFooter *gifFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComplainUnFinishedData:)];
    self.gifFooter1 = gifFooter;
    gifFooter.hidden = YES;
    _tableView1.mj_footer = gifFooter;
    [_tableView1.mj_footer endRefreshing];
}

////准备完成的刷新控件--tableView2
- (void)prepareTableView2Refresh
{
    self.tableView2.rowHeight = UITableViewAutomaticDimension;
    self.tableView2.estimatedRowHeight = 0.0f;
    
    MJRefreshNormalHeader *gifHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadComplainRefreshFinishedData)];
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    _tableView2.mj_header = gifHeader;
    [_tableView2.mj_header endRefreshing];
    
    MJRefreshAutoNormalFooter *gifFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadComplainMoreFinishedData:)];
    self.gifFooter2 = gifFooter;
    gifFooter.hidden = YES;
    _tableView2.mj_footer = gifFooter;
    [_tableView2.mj_footer endRefreshing];
    
}


#pragma mark -- 刷新未完成的数据 -- tablView1
- (void)loadComplainRefreshUnFinishedData {
    
    __weak typeof(self) weakSelf = self;
    weakSelf.UnCurrentPage = 1;
    weakSelf.isScreen1 = NO;
    //我的报修工单列表未处理---1
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    
    NSDictionary *dic = @{@"disposeStatus":@"1",
                          @"userId":userId,
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"page":@(weakSelf.UnCurrentPage),
                          @"pageSize":@PageSiz};
    
    [[XDAPIManager sharedManager]requestComplainListWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {

        [weakSelf.tableView1.mj_header endRefreshing];
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            
            [weakSelf.unFinishDataArr removeAllObjects];
            XDMyComplainListDataModel *dataModel = [XDMyComplainListDataModel mj_objectWithKeyValues:responseObject[@"data"]];
            [weakSelf.unFinishDataArr addObjectsFromArray:dataModel.complainEntityList];
            [weakSelf.gifFooter1 resetNoMoreData];
            if (dataModel.complainEntityList.count < PageSiz) {
                [weakSelf.gifFooter1 endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView1 reloadData];
        }

    }];
    
}

#pragma mark -- 加载更多完成的数据 -- tablView1
- (void)loadMoreComplainUnFinishedData:(MJRefreshAutoNormalFooter *)gifFooter {
    __weak typeof(self) weakSelf = self;
    weakSelf.UnCurrentPage += 1;

    //我的报修工单列表未处理---1
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSMutableDictionary *dic = @{
                                 @"disposeStatus":@"1",
                                 @"userId":userId,
                                 @"appTokenInfo":token,
                                 @"appMobile":appMobile,
                                 @"page":@(weakSelf.UnCurrentPage),
                                 @"pageSize":@PageSiz
                                 }.mutableCopy;
    
    if (self.isScreen1) {
        //处于刷选状态
        dic[@"complainTypeId"] = @(self.complainType1);
        dic[@"startTime"] = self.startTime1;
        dic[@"endTime"] = self.endTime1;
    }
    
    [[XDAPIManager sharedManager]requestComplainListWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        [weakSelf.tableView1.mj_footer endRefreshing];
        if (error) {
            weakSelf.UnCurrentPage -= 1;
            return ;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            
            XDMyComplainListDataModel *dataModel = [XDMyComplainListDataModel mj_objectWithKeyValues:responseObject[@"data"]];
            [weakSelf.unFinishDataArr addObjectsFromArray:dataModel.complainEntityList];
            if (dataModel.complainEntityList.count < PageSiz) {
                [gifFooter endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView1 reloadData];
        }else {
            weakSelf.UnCurrentPage -= 1;
        }
        
    }];
    
}

#pragma mark -- 刷新完成的数据 -- tablView2
- (void)loadComplainRefreshFinishedData {
    __weak typeof(self) weakSelf = self;
    weakSelf.isScreen2 = NO;
    //我的报修工单列表
    weakSelf.currentPage = 1;
    //我的报修工单列表已处理----2
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    
    NSDictionary *dic = @{@"disposeStatus":@"2",
                          @"userId":userId,
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"page":@(weakSelf.currentPage),
                          @"pageSize":@PageSiz};
    
    [[XDAPIManager sharedManager]requestComplainListWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        [weakSelf.tableView2.mj_header endRefreshing];
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            [weakSelf.finishDataArr removeAllObjects];
            XDMyComplainListDataModel *dataModel = [XDMyComplainListDataModel mj_objectWithKeyValues:responseObject[@"data"]];
            [weakSelf.finishDataArr addObjectsFromArray:dataModel.complainEntityList];
            [weakSelf.gifFooter2 resetNoMoreData];
            if (dataModel.complainEntityList.count < PageSiz) {
                [weakSelf.gifFooter2 endRefreshingWithNoMoreData];
                
            }
            [weakSelf.tableView2 reloadData];
            
        }
    }];
    
    
}


#pragma mark -- 加载更多完成的数据 -- tablView2
- (void)loadComplainMoreFinishedData:(MJRefreshAutoNormalFooter *)gifFooter {
    __weak typeof(self) weakSelf = self;
    //我的报修工单列表
    weakSelf.currentPage += 1;
    //我的报修工单列表已处理----2
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    
    NSMutableDictionary *dic = @{
                                 @"disposeStatus":@"2",
                                 @"userId":userId,
                                 @"appTokenInfo":token,
                                 @"appMobile":appMobile,
                                 @"page":@(weakSelf.currentPage),
                                 @"pageSize":@PageSiz
                                 }.mutableCopy;
    
    if (self.isScreen1) {
        //处于刷选状态
        dic[@"complainTypeId"] = @(self.complainType2);
        dic[@"startTime"] = self.startTime2;
        dic[@"endTime"] = self.endTime2;
    }
    
    [[XDAPIManager sharedManager]requestComplainListWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        [weakSelf.tableView2.mj_footer endRefreshing];
        if (error) {
            weakSelf.currentPage -= 1;
            return ;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            
            XDMyComplainListDataModel *dataModel = [XDMyComplainListDataModel mj_objectWithKeyValues:responseObject[@"data"]];
            [weakSelf.finishDataArr addObjectsFromArray:dataModel.complainEntityList];
            
            if (dataModel.complainEntityList.count < PageSiz) {
                [weakSelf.tableView2.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView2 reloadData];
            
        }else {
            weakSelf.currentPage -= 1;
        }
    }];
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGRect segmentRect = self.segment.frame;
    segmentRect.size.width = kScreenWidth;
    self.segment.frame = segmentRect;
    
}

- (HBHomeSegmentNavigationBar *)segment{
    if (!_segment) {
        _segment = [[HBHomeSegmentNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35) items:@[@"处理中",@"已完成"] withDelegate:self];
        _segment.backgroundColor = backColor;
        _segment.deSelectColor = BianKuang;//选中时的颜色
        _segment.defualtCololr =[UIColor grayColor];//不选择颜色
        _segment.currentIndex = 0;//默认定位在
        [self.view addSubview:_segment];
    }
    return _segment;
}
#pragma mark - UIScrollViewDelegate
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 1000) {
        CGPoint point = self.segment.lineView.frame.origin;
        
        if (scrollView.contentSize.width !=0) {
            point.x = self.segment.bounds.size.width* (scrollView.contentOffset.x/scrollView.contentSize.width);
            if (point.x >=0 &&point.x <= kScreenWidth/2) {
                self.segment.pointX = point.x;
            }
            
        }
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 1000) {
        CGPoint point = self.segment.lineView.frame.origin;
        
        self.segment.currentIndex = (long)point.x/(long)self.segment.lineView.bounds.size.width;
        self.currentIndex = self.segment.currentIndex;
    }
    
}

#pragma mark - HBHomeSegmentNavigationBarDelegate
- (void)deSelectIndex:(NSInteger)index withSegmentBar:(HBHomeSegmentNavigationBar *)segmentBar{
    
    self.currentIndex = index;
    [_scrollView setContentOffset:CGPointMake(kScreenWidth*index, 0) animated:YES];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView1) {
        return self.unFinishDataArr.count;
    }else {
        
        return self.finishDataArr.count;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _tableView1) {
        
        XDMyComplainListCell *cell = [XDMyComplainListCell cellWithTableView:tableView];
        XDMyComplainListModel *model = self.unFinishDataArr[indexPath.row];
        cell.titleLabels.text = model.complainTitle;
        cell.timeLabels.text = model.complainDateTime;
        cell.conditionLabels.text = model.complainStatus;
        if ([model.complainStatus isEqualToString:@"未受理"]) {
            cell.conditionLabels.textColor = [UIColor redColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
        
    }else {
        
        XDMyComplainListCell *cell = [XDMyComplainListCell cellWithTableView:tableView];
        XDMyComplainListModel *dataModel = self.finishDataArr[indexPath.row];
        cell.titleLabels.text = dataModel.complainTitle;
        cell.timeLabels.text = dataModel.complainDateTime;
        cell.conditionLabels.text = dataModel.complainStatus;
        
        cell.conditionLabels.textColor = RGB(69, 145, 107);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _tableView1) {
        
        XDMyComplainDetailController *detail = [[XDMyComplainDetailController alloc] init];
        __weak typeof(self) weakSelf = self;
        detail.backToRefresh = ^{
//            [weakSelf.tableView1.mj_header beginRefreshing];
            [weakSelf loadComplainListUnfinishData];
        };
        
        XDMyComplainListModel *dataModel = self.unFinishDataArr[indexPath.row];
        NSArray *array = dataModel.jbpmOutcomes;
        NSString *string = [array componentsJoinedByString:@""];
        detail.jbpmOutcomes = string;
        detail.taskid = dataModel.taskid;
        detail.complainId = dataModel.complainId;
        detail.piid = dataModel.piid;
        [self.navigationController pushViewController:detail animated:YES];
        
    }else {
        
        XDMyComplainDetailController *detail = [[XDMyComplainDetailController alloc] init];
        __weak typeof(self) weakSelf = self;
        detail.backToRefresh = ^{
//            [weakSelf.tableView2.mj_header beginRefreshing];
            [weakSelf loadComplainListFinishData];
        };
        XDMyComplainListModel *dataModel = self.finishDataArr[indexPath.row];
        NSArray *array = dataModel.jbpmOutcomes;
        NSString *string = [array componentsJoinedByString:@""];
        detail.jbpmOutcomes = string;
        detail.taskid = dataModel.taskid;
        detail.complainId = dataModel.complainId;
        detail.piid = dataModel.piid;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
    
}

#pragma mark -- XDComplainScreenOutControllerDelegate
- (void)XDComplainScreenOutControllerWithStartTime:(NSString *)startTime endTime:(NSString *)endTime complainType:(NSInteger)complainType {

    if (self.currentIndex == 1) {
        self.startTime2 = startTime;
        self.endTime2 = endTime;
        self.complainType2 = complainType;
        self.isScreen2 = YES;
        [self.finishDataArr removeAllObjects];
        //刷选已完成的数据
        [self loadComplainListFinishData];
    }else {
        self.startTime1 = startTime;
        self.endTime1 = endTime;
        self.complainType1 = complainType;
        self.isScreen1 = YES;
        [self.unFinishDataArr removeAllObjects];
        //刷选进行中的数据
        [self loadComplainListUnfinishData];
    }

    
}


@end
