//
//  ZHYJCallInfo.h
//  ZHYJSDK
//
//  Created by shilei on 17/6/12.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZHYJCallStatus) {
    ZHYJCallStatusCalling = 1,              //呼叫消息
    ZHYJCallStatusHangUp = 2,               //呼叫已结束
    ZHYJCallStatusAnswered = 3,             //呼叫已经被接听
};
typedef NS_ENUM(NSInteger, ZHYJCallCommandType) {
    ZHYJCallCommandTypeDecline = 3, //拒绝本地来电呼叫
    ZHYJCallCommandTypeTimeOut = 4, //被叫响铃超时
    ZHYJCallCommandTypeDeviceBusy = 6 //正在通话中
};

@interface ZHYJCallInfo : NSObject
@property (nonatomic, copy) NSString *callId; /**< 呼叫标识，用于区分不同呼叫信息*/
@property (nonatomic, copy) NSString *deviceSerial; /**< 呼叫设备序列号*/
@property (nonatomic, strong) NSDate *creatDate; /**< 发出呼叫时的设备时间*/
@property (nonatomic, copy) NSString *room;
@property (nonatomic, copy) NSString *periodNumber;
@property (nonatomic, copy) NSString *buildingNumber;
@property (nonatomic, copy) NSString *unitNumber;
@property (nonatomic, copy) NSString *floorNumber;
@property (nonatomic, copy) NSString *devIndex;
@property (nonatomic, copy) NSString *unitType;
@property (nonatomic, assign) ZHYJCallStatus callStatus; /**<呼叫状态 详见ZHYJCallStatus*/
@end
