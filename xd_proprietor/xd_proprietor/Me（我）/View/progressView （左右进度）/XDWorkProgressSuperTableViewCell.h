//
//  XDWorkProgressSuperTableViewCell.h
//  zhangyongTest
//
//  Created by Cody on 2017/5/22.
//  Copyright © 2017年 Cody. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDWorkProgressSuperTableViewCell : UITableViewCell
//时间
@property (weak, nonatomic)  UILabel *timeLabel;
//处理情况
@property (weak, nonatomic)  UILabel *statusLabel;
//背景view小的
@property (weak, nonatomic)  UIView *statusBackView;

@property (weak, nonatomic)  UIImageView *pointImage;//那个点

//节点详情
@property (weak, nonatomic)  UILabel *remarkLabel;
//背景view大的那个
@property (weak, nonatomic)  UIView *statusBackBigView;
//处理情况 
@property (weak, nonatomic)  UILabel *statusLabel1;

@property (assign , nonatomic)BOOL isProgressive;//正在进行...


@end
