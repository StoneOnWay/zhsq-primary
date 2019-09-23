//
//  XDVisitorListController.m
//  xd_proprietor
//
//  Created by stone on 29/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDVisitorListController.h"
#import "XDVisitListCell.h"
#import "XDNewVisitController.h"
#import "XDVisitDetailController.h"
#import "XDVisitListModel.h"
#import "XDVisitModel.h"

#define TABLEVIEW_TOP_INSET 15

@interface XDVisitorListController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listModelArray;
@property (nonatomic, assign) int currentPage;
@end

@implementation XDVisitorListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"访客邀约";
    [self prepareVisitTableView];
    [self getUserVisitHistoryList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNoticeAction) name:@"refreshVisitList" object:nil];
}

- (void)getNoticeAction {
    if (self.listModelArray.count != 0) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
    [self getUserVisitHistoryList];
}

- (void)prepareVisitTableView
{
    self.tableView.contentInset = UIEdgeInsetsMake(TABLEVIEW_TOP_INSET, 0, 0, 0);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 0.0f;
    self.tableView.backgroundColor = litterBackColor;
    self.tableView.separatorStyle = 0;
    self.tableView.backgroundColor = litterBackColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"XDVisitListCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"XDVisitListCell"];
    
    MJRefreshNormalHeader *Header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getUserVisitHistoryList)];
    Header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = Header;
    [self.tableView.mj_header endRefreshing];
    
    MJRefreshAutoNormalFooter *Footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreVisitData)];
    self.tableView.mj_footer = Footer;
    Footer.hidden = YES;
}

- (NSMutableArray *)listModelArray {
    if (!_listModelArray) {
        self.listModelArray = [NSMutableArray array];
    }
    return _listModelArray;
}

- (void)loadMoreVisitData {
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *userId = [NSString stringWithFormat:@"%@", loginModel.userInfo.userId];
    NSNumber *cardNo = loginModel.userInfo.cardNo.numberValue;
    if (!userId || !cardNo) {
        [XDUtil showToast:@"用户登录失效！"];
        return;
    }
    self.currentPage += 1;
    NSDictionary *dic = @{
                          @"userId":userId,
                          @"cardNo":cardNo,
                          @"pageNo":@(self.currentPage),
                          @"pageSize":@(PageSiz)
                          };
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestVisitHistoryListParameters:dic CompletionHandle:^(NSDictionary *responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [XDUtil showToast:@"获取访客历史记录失败！"];
            self.currentPage -= 1;
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
            if ([responseObject[@"code"] intValue] == 200) {
                NSArray *result = responseObject[@"resultList"];
                if (result.count < PageSiz) {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                for (NSDictionary *dic in result) {
                    XDVisitModel *visit = [[XDVisitModel alloc] init];
                    visit.expireTime = dic[@"expireTime"];
                    visit.effectTime = dic[@"effectTime"];
                    visit.codeUrlStr = dic[@"qrCodeUrl"];
                    visit.visitorName = dic[@"visitorName"];
                    visit.effectNum = [dic[@"openTimes"] intValue];
                    [weakSelf dealModelEffective:visit];
                    [weakSelf.listModelArray addObject:visit];
                }
                [weakSelf.tableView reloadData];
            } else {
                [XDUtil showToast:@"获取访客历史记录失败了！"];
                self.currentPage -= 1;
            }
        }
    }];
}

- (void)getUserVisitHistoryList {
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *userId = [NSString stringWithFormat:@"%@", loginModel.userInfo.userId];
    NSNumber *cardNo = loginModel.userInfo.cardNo.numberValue;
    if (!userId || !cardNo) {
        [XDUtil showToast:@"用户登录失效！"];
        return;
    }
    self.currentPage = 1;
    NSDictionary *dic = @{
                          @"userId":userId,
                          @"cardNo":cardNo,
                          @"pageNo":@(self.currentPage),
                          @"pageSize":@(PageSiz)
                          };
    [self.tableView.mj_footer resetNoMoreData];
    [MBProgressHUD showActivityMessageInWindow:nil];
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestVisitHistoryListParameters:dic CompletionHandle:^(NSDictionary *responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [XDUtil showToast:@"获取访客历史记录失败！"];
            [self.tableView.mj_header endRefreshing];
        } else {
            if ([responseObject[@"code"] intValue] == 200) {
                [weakSelf.listModelArray removeAllObjects];
                NSArray *result = responseObject[@"resultList"];
                if (result.count < PageSiz) {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                for (NSDictionary *dic in result) {
                    XDVisitModel *visit = [[XDVisitModel alloc] init];
                    visit.expireTime = dic[@"expireTime"];
                    visit.effectTime = dic[@"effectTime"];
                    visit.codeUrlStr = dic[@"qrCodeUrl"];
                    visit.visitorName = dic[@"visitorName"];
                    visit.effectNum = [dic[@"openTimes"] intValue];
                    [weakSelf dealModelEffective:visit];
                    [weakSelf.listModelArray addObject:visit];
                }
                [weakSelf.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                weakSelf.tableView.mj_footer.hidden = NO;
            } else {
                NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
                [XDUtil showToast:message];
                [self.tableView.mj_header endRefreshing];
            }
        }
    }];
}

- (IBAction)visitAciton:(id)sender {
    XDNewVisitController *newVisit = [[XDNewVisitController alloc] init];
    [self.navigationController pushViewController:newVisit animated:YES];
}

- (void)dealModelEffective:(XDVisitModel *)model {
    NSDate *date = [NSDate dateWithString:model.expireTime format:VISIT_DATE_FORMATTER];
    NSTimeInterval t1 = [date timeIntervalSince1970];
    NSTimeInterval t2 = [[NSDate date] timeIntervalSince1970];
    if (t1 > t2) {
        model.iseffective = @"1";
    } else {
        model.iseffective = @"0";
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDVisitListCell *cell = [XDVisitListCell cellWithTableView:tableView];
    XDVisitModel *model = self.listModelArray[indexPath.row];
    cell.nameLabels.text = model.visitorName;
    cell.timeLabels.text = [NSString stringWithFormat:@"有效期：%@",model.expireTime];
    if ([model.iseffective isEqualToString:@"1"]) {
        cell.isOutUse.text = @"有效";
    } else {
        cell.isOutUse.text = @"已作废";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XDVisitDetailController *detail = [[XDVisitDetailController alloc] init];
    XDVisitModel *model = self.listModelArray[indexPath.row];
    detail.visitModel = model;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
