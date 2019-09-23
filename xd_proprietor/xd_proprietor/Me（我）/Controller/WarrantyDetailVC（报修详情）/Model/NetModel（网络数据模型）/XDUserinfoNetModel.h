//
//  XDUserinfoNetModel.h
//  XD业主
//
//  Created by zc on 2017/6/26.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDUserinfoNetModel : NSObject
//所属物业
@property (strong , nonatomic)NSString *atProperty;
//性别
@property (assign , nonatomic)NSInteger gender;
//用户地址
@property (strong , nonatomic)NSString  *userAddress;
//用户头像网址
@property (strong , nonatomic)NSString *userHearImageUrl;
//用户ID
@property (assign , nonatomic)NSInteger userId;
//用户手机号码
@property (strong , nonatomic)NSString *userMobileNo;
//用户名称
@property (strong , nonatomic)NSString *userName;
//用户房屋地址
@property (strong , nonatomic)NSString *userRoomAddress;


@end
