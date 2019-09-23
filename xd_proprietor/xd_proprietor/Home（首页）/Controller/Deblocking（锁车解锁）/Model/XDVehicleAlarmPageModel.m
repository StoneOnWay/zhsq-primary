//
//  XDVehicleAlarmPageModel.m
//  xd_proprietor
//
//  Created by stone on 16/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDVehicleAlarmPageModel.h"
#import "XDVehicleAlarmModel.h"

@implementation XDVehicleAlarmPageModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list":[XDVehicleAlarmModel class]};
}

@end
