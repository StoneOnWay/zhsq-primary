//
//  XDCarPropertyModel.h
//  xd_proprietor
//
//  Created by stone on 22/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KCarColor) {
    KCarColorOther, // 其他颜色
    KCarColorWhite, // 白色
    KCarColorSilver, // 银色
    KCarColorGray, // 灰色
    KCarColorBlack, // 黑色
    KCarColorRed, // 红色
    KCarColorDarkBlue, // 深蓝色
    KCarColorBlue, // 蓝色
    KCarColorYellow, // 黄色
    KCarColorGreen, // 绿色
    KCarColorBrown, // 棕色
    KCarColorPink, // 粉色
    KCarColorPurple // 紫色
};

typedef NS_ENUM(NSInteger, KCarType) {
    KCarTypeOther, // 其他车
    KCarTypeSmall, // 小型车
    KCarTypeLarge, // 大型车
    KCarTypeMotor, // 摩托车
};

typedef NS_ENUM(NSInteger, KPlateColor) {
    KPlateColorBlue, // 蓝色
    KPlateColorYellow, // 黄色
    KPlateColorWhite, // 白色
    KPlateColorBlack, // 黑色
    KPlateColorGreen, // 绿色
    KPlateColorPlaneBlack, // 民航黑色
    KPlateColorOther = 255 // 其他颜色
};

typedef NS_ENUM(NSInteger, KPlateType) {
    KPlateTypeOri, // 标准民用车
    KPlateTypeTwo, // 02式民用车
    KPlateTypeArmedPolice, // 武警车
    KPlateTypePolice, // 警车
    KPlateTypeTwoLine, // 民用车双行尾牌
    KPlateTypeMission, // 使馆车
    KPlateTypeFarmer, // 农用车
    KPlateTypeMotor, // 摩托车
    KPlateTypeNewEnergy, // 新能源车
    KPlateTypeArmy = 13 // 军车
};

NS_ASSUME_NONNULL_BEGIN

@interface XDCarPropertyModel : NSObject

// 车辆id
@property (nonatomic, strong) NSNumber *carId;
// 车牌类型
@property (nonatomic, copy) NSString *plateType;
// 车牌颜色
@property (nonatomic, copy) NSString *plateColor;
// 车辆类型
@property (nonatomic, copy) NSString *carType;
// 车辆颜色
@property (nonatomic, copy) NSString *carColor;
// 车牌号码
@property (nonatomic, copy) NSString *vehiclecode;
// 业主id
@property (nonatomic, copy) NSString *ownerid;
// 车辆照片
@property (nonatomic, copy) NSString *carPhoto;
// 是否审核
@property (nonatomic, strong) NSNumber *vehiclestatus;

// 包租类型名
@property (nonatomic, copy) NSString *charterName;
// 包租有效期
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;

@end

NS_ASSUME_NONNULL_END
