//
//  PaaCreater.h
//  AllinpayTest_ObjC
//
//  Created by allinpay-shenlong on 14-10-27.
//  Copyright (c) 2014年 Allinpay.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@interface PaaCreater : NSObject

/**
 * 金额
 */
@property (nonatomic, strong) NSString *AmountOfMoney;
/**
 * 创建时间
 */
@property (nonatomic, strong) NSString *createdate;
/**
 * 流水号
 */
@property (nonatomic, strong) NSString *payid;
/**
 * 流水号
 */
@property (nonatomic, strong) NSString *userid;
/**
 * 交啥费用
 */
@property (nonatomic, strong) NSString *productName;
+ (NSString *)randomPaa;
+ (PaaCreater *)sharePaaCreater;
@end


