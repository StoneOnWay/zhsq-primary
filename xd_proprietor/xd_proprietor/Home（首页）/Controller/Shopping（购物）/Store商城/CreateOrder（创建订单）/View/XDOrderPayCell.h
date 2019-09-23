//
//  XDOrderPayCell.h
//  XD业主
//
//  Created by zc on 2018/4/24.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDOrderPayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *payName;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
