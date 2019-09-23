//
//  XDDeviceInfoModel.m
//  xd_proprietor
//
//  Created by stone on 9/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDDeviceInfoModel.h"

@implementation XDDeviceInfoModel

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.deviceSerial = [decoder decodeObjectForKey:@"deviceSerial"];
        self.location = [decoder decodeObjectForKey:@"location"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 *  在这个方法中写清楚：要存储哪些对象的哪些属性，以及怎样存储属性
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.deviceSerial forKey:@"deviceSerial"];
    [encoder encodeObject:self.location forKey:@"location"];
}

@end
