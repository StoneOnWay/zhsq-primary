//
//  XDComplainDetailCell.h
//  XD业主
//
//  Created by zc on 2017/6/22.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYPhotoBrowser.h"
#import "XDComplainDetailModelFrame.h"

/************这个是投诉详情中有图片的cell *************/
@interface XDComplainDetailCell : UITableViewCell

//最上的标题
@property (nonatomic, weak) UILabel *titlesLabel;
//正文详情
@property (nonatomic, weak) UILabel *textsLabel;
//时间
@property (nonatomic, weak) UILabel *timeLabel;
//进程的（已解决还是待确认）
@property (nonatomic ,assign) UILabel *finishLabel;
//照片
@property (nonatomic, weak) PYPhotosView *photosView;

@property (nonatomic,strong) XDComplainDetailModelFrame *complainFrames;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
