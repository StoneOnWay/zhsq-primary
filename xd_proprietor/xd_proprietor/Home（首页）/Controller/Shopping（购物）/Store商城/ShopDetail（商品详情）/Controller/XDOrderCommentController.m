//
//  XDOrderCommentController.m
//  XD业主
//
//  Created by zc on 2018/3/22.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDOrderCommentController.h"
#import "XDOrderCommentCell.h"
#import "XDOrderCommentModel.h"

#define pageSizes 20


@interface XDOrderCommentController ()
{
    NSInteger _currentPage;//当前页码
}

@property (nonatomic ,strong)MJRefreshAutoNormalFooter *Footer;
@end

@implementation XDOrderCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentPage = 1;
    self.navigationItem.title = @"评价";
    self.tableView.separatorStyle = 0;
    self.view.backgroundColor = backColor;
    
    [self prepareTableViewRefresh];

}

//准备刷新控件--tableView
- (void)prepareTableViewRefresh
{
    
    MJRefreshNormalHeader *Header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshCommentNewListData)];
    Header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = Header;
    [self.tableView.mj_header endRefreshing];
    
    MJRefreshAutoNormalFooter *Footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCommentNewListData)];
    self.Footer = Footer;
    self.tableView.mj_footer = Footer;
    [self.tableView.mj_footer endRefreshing];
    if (self.dataArray.count < pageSizes) {
        [Footer endRefreshingWithNoMoreData];
    }
}

#pragma mark -- 刷新数据 -- tablView
- (void)loadRefreshCommentNewListData {
    
    _currentPage = 1;
    [self MJNewList:@"head"];
    
}
#pragma mark -- 加载更多 -- tablView
- (void)loadMoreCommentNewListData {
    
    _currentPage += 1;
    [self MJNewList:@"foot"];
    
}
- (void)MJNewList:(NSString *)name {
    
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    //请求数据
    NSDictionary *dic = @{
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"goodsId" : @(self.shopModel.ids),
                          @"page":@(_currentPage),
                          @"pagesize":@pageSizes
                          };
    
    WEAKSELF
    //请求网络数据
    [[XDAPIManager sharedManager] requestGetCommentData:dic CompletionHandle:^(id responseObject, NSError *error) {
        
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
            
            NSArray *dicArray = responseObject[@"data"][@"comments"];
            if ([name isEqualToString:@"foot"]) {
                [weakSelf.tableView.mj_footer endRefreshing];
                if (dicArray.count < pageSizes) {
                    [weakSelf.Footer endRefreshingWithNoMoreData];
                }
            }
            if ([name isEqualToString:@"head"]) {
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.dataArray removeAllObjects];
                [weakSelf.Footer resetNoMoreData];
                if (dicArray.count < pageSizes) {
                    [weakSelf.Footer endRefreshingWithNoMoreData];
                }
            }
            
            for (int i = 0; i<dicArray.count; i++) {
                XDOrderCommentModel *model = [XDOrderCommentModel mj_objectWithKeyValues:dicArray[i]];
                [weakSelf.dataArray addObject:model];
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XDOrderCommentCell *cell = [XDOrderCommentCell cellWithTableView:tableView];
    cell.selectionStyle = 0;
    cell.isCommentList = YES;
    cell.commentModel = self.dataArray[indexPath.row];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XDOrderCommentModel *model = self.dataArray.firstObject;
    return [self evaluteCellHeight:model.content];
}

- (CGFloat)evaluteCellHeight:(NSString *)evaluteString {
    
    CGFloat Width = kScreenWidth - WMargin * 2;
    CGSize evaluteLabelSize = [evaluteString boundingRectWithSize:CGSizeMake(Width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttributes context:nil].size;
    CGFloat evaluteLabelSizeH = evaluteLabelSize.height;
    
    return evaluteLabelSizeH + 90;
}
- (void)dealloc {
    
}

@end
