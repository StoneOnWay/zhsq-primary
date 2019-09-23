//
//  XDPayforListController.m
//  XD业主
//
//  Created by zc on 2017/11/14.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDPayforListController.h"
#import "HBHomeSegmentNavigationBar.h"
#import "XDPayforListCell.h"
#import "XDPayforScreenController.h"
#import "XDPayforDetailController.h"
#import "XDLoginUserRoomInfoModel.h"
#import "XDPayforDataModel.h"
#import "XDPayforModel.h"


@interface XDPayforListController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,HBHomeSegmentNavigationBarDelegate,XDPayforScreenControllerDelegate>

{
    UIScrollView *_scrollView;//滑动视图 
}
@property(nonatomic ,assign)BOOL unIsFinish;//未完成的时候完成
@property(nonatomic ,assign)BOOL isFinish;//完成的时候已完成
//列表（待处理）
@property (strong , nonatomic)UITableView *tableView1;

//列表（已处理）
@property (strong , nonatomic)UITableView *tableView2;


@property (strong , nonatomic)HBHomeSegmentNavigationBar * segment;//进度／详情

//未完成的当前页面
@property (assign , nonatomic)NSInteger UnCurrentPage;

//完成的当前页面
@property (assign , nonatomic)NSInteger currentPage;

//未完成的数据
@property (strong , nonatomic)NSMutableArray *unFinishDataArr;

//完成的数据
@property (strong , nonatomic)NSMutableArray *finishDataArr;
//mjfoot
@property (nonatomic ,strong)MJRefreshAutoNormalFooter *gifFooter1;
//mjfoot
@property (nonatomic ,strong)MJRefreshAutoNormalFooter *gifFooter2;

//用来判断是进行中还是已完成
@property (assign , nonatomic)NSInteger currentIndex;

//用来判断table1是否是处于刷选状态
@property (assign , nonatomic)BOOL isScreen1;
//用来判断table2是否是处于刷选状态
@property (assign , nonatomic)BOOL isScreen2;

//刷选的条件
//开始时间
@property (nonatomic ,strong)NSString *startTime1;
//结束时间
@property (nonatomic ,strong)NSString *endTime1;

//开始时间
@property (nonatomic ,strong)NSString *startTime2;
//结束时间
@property (nonatomic ,strong)NSString *endTime2;

@end

@implementation XDPayforListController

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
    
    [self setPayforListNavi];
    
    [self setUpListSubViews];

    [self loadUnPayListData];
    
    [self loadPayforListData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllData) name:@"refreshPayforList" object:nil];
    
}

- (void)refreshAllData {
    
    self.unIsFinish = NO;
    self.isFinish = NO;
    self.currentIndex = 1;
    [_scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
    
    [self loadUnPayListData];
    
    [self loadPayforListData];
}

- (void)loadUnPayListData {
    //我的报修工单列表
    __weak typeof(self) weakSelf = self;
    weakSelf.UnCurrentPage = 1;
    [weakSelf.unFinishDataArr removeAllObjects];
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSArray *roomidArray = loginModel.roominfo;
    if (roomidArray.count == 0) {
        return;
    }
    XDLoginUserRoomInfoModel *roomModel = roomidArray.firstObject;
    NSMutableDictionary *dic = @{
                                 @"roomid":roomModel.roomId,
                                 @"ifpay":@"0",
                                 @"appTokenInfo":token,
                                 @"appMobile":appMobile,
                                 @"page":@(weakSelf.UnCurrentPage),
                                 @"pageSize":@PageSiz
                                 }.mutableCopy
    ;
    if (self.isScreen1) {
        //处于刷选状态
        dic[@"paydate"] = self.startTime1;
        dic[@"shouldpaydate"] = self.endTime1;
    }
    
    [[XDAPIManager sharedManager]requestPayForListParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        weakSelf.unIsFinish = YES;
        if (weakSelf.isFinish) {
            [MBProgressHUD hideHUD];
        }
        
        XDPayforModel *model = [XDPayforModel mj_objectWithKeyValues:responseObject];
        if ([model.resultCode isEqualToString:@"0"] ) {
            
            [weakSelf.unFinishDataArr addObjectsFromArray:model.data];
            if (model.data.count < PageSiz) {
                [weakSelf.gifFooter1 endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView1 reloadData];
            weakSelf.gifFooter1.hidden = NO;
        }
        
    }];

    
}

- (void)loadPayforListData {
    
    //我的报修工单列表
    __weak typeof(self) weakSelf = self;
    weakSelf.currentPage = 1;
    [weakSelf.finishDataArr removeAllObjects];
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSArray *roomidArray = loginModel.roominfo;
    if (roomidArray.count == 0) {
        return;
    }
    XDLoginUserRoomInfoModel *roomModel = roomidArray.firstObject;
    NSMutableDictionary *dic = @{
                                 @"roomid":roomModel.roomId,
                                 @"ifpay":@"1",
                                 @"appTokenInfo":token,
                                 @"appMobile":appMobile,
                                 @"page":@(weakSelf.currentPage),
                                 @"pageSize":@PageSiz
                                 }.mutableCopy
    ;
    if (self.isScreen2) {
        //处于刷选状态
        dic[@"paydate"] = self.startTime2;
        dic[@"shouldpaydate"] = self.endTime2;
    }

    [[XDAPIManager sharedManager]requestPayForListParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        weakSelf.isFinish = YES;
        if (weakSelf.unIsFinish) {
            [MBProgressHUD hideHUD];
        }
        XDPayforModel *model = [XDPayforModel mj_objectWithKeyValues:responseObject];
        if ([model.resultCode isEqualToString:@"0"] ) {
            
            [weakSelf.finishDataArr addObjectsFromArray:model.data];
            if (model.data.count < PageSiz) {
                [weakSelf.gifFooter2 endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView2 reloadData];
            weakSelf.gifFooter2.hidden = NO;
        }
    }];
    
}

/**
 *  设置导航栏
 */
-(void)setPayforListNavi{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_btn_screen" frame:CGRectMake(0, 0, 30, 30) target:self action:@selector(payGoScreenView)];
    self.navigationItem.title = @"支付列表";
    self.view.backgroundColor = backColor;
}

- (void)payGoScreenView {
    
    XDPayforScreenController *screen = [[XDPayforScreenController alloc] init];
    screen.delegate = self;
    [self.navigationController pushViewController:screen animated:YES];
}

- (void)setUpListSubViews {
    //背景scrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0 + self.segment.frame.size.height,kScreenWidth,kScreenHeight)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 2, 0);
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.tag = 1000;
    [self.view addSubview:_scrollView];
    
    //未完成的tableView
    _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight-64-_segment.bounds.size.height)];
    _tableView1.tag = 1;
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    _tableView1.backgroundColor = backColor;
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_tableView1];
    
    //已完成的tableView
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
    
    MJRefreshNormalHeader *gifHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshUnPayData)];
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    _tableView1.mj_header = gifHeader;
    [_tableView1.mj_header endRefreshing];
    
    MJRefreshAutoNormalFooter *gifFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUnPayData)];
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
    
    MJRefreshNormalHeader *gifHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshPayData)];
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    _tableView2.mj_header = gifHeader;
    [_tableView2.mj_header endRefreshing];
    
    MJRefreshAutoNormalFooter *gifFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMorePayData)];
    self.gifFooter2 = gifFooter;
    gifFooter.hidden = YES;
    _tableView2.mj_footer = gifFooter;
    [_tableView2.mj_footer endRefreshing];
    
}

