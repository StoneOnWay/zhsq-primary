//
//  XDProjectModel.m
//  xd_proprietor
//
//  Created by cfsc on 2019/7/31.
//  Copyright © 2019年 zc. All rights reserved.
//

#import "XDProjectModel.h"

@implementation XDProjectModel

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.address = [decoder decodeObjectForKey:@"address"];
        self.tag = [decoder decodeObjectForKey:@"tag"];
        self.ip = [decoder decodeObjectForKey:@"ip"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.tag forKey:@"tag"];
    [encoder encodeObject:self.ip forKey:@"ip"];
}

@end
