//
//  XDMyWarrantyListCell.h
//  XD业主
//
//  Created by zc on 2017/6/22.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDMyWarrantyListCell : UITableViewCell

//图片
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
//出了啥问题
@property (weak, nonatomic) IBOutlet UILabel *titleLabels;

//什么时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabels;

//状态
@property (weak, nonatomic) IBOutlet UILabel *conditionLabels;
//编号 显示id
@property (weak, nonatomic) IBOutlet UILabel *idsLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
