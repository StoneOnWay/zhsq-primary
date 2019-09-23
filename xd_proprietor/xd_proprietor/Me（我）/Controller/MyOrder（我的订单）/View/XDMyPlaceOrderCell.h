//
//  XDMyPlaceOrderCell.h
//  XD业主
//
//  Created by zc on 2018/3/15.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDMyOrderDetailModel.h"

@interface XDMyPlaceOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *payWayLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabels;
@property (weak, nonatomic) IBOutlet UIButton *payforBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** 抢购取消订单回调 */
@property (nonatomic, copy) dispatch_block_t cancelClickBlock;

/** 抢购立即支付回调 */
@property (nonatomic, copy) dispatch_block_t payforClickBlock;

/** 模型 */
@property (nonatomic, copy) XDMyOrderDetailModel *detailModel;
@end
