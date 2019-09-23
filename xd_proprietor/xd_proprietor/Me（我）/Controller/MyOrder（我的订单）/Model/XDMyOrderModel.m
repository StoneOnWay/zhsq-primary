//
//  XDMyOrderModel.m
//  XD业主
//
//  Created by zc on 2018/3/15.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDMyOrderModel.h"

@implementation XDMyOrderModel

+ (NSDictionary *)objectClassInArray {
    return @{@"orderDetail":[XDMyOrderDetailModel class]};
}

@end
