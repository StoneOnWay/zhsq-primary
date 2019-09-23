//
//  XDInformNewsListController.m
//  XD业主
//
//  Created by zc on 2017/6/24.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDInformNewsListController.h"
#import "XDInformNewsListCell.h"
#import "XDInfoNewModel.h"
#import "XDInfoNewDetailNetController.h"

@interface XDInformNewsListController ()

{
    NSInteger _currentPage;//当前页码
    NSInteger _receive;
}

@property (nonatomic ,strong)MJRefreshAutoNormalFooter *Footer;
@property (nonatomic ,strong)NSMutableArray *infoArray;
@end

@implementation XDInformNewsListController

- (NSMutableArray *)infoArray {
    if (!_infoArray) {
        self.infoArray = [NSMutableArray array];
    }
    return _infoArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _receive = 1;
    _currentPage = 1;
    self.tableView.backgroundColor = backColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //请求数据
    if ([self.title isEqualToString:@"通知公告"]) {
        //添加刷新
        [self prepareTableViewRefresh];
        [self noticeNewList];
    } else if ([self.title isEqualToString:@"入伙"] || [self.title isEqualToString:@"工程进度"]) {
        [self joinList];
    }
}

- (void)joinList {
    [self.infoArray removeAllObjects];
    //    [MBProgressHUD showActivityMessageInWindow:nil];
    //    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    //    NSString *token = loginModel.token;
    //    NSString *appMobile = loginModel.userInfo.mobileNumber;
    //    NSString *projectId = loginModel.userInfo.projectId;
    //请求数据
    NSDictionary *dic = @{
                          /*@"appTokenInfo":token,
                           @"appMobile":appMobile*/
                          @"receive":@(_receive),
                          @"projectid":@"0"
                          };
    
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestFindHotAndBanner:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        //        [MBProgressHUD hideHUD];
        weakSelf.Footer.hidden = NO;
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            NSArray *dicArray = responseObject[@"data"][@"noticeList"];
            for (int i = 0; i<dicArray.count; i++) {
                XDInfoNewModel *model = [XDInfoNewModel mj_objectWithKeyValues:dicArray[i]];
                if ([weakSelf.title isEqualToString:@"工程进度"]) {
                    if (model.noticeType.intValue == 5) {
                        [weakSelf.infoArray addObject:model];
                    }
                } else if ([weakSelf.title isEqualToString:@"入伙"]) {
                    if (model.noticeType.intValue == 4) {
                        [weakSelf.infoArray addObject:model];
                    }
                }
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)noticeNewList {
    [MBProgressHUD showActivityMessageInWindow:nil];
    //    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    //    NSString *token = loginModel.token;
    //    NSString *appMobile = loginModel.userInfo.mobileNumber;
    //    NSString *projectId = loginModel.userInfo.projectId;
    //请求数据
    NSDictionary *dic = @{
                          /*@"appTokenInfo":token,
                           @"appMobile":appMobile,*/
                          @"currentPage":@(_currentPage),
                          @"pageSize":@PageSiz,
                          @"receive":@(_receive),
                          @"projectid":@"0"
                          };
    
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestFindnotice:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        [MBProgressHUD hideHUD];
        weakSelf.Footer.hidden = NO;
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            NSArray *dicArray = responseObject[@"data"][@"noticeList"];
            for (int i = 0; i<dicArray.count; i++) {
                XDInfoNewModel *model = [XDInfoNewModel mj_objectWithKeyValues:dicArray[i]];
                [weakSelf.infoArray addObject:model];
            }
            if (dicArray.count < PageSiz) {
                [weakSelf.Footer endRefreshingWithNoMoreData];
            }
            
            [weakSelf.tableView reloadData];
        } else {
            [weakSelf.Footer endRefreshingWithNoMoreData];
            weakSelf.Footer.stateLabel.text = @"数据加载失败";
        }
    }];
}

//准备刷新控件--tableView
- (void)prepareTableViewRefresh
{
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 0.0f;
    
    MJRefreshNormalHeader *Header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshNoticeNewListData)];
    Header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = Header;
    [self.tableView.mj_header endRefreshing];
    
    MJRefreshAutoNormalFooter *Footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreNoticeNewListData)];
    self.Footer = Footer;
    Footer.hidden = YES;
    self.tableView.mj_footer = Footer;
    [self.tableView.mj_footer endRefreshing];
    
}
#pragma mark -- 刷新数据 -- tablView
- (void)loadRefreshNoticeNewListData {
    
    _currentPage = 1;
    [self MJNewList:@"head"];
    
}
#pragma mark -- 加载更多 -- tablView
- (void)loadMoreNoticeNewListData {
    
    _currentPage += 1;
    [self MJNewList:@"foot"];
    
}

- (void)MJNewList:(NSString *)name {
    
    //    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    //    NSString *token = loginModel.token;
    //    NSString *appMobile = loginModel.userInfo.mobileNumber;
    //    NSString *projectId = loginModel.userInfo.projectId;
    NSDictionary *dic = @{
                          /*@"appTokenInfo":token,
                           @"appMobile":appMobile,*/
                          @"currentPage":@(_currentPage),
                          @"pageSize":@PageSiz,
                          @"receive":@(_receive),
                          @"projectid":@"0"
                          };
    
    __weak typeof(self) weakSelf = self;
    
    //请求网络数据
    [[XDAPIManager sharedManager] requestFindnotice:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        //失败了
        if (error) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            if ([name isEqualToString:@"foot"]) {
                weakSelf.Footer.stateLabel.text = @"数据加载失败";
                _currentPage -= 1;
            }
            return ;
        }
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            NSArray *dicArray = responseObject[@"data"][@"noticeList"];
            if ([name isEqualToString:@"foot"]) {
                [weakSelf.tableView.mj_footer endRefreshing];
                if (dicArray.count < PageSiz) {
                    [weakSelf.Footer endRefreshingWithNoMoreData];
                }
            }
            if ([name isEqualToString:@"head"]) {
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.infoArray removeAllObjects];
                [weakSelf.Footer resetNoMoreData];
                if (dicArray.count < PageSiz) {
                    [weakSelf.Footer endRefreshingWithNoMoreData];
                }
                weakSelf.Footer.hidden = NO;
            }
            
            for (int i = 0; i<dicArray.count; i++) {
                XDInfoNewModel *model = [XDInfoNewModel mj_objectWithKeyValues:dicArray[i]];
                [weakSelf.infoArray addObject:model];
            }
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
    return self.infoArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XDInformNewsListCell *cell = [XDInformNewsListCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    XDInfoNewModel *model = self.infoArray[indexPath.row];
    cell.titleLabels.text = model.title;
    cell.detailLabels.text = model.remark;
    cell.iconImageUrl = model.noticeImgUrl;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDInformNewsListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    XDInfoNewDetailNetController *info = [[XDInfoNewDetailNetController alloc] init];
    XDInfoNewModel *model = self.infoArray[indexPath.row];
    model.noticeImg = cell.iconImage.image;
    info.infoModel = model;
    info.readCountDidUpdate = ^{
        if ([self.title isEqualToString:@"通知公告"]) {
            [self.tableView.mj_header beginRefreshing];
        } else if ([self.title isEqualToString:@"入伙"]) {
            [self joinList];
        }
    };
    [self.navigationController pushViewController:info animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 92;
}

@end
