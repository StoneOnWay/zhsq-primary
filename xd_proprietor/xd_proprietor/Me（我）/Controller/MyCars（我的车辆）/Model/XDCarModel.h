//
//  XDCarModel.h
//  XD业主
//
//  Created by zc on 2017/8/14.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDCarModel : NSObject

@property (nonatomic, copy) NSString *cardNo;

@property (nonatomic, strong) NSNumber *userId;

@property (nonatomic, strong) NSNumber *carId;

@property (nonatomic, copy) NSString *aDate;

@property (nonatomic, copy) NSString *brand;

//1锁  2没锁
@property (nonatomic, strong) NSNumber *state;

@property (nonatomic, copy) NSString *uDate;


@end
