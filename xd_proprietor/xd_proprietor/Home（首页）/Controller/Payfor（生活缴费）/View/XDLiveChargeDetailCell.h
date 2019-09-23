//
//  XDLiveChargeDetailCell.h
//  XD业主
//
//  Created by zc on 2017/7/25.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDLiveChargeDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *titlesLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
