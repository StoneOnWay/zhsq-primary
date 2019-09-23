//
//  XDVehiclePageInfoModel.m
//  xd_proprietor
//
//  Created by stone on 15/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDVehiclePageInfoModel.h"
#import "XDVehicleInfoModel.h"

@implementation XDVehiclePageInfoModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list":[XDVehicleInfoModel class]};
}

@end
