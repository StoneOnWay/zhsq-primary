//
//  XDThirdInfoModel.h
//  xd_proprietor
//
//  Created by cfsc on 2019/7/9.
//  Copyright © 2019年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
{
    accountId = 6D8D7B8C4C68E279E49529DBFFAD8FDB;
    createdate = "2019-07-08 17:11:35";
    faceImg = "https://thirdqq.qlogo.cn/g?b=oidb&k=qvhEqjrDbN0louW3fXgINQ&s=100";
    id = 10;
    nickname = stone;
    ownerId = 4536;
    sex = "\U7537";
    status = "<null>";
    type = 1;
    updatedate = "<null>";
}
 */
@interface XDThirdInfoModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, copy) NSString *faceImg;
@property (nonatomic, strong) NSNumber *ownerId;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, copy) NSString *createdate;
@property (nonatomic, copy) NSString *updatedate;

@end

NS_ASSUME_NONNULL_END
