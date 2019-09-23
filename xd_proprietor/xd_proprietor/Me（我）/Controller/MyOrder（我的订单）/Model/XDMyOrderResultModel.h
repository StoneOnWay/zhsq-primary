//
//  XDMyOrderResultModel.h
//  XD业主
//
//  Created by zc on 2018/3/15.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDMyOrderModel.h"

@interface XDMyOrderResultModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) XDMyOrderModel *data;

@property (nonatomic, strong) NSString *resultCode;

@end
