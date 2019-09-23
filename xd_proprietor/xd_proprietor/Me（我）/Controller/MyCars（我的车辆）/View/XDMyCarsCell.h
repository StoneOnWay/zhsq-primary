//
//  XDMyCarsCell.h
//  XD业主
//
//  Created by zc on 2017/7/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDMyCarsCell : UITableViewCell

//汽车名字
@property (weak, nonatomic) IBOutlet UILabel *carName;
//汽车车牌
@property (weak, nonatomic) IBOutlet UILabel *carNumber;

@property (weak, nonatomic) IBOutlet UIView *linView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
