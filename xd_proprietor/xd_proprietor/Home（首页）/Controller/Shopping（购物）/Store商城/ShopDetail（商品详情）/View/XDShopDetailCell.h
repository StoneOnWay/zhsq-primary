//
//  XDShopDetailCell.h
//  XD业主
//
//  Created by zc on 2018/3/14.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDShopDetailCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//品牌名字
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;//现价
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//原价

@end
