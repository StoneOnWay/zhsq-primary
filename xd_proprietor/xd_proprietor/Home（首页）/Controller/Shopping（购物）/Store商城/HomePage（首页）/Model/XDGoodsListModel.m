//
//  XDGoodsListModel.m
//  XD业主
//
//  Created by zc on 2018/3/8.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDGoodsListModel.h"
#import "XDResourceListModel.h"

@implementation XDGoodsListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ids" : @"id",@"typeids" : @"typeid"};
}

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"resourceList" : [XDResourceListModel class]};
}

@end
