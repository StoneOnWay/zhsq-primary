//
//  XDMyCancelOrderCell.h
//  XD业主
//
//  Created by zc on 2018/3/15.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDMyOrderDetailModel.h"

@interface XDMyCancelOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *payWayLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabels;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** 模型 */
@property (nonatomic, copy) XDMyOrderDetailModel *detailModel;

@end
