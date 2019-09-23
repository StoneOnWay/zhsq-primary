//
//  XDOrderCommentController.h
//  XD业主
//
//  Created by zc on 2018/3/22.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDGoodsListModel.h"

@interface XDOrderCommentController : UITableViewController

@property (strong, nonatomic) XDGoodsListModel *shopModel;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end
