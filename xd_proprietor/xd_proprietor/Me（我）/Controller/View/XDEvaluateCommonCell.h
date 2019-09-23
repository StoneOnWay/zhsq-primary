//
//  XDEvaluateCommonCell.h
//  XD业主
//
//  Created by zc on 2017/6/23.
//  Copyright © 2017年 zc. All rights reserved.
//
/**********评价显示的cell**********/
#import <UIKit/UIKit.h>

@interface XDEvaluateCommonCell : UITableViewCell

//评价文字
@property (nonatomic ,strong)NSString *evaluteString;

// 评分的当前分数，默认为0
@property (nonatomic, assign) CGFloat currentScore;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
