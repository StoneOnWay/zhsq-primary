//
//  XDComplainDetailModelFrame.h
//  XD业主
//
//  Created by zc on 2017/6/22.
//  Copyright © 2017年 zc. All rights reserved.
//
/************这个是投诉详情中有图片的cellde尺寸数据模型 *************/
#import <Foundation/Foundation.h>
#import "XDComplainDetailModel.h"


@class XDComplainDetailModel;
@interface XDComplainDetailModelFrame : NSObject

/**
 *  数据模型
 */
@property (nonatomic ,strong) XDComplainDetailModel *complainModel;


//描述（水管质量差）Frame
@property (nonatomic ,assign) CGRect titleFrame;
//正文详情Frame
@property (nonatomic ,assign) CGRect textFrame;
//时间Frame
@property (nonatomic ,assign) CGRect timeFrame;
//进程的（已解决还是待确认）Frame
@property (nonatomic ,assign) CGRect finishFrame;
//图片Frame
@property (nonatomic ,assign) CGRect photoViewFrame;

/**
 *  cell高度
 */
@property (nonatomic ,assign) CGFloat cellHeight;



@end
