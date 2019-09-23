//
//  XDOrderPayController.h
//  XD业主
//
//  Created by zc on 2018/4/24.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDMyOrderDetailModel.h"

@interface XDOrderPayController : UIViewController

@property (strong, nonatomic) NSString *payMoney;

//是否是我的订单中已下单进入
@property (assign, nonatomic) BOOL isPlaceOrder;
/** 模型 */
@property (nonatomic, strong) XDMyOrderDetailModel *detailModel;

@end
