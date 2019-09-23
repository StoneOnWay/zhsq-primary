//
//  EZOpenSDK+EZPrivateHeader.h
//  EzvizOpenSDK
//
//  Created by DeJohn Dong on 15/12/19.
//  Copyright © 2015年 Hikvision. All rights reserved.
//

#import "EZOpenSDK.h"

@class EZServerInfo;
@class EZTransferMessage;
@class EZDeviceDetailInfo;

@interface EZOpenSDK (EZPrivateHeader)

/**
 *  实例EZOpenSDK接口，切平台专用接口
 *
 *  @param appKey 传入申请的appKey
 *  @param apiUrl apiUrl地址
 *  @param authUrl auth地址
 *
 *  @return YES/NO
 */
+ (BOOL)initLibWithAppKey:(NSString *)appKey
                      url:(NSString *)apiUrl
                  authUrl:(NSString *)authUrl;

/**
 *  萤石开放平台SDK私有方法--根据关键字获取Http请求中公共参数的值的方法（4530专用接口）
 *
 *  @param key 关键字
 *
 *  @return 公共参数的值
 */
+ (NSString *)getHTTPPublicParam:(NSString *)key;


/**
 *  获取透明通道消息详情接口
 *
 *  @param messageId  消息ID
 *  @param completion 回调block
 *
 *  @return operation
 */
+ (NSOperation *)getTransferMessageInfo:(NSString *)messageId
                             completion:(void (^)(EZTransferMessage *message, NSError *error))completion;

/**
 *  获取设备详细信息
 *
 *  @param deviceSerial 设备序列号
 *  @param cameraNo     通道号，通道号为9999，则获取门口机相关的数据信息，只通道设备序列号查询（使用9999内部会调用另外一个接口）
 *  @param completion   回调block
 *
 *  @return operation
 */
+ (NSOperation *)getDeviceDetailInfo:(NSString *)deviceSerial
                            cameraNo:(NSInteger)cameraNo
                          completion:(void (^)(EZDeviceDetailInfo *detailInfo, NSError *error))completion;


/**
 *  获取取流token数组接口
 *
 *  @param tokenCount token单次数量
 *  @param completion 回调block
 *
 *  @return operation
 */
+ (NSOperation *)getStreamTokenList:(NSInteger)tokenCount
                         completion:(void (^)(NSArray *tokenList, NSError *error))completion;

/**
 *  获取服务器信息接口
 *
 *  @param completion 回调block
 *
 *  @return operation
 */
+ (NSOperation *)getServerInfo:(void (^)(EZServerInfo *serverInfo, NSError *error))completion;

/**
 *  门口机专用构建EZPlayer接口（for 4500）
 *
 *  @param deviceSerial 设备序列号
 *  @param cameraNo     虚拟通道号
 *  @param streamType   码流类型：1-主码流，2-子码流
 *
 *  @return EZPlayer对象
 */
+ (EZPlayer *)createPlayerWithDeviceSerial:(NSString *)deviceSerial cameraNo:(NSInteger)cameraNo streamType:(NSInteger)streamType;

@end
