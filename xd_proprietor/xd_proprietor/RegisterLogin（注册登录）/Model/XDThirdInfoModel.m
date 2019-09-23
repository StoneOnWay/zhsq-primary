//
//  XDThirdInfoModel.m
//  xd_proprietor
//
//  Created by cfsc on 2019/7/9.
//  Copyright © 2019年 zc. All rights reserved.
//

#import "XDThirdInfoModel.h"

@implementation XDThirdInfoModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.accountId = [aDecoder decodeObjectForKey:@"accountId"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.faceImg = [aDecoder decodeObjectForKey:@"faceImg"];
        self.ownerId = [aDecoder decodeObjectForKey:@"ownerId"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.createdate = [aDecoder decodeObjectForKey:@"createdate"];
        self.updatedate = [aDecoder decodeObjectForKey:@"updatedate"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.accountId forKey:@"accountId"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.faceImg forKey:@"faceImg"];
    [aCoder encodeObject:self.ownerId forKey:@"ownerId"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.createdate forKey:@"createdate"];
    [aCoder encodeObject:self.updatedate forKey:@"updatedate"];
}

@end
