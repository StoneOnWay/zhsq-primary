//
//  XDOrderCommentCell.h
//  XD业主
//
//  Created by zc on 2018/3/22.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDOrderCommentModel.h"

@interface XDOrderCommentCell : UITableViewCell

@property (nonatomic, strong) XDOrderCommentModel *commentModel;

//是否是所有评价列表
@property (nonatomic, assign) BOOL isCommentList;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (instancetype)cellWithTableView1:(UITableView *)tableView;

@end
