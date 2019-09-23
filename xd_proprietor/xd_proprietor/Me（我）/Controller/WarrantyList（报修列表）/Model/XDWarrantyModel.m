//
//  XDWarrantyModel.m
//  XD业主
//
//  Created by zc on 2017/6/26.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDWarrantyModel.h"

@implementation XDWarrantyModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"ID" : @[@"repairsId", @"complainId"],
             @"status" : @[@"repairsStatus", @"complainStatus"],
             @"time" : @[@"repairsTime", @"complainDateTime"],
             @"title" : @[@"repairsTitle", @"complainTitle"]
             };
}

@end
