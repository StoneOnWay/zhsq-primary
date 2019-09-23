//
//  XDPersonInfoModel.h
//  xd_proprietor
//
//  Created by stone on 18/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDPersonInfoModel : NSObject

// 用户唯一标识
@property (nonatomic, copy) NSString *personId;
// 用户姓名
@property (nonatomic, copy) NSString *personName;
// 用户手机号
@property (nonatomic, copy) NSString *phoneNo;
// 证件类型
@property (nonatomic, strong) NSNumber *certificateType;
// 证件号码
@property (nonatomic, copy) NSString *certificateNo;

@end

NS_ASSUME_NONNULL_END
