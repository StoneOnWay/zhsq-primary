//
//  XDOwnTableViewCell.h
//  XD业主
//
//  Created by zc on 2017/6/16.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDOwnTableViewCell : UITableViewCell
//分割线
@property (weak, nonatomic) IBOutlet UIImageView *upImageLine;

//图片
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

//文字描述
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *downImageLine;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
