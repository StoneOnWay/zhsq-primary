//
//  XDLoginUserRoomInfoModel.m
//  XD业主
//
//  Created by zc on 2017/6/25.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDLoginUserRoomInfoModel.h"

@implementation XDLoginUserRoomInfoModel

/**
 *  当从文件中解析出一个对象的时候调用
 *  在这个方法中写清楚：怎么解析文件中的数据
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        
        self.code = [decoder decodeObjectForKey:@"code"];
        self.roomId = [decoder decodeObjectForKey:@"roomId"];
        self.cellId = [decoder decodeObjectForKey:@"cellId"];
        self.propertyArea = [decoder decodeObjectForKey:@"propertyArea"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.address = [decoder decodeObjectForKey:@"address"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 *  在这个方法中写清楚：要存储哪些对象的哪些属性，以及怎样存储属性
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.code forKey:@"code"];
    [encoder encodeObject:self.roomId forKey:@"roomId"];
    [encoder encodeObject:self.cellId forKey:@"cellId"];
    [encoder encodeObject:self.propertyArea forKey:@"propertyArea"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.address forKey:@"address"];
}

@end
