//
//  XDWarrantyDetailPriceCell.h
//  XD业主
//
//  Created by zc on 2017/6/23.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDWarrantyDetailPriceCell : UITableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView;

//人工费用
@property (weak, nonatomic) IBOutlet UILabel *menPrice;

//材料费用
@property (weak, nonatomic) IBOutlet UILabel *materialPrice;

//总共费用
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;

//报修类型label
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

//处理人
@property (weak, nonatomic) IBOutlet UILabel *disposeMen;

//处理状态
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;

@end
