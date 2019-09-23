//
//  XDHomeTableViewCell.h
//  XD业主
//
//  Created by zc on 2017/6/19.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDHomeTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLablels;
/**
 *  图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
/**
 *  详细文字
 */
@property (weak, nonatomic) IBOutlet UILabel *detailLabels;

@end
