//
//  XDMyOrderCommentController.h
//  XD业主
//
//  Created by zc on 2018/3/16.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDMyOrderEmptyView.h"

@interface XDMyOrderCommentController : UITableViewController

@property (nonatomic ,strong)MJRefreshAutoNormalFooter *Footer;

@property (nonatomic, strong) XDMyOrderEmptyView *emptyOrderView;

//数据信息
@property (nonatomic, strong) NSMutableArray *orderModelArray;

- (void)loadRefreshNewOrderListData;

- (void)loadMoreNewOrderListData;


@end
