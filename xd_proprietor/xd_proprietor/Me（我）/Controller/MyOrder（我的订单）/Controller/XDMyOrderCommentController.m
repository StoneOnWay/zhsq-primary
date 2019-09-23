//
//  XDMyOrderCommentController.m
//  XD业主
//
//  Created by zc on 2018/3/16.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDMyOrderCommentController.h"

@interface XDMyOrderCommentController ()

@end

@implementation XDMyOrderCommentController

- (XDMyOrderEmptyView *)emptyOrderView {
    
    if (_emptyOrderView == nil) {
        _emptyOrderView = [[XDMyOrderEmptyView alloc] init];
        _emptyOrderView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
    }
    return _emptyOrderView;
}
- (NSMutableArray *)orderModelArray {
    if (!_orderModelArray) {
        _orderModelArray = [NSMutableArray array];
    }
    return _orderModelArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = 0;
    self.view.backgroundColor = backColor;
    
    [self prepareTableViewRefresh];
}

//准备刷新控件--tableView
- (void)prepareTableViewRefresh
{
    
    MJRefreshNormalHeader *Header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshNewOrderListData)];
    Header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = Header;
    [self.tableView.mj_header endRefreshing];
    
    MJRefreshAutoNormalFooter *Footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreNewOrderListData)];
    self.Footer = Footer;
    Footer.hidden = YES;
    self.tableView.mj_footer = Footer;
    [self.tableView.mj_footer endRefreshing];
    
}

#pragma mark -- 刷新数据 -- tablView
- (void)loadRefreshNewOrderListData {
    

    
}
#pragma mark -- 加载更多 -- tablView
- (void)loadMoreNewOrderListData {
    
    
}


@end
