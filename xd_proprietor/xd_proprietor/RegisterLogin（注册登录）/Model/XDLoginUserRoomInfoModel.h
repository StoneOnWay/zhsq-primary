//
//  XDLoginUserRoomInfoModel.h
//  XD业主
//
//  Created by zc on 2017/6/25.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDLoginUserRoomInfoModel : NSObject<NSCoding>

/** string 	用户房间编号*/
@property (nonatomic, copy) NSString *code;

/** string 	用户房屋ID*/
@property (nonatomic, strong) NSNumber *roomId;

/** string 	用户房屋所属单元id*/
@property (nonatomic, strong) NSNumber *cellId;

/** string 	用户名字*/
@property (nonatomic, copy) NSString *propertyArea;

/** string 	用户ID*/
@property (nonatomic, copy) NSString *name;

/** string 	地址*/
@property (nonatomic, copy) NSString *address;


@end
