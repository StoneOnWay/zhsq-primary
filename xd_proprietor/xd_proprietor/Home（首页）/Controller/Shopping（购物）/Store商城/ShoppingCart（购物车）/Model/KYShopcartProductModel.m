//
//  KYShopcartProductModel.m
//  KYShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import "KYShopcartProductModel.h"

@implementation KYShopcartProductModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ids" : @"id",@"typeids" : @"typeid"};
}

+ (NSDictionary *)objectClassInArray {
    return @{@"resourceList":[KYShopcartResoucelistModel class]};
}

- (NSInteger)productStocks {
    return 20000;
}

@end
