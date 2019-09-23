//
//  XDCarsListModel.m
//  XD业主
//
//  Created by zc on 2017/8/14.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDCarsListModel.h"
#import "XDCarModel.h"
@implementation XDCarsListModel

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"data" : [XDCarModel class]};
}

@end
