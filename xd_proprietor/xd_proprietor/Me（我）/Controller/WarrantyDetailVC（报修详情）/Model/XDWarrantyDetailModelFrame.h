//
//  XDWarrantyDetailModelFrame.h
//  XD业主
//
//  Created by zc on 2017/6/22.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDWarrantyDetailModel.h"

@interface XDWarrantyDetailModelFrame : NSObject

/**
 *  数据模型
 */
@property (nonatomic ,strong) XDWarrantyDetailModel *warrantyModel;


//描述（水管质量差）Frame
@property (nonatomic ,assign) CGRect titleFrame;
//报单地址 Frame
@property (nonatomic ,assign) CGRect addressFrame;
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