#pragma mark -- 未完成的支付
/**
 *  tableView1下拉刷新
 */
- (void)loadRefreshUnPayData{
 
    __weak typeof(self) weakSelf = self;
    weakSelf.UnCurrentPage = 1;
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSArray *roomidArray = loginModel.roominfo;
    if (roomidArray.count == 0) {
        return;
    }
    XDLoginUserRoomInfoModel *roomModel = roomidArray.firstObject;
    NSDictionary *dic = @{
                          @"roomid":roomModel.roomId,
                          @"ifpay":@"0",
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"page":@(weakSelf.UnCurrentPage),
                          @"pageSize":@PageSiz
                          };
    
    [[XDAPIManager sharedManager]requestPayForListParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        [weakSelf.tableView1.mj_header endRefreshing];
        
        XDPayforModel *model = [XDPayforModel mj_objectWithKeyValues:responseObject];
        if ([model.resultCode isEqualToString:@"0"] ) {
            
            [weakSelf.unFinishDataArr removeAllObjects];
            [weakSelf.unFinishDataArr addObjectsFromArray:model.data];
            [weakSelf.gifFooter1 resetNoMoreData];
            if (model.data.count < PageSiz) {
                [weakSelf.gifFooter1 endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView1 reloadData];
            weakSelf.isScreen1 = NO;
            weakSelf.gifFooter1.hidden = NO;
        }
        
    }];
}

/**
 *  tableView1上拉加载
 */
- (void)loadMoreUnPayData{

    __weak typeof(self) weakSelf = self;
    weakSelf.UnCurrentPage += 1;
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSArray *roomidArray = loginModel.roominfo;
    if (roomidArray.count == 0) {
        return;
    }
    XDLoginUserRoomInfoModel *roomModel = roomidArray.firstObject;
    NSMutableDictionary *dic = @{
                                 @"roomid":roomModel.roomId,
                                 @"ifpay":@"0",
                                 @"appTokenInfo":token,
                                 @"appMobile":appMobile,
                                 @"page":@(weakSelf.UnCurrentPage),
                                 @"pageSize":@PageSiz
                                 }.mutableCopy
    ;
    if (self.isScreen1) {
        //处于刷选状态
        dic[@"paydate"] = self.startTime1;
        dic[@"shouldpaydate"] = self.endTime1;
    }
    
    [[XDAPIManager sharedManager]requestPayForListParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        XDPayforModel *model = [XDPayforModel mj_objectWithKeyValues:responseObject];
        if ([model.resultCode isEqualToString:@"0"] ) {
            
            [weakSelf.unFinishDataArr addObjectsFromArray:model.data];
            [weakSelf.gifFooter1 endRefreshing];
            if (model.data.count < PageSiz) {
                [weakSelf.gifFooter1 endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView1 reloadData];
            
        }else {
            weakSelf.UnCurrentPage -= 1;
            [weakSelf.gifFooter1 endRefreshing];
            
        }
        
        
    }];
}

