//
//  XDMyOrderShopModel.m
//  XD业主
//
//  Created by zc on 2018/3/15.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDMyOrderShopModel.h"

@implementation XDMyOrderShopModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ids" : @"id"};
}
+ (NSDictionary *)objectClassInArray {
    return @{@"pics":[KYShopcartResoucelistModel class]};
}

@end
