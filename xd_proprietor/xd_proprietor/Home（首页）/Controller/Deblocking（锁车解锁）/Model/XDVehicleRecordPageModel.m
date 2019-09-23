//
//  XDVehicleRecordPageModel.m
//  xd_proprietor
//
//  Created by stone on 16/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDVehicleRecordPageModel.h"
#import "XDVehicleRecordModel.h"

@implementation XDVehicleRecordPageModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list":[XDVehicleRecordModel class]};
}

@end
