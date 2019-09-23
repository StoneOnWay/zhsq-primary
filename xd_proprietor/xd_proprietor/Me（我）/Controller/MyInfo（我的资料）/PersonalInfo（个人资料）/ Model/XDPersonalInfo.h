//
//  XDPersonalInfo.h
//  xd_proprietor
//
//  Created by stone on 14/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDPersonalInfo : NSObject
// 昵称
@property (nonatomic, copy) NSString *nickname;
// 电话
@property (nonatomic, copy) NSString *mobile;
// 性别
@property (nonatomic, assign) NSInteger gender;
// 生日
@property (nonatomic, copy) NSString *birthday;
// 房屋信息
@property (nonatomic, copy) NSString *roomInfo;
// 入住日期
@property (nonatomic, copy) NSString *checkindate;
// 居住方式
@property (nonatomic, copy) NSString *livemode;
// 头像url
@property (nonatomic, copy) NSString *face;
// 头像照片
@property (nonatomic, strong) UIImage *headImage;
@end

NS_ASSUME_NONNULL_END
