//
//  XDloginUserInfoModel.h
//  XD业主
//
//  Created by zc on 2017/6/25.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDloginUserInfoModel : NSObject<NSCoding>

/** string 	用户手机号码*/
@property (nonatomic, copy) NSString *mobileNumber;

/** string 	用户性别*/
@property (nonatomic, copy) NSString *gender;

/** string 	用户头像url*/
@property (nonatomic, copy) NSString *headImageUrl;

/** string 	用户名字*/
@property (nonatomic, copy) NSString *nickName;

/**  常用地址   */
@property (nonatomic, copy) NSString *commonAddress;

/**  项目id   */
@property (nonatomic, copy) NSString *projectId;

/** string     收货地址*/
@property (nonatomic, copy) NSString *receiptAddress;




// 用户唯一标识
@property (nonatomic, copy) NSString *personId;
// 用户姓名
@property (nonatomic, copy) NSString *personName;
// 用户手机号
@property (nonatomic, copy) NSString *phoneNo;

// 用户卡号
@property (nonatomic, copy) NSString *cardNo;
// 云眸请求token
@property (nonatomic, copy) NSString *token;
// 车牌号
@property (nonatomic, copy) NSString *vehicleCode;
// 用户ID
@property (nonatomic, strong) NSNumber *userId;
// 人脸url
@property (nonatomic, copy) NSString *faceDisUrl;
// 人脸上传时间
@property (nonatomic, copy) NSString *faceDisTime;
// 设备序列号
@property (nonatomic, copy) NSString *deviceSerial;
// 用户名
@property (nonatomic, copy) NSString *userName;
// 停车库唯一标识
@property (nonatomic, copy) NSString *parkSyscode;

#pragma mark - 用于多人脸采集
// 用户真实姓名
@property (nonatomic, copy) NSString *name;
// 用户id
@property (nonatomic, strong) NSNumber *ownerid;

//#pragma mark - QQ、微信登录
//// 用户唯一标识
//@property (nonatomic, copy) NSString *uid;
//// 类型：QQ-1/微信-0
//@property (nonatomic, strong) NSNumber *loginType;

@end
