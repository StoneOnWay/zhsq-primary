//
//  XDPayforDataModel.h
//  XD业主
//
//  Created by zc on 2017/11/20.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDPayforDataModel : NSObject

/**
 *  id
 */
@property (nonatomic, copy) NSString *ids;

/**
 *  缴费日期
 */
@property (copy, nonatomic) NSString *paydate;
/**
 *  房屋id
 */
@property (copy, nonatomic) NSString *roomid;
/**
 *  是否缴费 1是 0否
 */
@property (copy, nonatomic) NSString *ifpay;
/**
 *  费用总额
 */
@property (copy, nonatomic) NSString *fee;
/**
 *  应缴费日期
 */
@property (copy, nonatomic) NSString *shouldpaydate;
/**
 *  房屋地址名称
 */
@property (copy, nonatomic) NSString *adds;
/**
 *  缴费类型
 */
@property (copy, nonatomic) NSString *advancetype;
/**
 *  所属账期
 */
@property (copy, nonatomic) NSString *term;

@end

