//
//  XDLoginUseModel.m
//  XD业主
//
//  Created by zc on 2017/6/25.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDLoginUseModel.h"
#import "XDLoginUserRoomInfoModel.h"
#import "XDDeviceInfoModel.h"
#import "XDThirdInfoModel.h"

@implementation XDLoginUseModel

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"roominfo" : [XDLoginUserRoomInfoModel class],
             @"deviceInfo" : [XDDeviceInfoModel class],
             @"thirdInfo" : [XDThirdInfoModel class]
             };
}

/**
 *  当从文件中解析出一个对象的时候调用
 *  在这个方法中写清楚：怎么解析文件中的数据
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        
        self.token = [decoder decodeObjectForKey:@"token"];
        self.userInfo = [decoder decodeObjectForKey:@"userInfo"];
        self.roominfo = [decoder decodeObjectForKey:@"roominfo"];
        self.deviceInfo = [decoder decodeObjectForKey:@"deviceInfo"];
        self.thirdInfo = [decoder decodeObjectForKey:@"thirdInfo"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 *  在这个方法中写清楚：要存储哪些对象的哪些属性，以及怎样存储属性
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.userInfo forKey:@"userInfo"];
    [encoder encodeObject:self.roominfo forKey:@"roominfo"];
    [encoder encodeObject:self.deviceInfo forKey:@"deviceInfo"];
    [encoder encodeObject:self.thirdInfo forKey:@"thirdInfo"];
}

@end
