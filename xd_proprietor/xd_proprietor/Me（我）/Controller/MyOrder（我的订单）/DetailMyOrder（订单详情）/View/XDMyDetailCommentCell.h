//
//  XDMyDetailCommentCell.h
//  XD业主
//
//  Created by zc on 2018/3/23.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDMyOrderShopModel.h"

@interface XDMyDetailCommentCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
//订单详情赋值
@property (nonatomic, copy) XDMyOrderShopModel *shopModel;

/** 去评价回调 */
@property (nonatomic, copy) dispatch_block_t commentClickBlock;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;

@end
