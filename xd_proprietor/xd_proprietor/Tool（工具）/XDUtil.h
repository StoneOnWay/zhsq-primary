//
//  XDUtil.h
//  xd_proprietor
//
//  Created by mason on 2018/9/10.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDUtil : NSObject

+ (BOOL)stringIsEmpty:(NSString *) aString;

+ (BOOL)stringIsEmpty:(NSString *) aString shouldCleanWhiteSpace:(BOOL)cleanWhileSpace;

/**
 字符串签名

 @param key 密钥
 @param content 签名字符串
 @return 签名
 */
+ (NSString *)createSignStrFor:(NSString *)key content:(NSString *)content;

+ (NSString *)getUUID;

#pragma mark - 时间处理

/**
 时间字符串转日期

 @param dateStr 时间字符串
 @param formatterStr 时间字符串格式
 @return 日期
 */
+ (NSDate *)dateFromDateStr:(NSString*)dateStr WithFormatterStr:(NSString *)formatterStr;

/**
 日期转时间字符串

 @param date 日期
 @param formatterStr 时间字符串格式
 @return 时间字符串
 */
+ (NSString *)dateStrFromDate:(NSDate *)date WithFormatterStr:(NSString *)formatterStr;

/**
 获取当前时间时间字符串
 
 @param formatterStr 时间字符串格式
 @return 当前时间字符串
 */
+ (NSString *)getNowTimeStrWithFormatter:(NSString *)formatterStr;

+ (NSString*)getDateStrWithFormatter:(NSString *)formatterStr sinceNow:(NSTimeInterval)timeInterval;

/**
 获取当前时间时间戳

 @return 当前时间时间戳
 */
+ (NSString *)getNowTimeTimestamp;

/**
 获取当前时间时间戳
 
 @return 当前时间时间戳（以毫秒为单位）
 */
+ (NSString *)getNowTimeMillTimestamp;

/**
 距离某个日期某年某月某日后的日期字符串

 @param myDate 一个日期
 @param year 距离N年
 @param month 距离N月
 @param day 距离N天
 @param str 时间格式
 @return 距离某个日期某年某月某日后的日期字符串
 */
+ (NSString *)getTimeStrSinceDate:(NSDate *)myDate WithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day formatterStr:(NSString *)str;

// 获取当前时间某年某月某日后的时间字符串
+ (NSString *)getTimeStrSinceNowWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day formatterStr:(NSString *)str;

/**
 获取两个时间相差的天数

 @param firstDateStr 开始日期字符串
 @param secondDateStr 结束日期字符串
 @param dateFormatterStr 时间格式字符串，必须与上面的日期字符格式相同
 @return 相差的天数
 */
+ (NSInteger)getDistanceWithFirstDate:(NSString *)firstDateStr secondDate:(NSString *)secondDateStr dateFormatter:(NSString *)dateFormatterStr;

// 生成二维码
+ (UIImage *)createCodeImageView:(NSString *)url;

// 截取当前屏幕
+ (NSData *)dataWithScreenshotInPNGFormat;

+ (void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle;

+ (void)showToast:(NSString *)message;

// 计算缓存
+ (float)folderSizeAtPath:(NSString*)folderPath;
// 清除缓存
+ (void)clearCache:(NSString *)path;
// 字符串拆分成数组
+ (NSMutableArray *)convertToArrayByStr:(NSString *)str;

// 判断设备是不是iPad
+ (BOOL)isIPad;

// 修改约束的multiplier属性
+ (void)changeMultiplierOfConstraint:(NSLayoutConstraint *)constraint multiplier:(CGFloat)multiplier;

@end
