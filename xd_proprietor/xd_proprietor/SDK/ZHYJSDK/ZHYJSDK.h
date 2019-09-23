//
//  ZHYJSDK.h
//  ZHYJSDK
//
//  Created by shilei on 17/6/9.
//
//

#import "ZHYJCallInfo.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, openDoorResultType) {
    openDoorResultTypeSucceed = 1,              //开门成功
    openDoorResultTypeFailed = 2,               //开门失败
    openDoorResultTypeTimeout = 3,              //卡号已经过期
};

typedef NS_ENUM(NSInteger, ZHYJDeviceCallStatus) {
    ZHYJDeviceCallStatusNoCall = 1,               //无呼叫
    ZHYJDeviceCallStatusCalling = 2,              //呼叫中
    ZHYJDeviceCallStatusAnswering = 3,            //通话中
};

@interface ZHYJSDK : NSObject


#pragma mark --初始化部分
+(BOOL)initZHYJLibWithClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret completion:(void (^)(void))completion;

#pragma mark --可视对讲部分

/**
 给设备解锁
 
 @param type 1、预览开锁 2、通话开锁
 @param deviceSerial 设备序列号
 @param completion 开锁结果
 */
+(void)sendDeviceUnlock:(NSInteger)type deviceSerial:(NSString *)deviceSerial completion:(void(^)(BOOL succeed, NSError *error))completion;

/**
 接听
 
 @param completion 接听结果
 */
+(void)answer:(ZHYJCallInfo *)callInfo completion:(void(^)(BOOL succeed, NSError *error))completion hangUp:(void(^)())hangUp;

/**
 挂断
 
 @param completion 挂断结果
 */
+(void)hangUp:(ZHYJCallInfo *)callInfo completion:(void(^)(BOOL succeed, NSError *error))completion;

/**
 拒接
 
 @param completion 拒接结果
 */
+(void)reject:(ZHYJCallInfo *)callInfo completion:(void(^)(BOOL succeed, NSError *error))completion;


/**
 开始预览
 
 @param completion 开始预览结果
 */
+(void)startRealPlayWithDeviceSerial:(NSString *)deviceSerial  cameraNo:(NSInteger)cameraNo inView:(UIView *)view completion:(void(^)(BOOL succeed, NSError *error))completion;

/**
 结束预览
*/
+(BOOL)stopRealPlay;

/**
 获取设备通话状态
 */
+(void)listenDeviceStatus:(ZHYJCallInfo *)callInfo answered:(void(^)(BOOL succeed, ZHYJDeviceCallStatus deviceCallStatus, NSError *error))answered;

@end
