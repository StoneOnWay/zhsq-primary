//
//  XDVehicleInfoModel.h
//  xd_proprietor
//
//  Created by stone on 15/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 "vehicleId": "ddfff934-3632-4891-a9e9-bea8c25e54b6", "plateNo": "浙A12345",
 "isBandPerson": 1,
 "personId": "f1ed9ade-8057-4d01-bb38-2af26d43083e", "personName": "shunzi",
 "phoneNo": null, "plateType": 0, "plateColor": 0, "vehicleType": 1, "vehicleColor": 1, "mark": "备注备注"
 */
@interface XDVehicleInfoModel : NSObject

// 车辆ID
@property (nonatomic, copy) NSString *vehicleId;
// 车牌号码
@property (nonatomic, copy) NSString *plateNo;
// 是否关联人员
@property (nonatomic, strong) NSNumber *isBandPerson;
// 人员ID
@property (nonatomic, copy) NSString *personId;
// 车主姓名
@property (nonatomic, copy) NSString *personName;

// 车辆布控状态 1-解锁状态 0-被锁状态
@property (nonatomic, strong) NSNumber *state;
// 车辆布控唯一标识
@property (nonatomic, copy, nullable) NSString *alarmSyscode;

@end

NS_ASSUME_NONNULL_END
