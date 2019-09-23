//
//  XDloginUserInfoModel.m
//  XD业主
//
//  Created by zc on 2017/6/25.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDloginUserInfoModel.h"
#import "UIImageView+WebCache.h"

@implementation XDloginUserInfoModel



/**
 *  当从文件中解析出一个对象的时候调用
 *  在这个方法中写清楚：怎么解析文件中的数据
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        
        self.mobileNumber = [decoder decodeObjectForKey:@"mobileNumber"];
        self.gender = [decoder decodeObjectForKey:@"gender"];
        self.nickName = [decoder decodeObjectForKey:@"nickName"];
        self.headImageUrl = [decoder decodeObjectForKey:@"headImageUrl"];
        self.commonAddress = [decoder decodeObjectForKey:@"commonAddress"];
        self.projectId = [decoder decodeObjectForKey:@"projectId"];
        self.receiptAddress = [decoder decodeObjectForKey:@"receiptAddress"];
        
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.cardNo = [decoder decodeObjectForKey:@"cardNo"];
        self.token = [decoder decodeObjectForKey:@"token"];
        self.vehicleCode = [decoder decodeObjectForKey:@"vehicleCode"];
        self.faceDisUrl = [decoder decodeObjectForKey:@"faceDisUrl"];
        self.faceDisTime = [decoder decodeObjectForKey:@"faceDisTime"];
        self.deviceSerial = [decoder decodeObjectForKey:@"deviceSerial"];
        self.userName = [decoder decodeObjectForKey:@"userName"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.parkSyscode = [decoder decodeObjectForKey:@"parkSyscode"];
        
        self.personName = [decoder decodeObjectForKey:@"personName"];
        self.personId = [decoder decodeObjectForKey:@"personId"];
        self.phoneNo = [decoder decodeObjectForKey:@"phoneNo"];
        
//        self.uid = [decoder decodeObjectForKey:@"uid"];
//        self.loginType = [decoder decodeObjectForKey:@"loginType"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 *  在这个方法中写清楚：要存储哪些对象的哪些属性，以及怎样存储属性
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.mobileNumber forKey:@"mobileNumber"];
    [encoder encodeObject:self.gender forKey:@"gender"];
    [encoder encodeObject:self.nickName forKey:@"nickName"];
    [encoder encodeObject:self.headImageUrl forKey:@"headImageUrl"];
    [encoder encodeObject:self.commonAddress forKey:@"commonAddress"];
    [encoder encodeObject:self.projectId forKey:@"projectId"];
    [encoder encodeObject:self.receiptAddress forKey:@"receiptAddress"];
    
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.cardNo forKey:@"cardNo"];
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.vehicleCode forKey:@"vehicleCode"];
    [encoder encodeObject:self.faceDisUrl forKey:@"faceDisUrl"];
    [encoder encodeObject:self.faceDisTime forKey:@"faceDisTime"];
    [encoder encodeObject:self.deviceSerial forKey:@"deviceSerial"];
    [encoder encodeObject:self.userName forKey:@"userName"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.parkSyscode forKey:@"parkSyscode"];
    
    [encoder encodeObject:self.personName forKey:@"personName"];
    [encoder encodeObject:self.personId forKey:@"personId"];
    [encoder encodeObject:self.phoneNo forKey:@"phoneNo"];
    
//    [encoder encodeObject:self.uid forKey:@"uid"];
//    [encoder encodeObject:self.loginType forKey:@"loginType"];
}


@end
