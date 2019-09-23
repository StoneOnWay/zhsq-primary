//
//  XDPayforListCell.h
//  XD业主
//
//  Created by zc on 2017/11/14.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDPayforDataModel.h"

@interface XDPayforListCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 * 多少钱
 */
@property (weak, nonatomic) IBOutlet UILabel *muchMoney;
/**
 * 房屋
 */
@property (weak, nonatomic) IBOutlet UILabel *roomName;
/**
 * 账期
 */
@property (weak, nonatomic) IBOutlet UILabel *billTime;
/**
 * 期限
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLimit;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (strong, nonatomic) XDPayforDataModel *dataModel;
@end
