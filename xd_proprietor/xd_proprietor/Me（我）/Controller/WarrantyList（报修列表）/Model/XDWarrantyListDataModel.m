//
//  XDWarrantyListDataModel.m
//  XD业主
//
//  Created by zc on 2017/6/26.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDWarrantyListDataModel.h"

@implementation XDWarrantyListDataModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"list" : @[@"repairsEntityList", @"complainEntityList"]};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"list" : [XDWarrantyModel class]};
}


@end
