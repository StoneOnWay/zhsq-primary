//
//  XDLoginUseModel.h
//  XD业主
//
//  Created by zc on 2017/6/25.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDloginUserInfoModel.h"

#define XD_Login_Token @"7215aa1cbfe4a882db33d50a4eefba00"

@interface XDLoginUseModel : NSObject<NSCoding>

/** string 	用户唯一标识*/
@property (nonatomic, copy) NSString *token;

/** string 	用户个人资料信息*/
@property (nonatomic, strong) XDloginUserInfoModel *userInfo;

/** string     用户所有设备信息*/
@property (nonatomic, strong) NSArray *deviceInfo;

/** string 	用户所有房屋信息*/
@property (nonatomic, strong) NSArray *roominfo;

/** 第三方登录信息*/
@property (nonatomic, strong) NSArray *thirdInfo;

@end
