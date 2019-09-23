//
//  XDMyDetailOrderController.h
//  XD业主
//
//  Created by zc on 2018/3/15.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDMyOrderDetailModel.h"

@interface XDMyDetailOrderController : UIViewController

/** 模型 */
@property (nonatomic, strong) XDMyOrderDetailModel *detailModel;

/** 判断是否是代付款 */
@property (nonatomic, assign) BOOL isPayfor;

/** 判断是否是已完成进来的 */
@property (nonatomic, assign) BOOL isFinish;

@end
