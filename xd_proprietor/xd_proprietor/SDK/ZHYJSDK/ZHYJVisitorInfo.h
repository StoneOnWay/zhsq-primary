//
//  ZHYJVisitorInfo.h
//  ZHYJSDK
//
//  Created by shilei on 17/7/11.
//
//

#import <Foundation/Foundation.h>

@interface ZHYJVisitorInfo : NSObject
@property(nonatomic, copy) NSString *visitorID; /**<访客预约标识*/
@property(nonatomic, copy) NSString *orderID; /**<访客预约序号*/
@property(nonatomic, copy) NSString *visitorStatus; /**<访客预约状态*/
@property(nonatomic, copy) NSString *startTime; /**<访客预约开始时间*/
@property(nonatomic, copy) NSString *endTime; /**<访客预约结束时间*/
@property(nonatomic, copy) NSString *visitorName; /**<访客姓名*/
@property(nonatomic, assign) NSInteger sex; /**<访客性别 1表示男 2表示女*/
@property(nonatomic, assign) NSInteger isVip; /**<是否是vip 0表示非vip 1表示vip*/
@property(nonatomic, copy) NSString *phoneNumber; /**<访客电话号码*/
@property(nonatomic, copy) NSString *carNumber; /**<卡号*/
@property(nonatomic, copy) NSString *population; /**<访客人数*/
@property(nonatomic, copy) NSString *purpose; /**<目的*/
@property(nonatomic, copy) NSString *barCodeUrl; /**<分享二维码地址*/
@property(nonatomic, copy) NSString *visitorIdentityID;/**<身份id*/
@property(nonatomic, copy) NSString *reason; /**<说明*/
@property(nonatomic, copy) NSString *credentials; /**<证件号*/
@property(nonatomic, copy) NSString *credentialstype; /**<证件类型*/
@end