#pragma mark -- 完成的支付
/**
 *  tableView2下拉刷新
 */
- (void)loadRefreshPayData{
    
    __weak typeof(self) weakSelf = self;
    weakSelf.currentPage = 1;
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSArray *roomidArray = loginModel.roominfo;
    if (roomidArray.count == 0) {
        return;
    }
    XDLoginUserRoomInfoModel *roomModel = roomidArray.firstObject;
    NSDictionary *dic = @{
                          @"roomid":roomModel.roomId,
                          @"ifpay":@"1",
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"page":@(weakSelf.currentPage),
                          @"pageSize":@PageSiz};
    [[XDAPIManager sharedManager]requestPayForListParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        [weakSelf.tableView2.mj_header endRefreshing];
        
        XDPayforModel *model = [XDPayforModel mj_objectWithKeyValues:responseObject];
        if ([model.resultCode isEqualToString:@"0"] ) {
            
            [weakSelf.finishDataArr removeAllObjects];
            [weakSelf.finishDataArr addObjectsFromArray:model.data];
            [weakSelf.gifFooter2 resetNoMoreData];
            if (model.data.count < PageSiz) {
                [weakSelf.gifFooter2 endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView2 reloadData];
            weakSelf.gifFooter2.hidden = NO;
            weakSelf.isScreen2 = NO;
        }
    }];
}

/**
 *  tableView2上拉加载
 */
- (void)loadMorePayData{
    
    __weak typeof(self) weakSelf = self;
    weakSelf.currentPage += 1;
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSArray *roomidArray = loginModel.roominfo;
    if (roomidArray.count == 0) {
        return;
    }
    XDLoginUserRoomInfoModel *roomModel = roomidArray.firstObject;
    NSMutableDictionary *dic = @{
                                 @"roomid":roomModel.roomId,
                                 @"ifpay":@"1",
                                 @"appTokenInfo":token,
                                 @"appMobile":appMobile,
                                 @"page":@(weakSelf.currentPage),
                                 @"pageSize":@PageSiz
                                 }.mutableCopy
    ;
    if (self.isScreen2) {
        //处于刷选状态
        dic[@"paydate"] = self.startTime2;
        dic[@"shouldpaydate"] = self.endTime2;
    }
    [[XDAPIManager sharedManager]requestPayForListParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        XDPayforModel *model = [XDPayforModel mj_objectWithKeyValues:responseObject];
        if ([model.resultCode isEqualToString:@"0"] ) {
            
            [weakSelf.finishDataArr addObjectsFromArray:model.data];
            [weakSelf.gifFooter2 endRefreshing];
            if (model.data.count < PageSiz) {
                [weakSelf.gifFooter2 endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView2 reloadData];
            
        }else {
            weakSelf.currentPage -= 1;
            [weakSelf.gifFooter2 endRefreshing];
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
        _segment = [[HBHomeSegmentNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35) items:@[@"待支付",@"已支付"] withDelegate:self];
        _segment.backgroundColor = backColor;
        _segment.deSelectColor = BianKuang;//选中时的颜色
        _segment.defualtCololr =[UIColor grayColor];//不选择颜色
        _segment.currentIndex = 0;//默认定位在
        [self.view addSubview:_segment];
    }
    return _segment;
}

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
    
    XDPayforListCell *cell = [XDPayforListCell cellWithTableView:tableView];
    cell.selectionStyle = 0;
    if (indexPath.row == 0) {
        cell.lineView.hidden = YES;
    }
    
    if (tableView == _tableView1) {
        XDPayforDataModel *dataModel = self.unFinishDataArr[indexPath.row];
        cell.dataModel = dataModel;
    }else {
        XDPayforDataModel *dataModel = self.finishDataArr[indexPath.row];
        cell.dataModel = dataModel;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XDPayforDataModel *dataModel;
    if (tableView == _tableView1) {
        dataModel = self.unFinishDataArr[indexPath.row];
    }else {
        dataModel = self.finishDataArr[indexPath.row];
    }
    XDPayforDetailController *detail = [[XDPayforDetailController alloc] init];
    detail.dataModel = dataModel;
    [self.navigationController pushViewController:detail animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
    
}

#pragma mark -- 刷选代理
- (void)XDPayforScreenControllerWithStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    
    if (self.currentIndex == 1) {
        self.startTime2 = startTime;
        self.endTime2 = endTime;
        self.isScreen2 = YES;
        //刷选已完成的数据
        [self loadPayforListData];
    }else {
        self.startTime1 = startTime;
        self.endTime1 = endTime;
        self.isScreen1 = YES;
        //刷选进行中的数据
        [self loadUnPayListData];
    }
    
    
}
















@end
