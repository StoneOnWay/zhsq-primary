//
//  XDMyOrderDetailModel.h
//  XD业主
//
//  Created by zc on 2018/3/15.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDMyOrderShopModel.h"

@interface XDMyOrderDetailModel : NSObject

@property (nonatomic, assign) NSInteger ids;

@property (nonatomic, copy) NSString *countprice;

@property (nonatomic, copy) NSString *paytime;

@property (nonatomic, copy) NSString *createtime;

@property (nonatomic, copy) NSString *contact;

@property (nonatomic, copy) NSString *userid; 

@property (nonatomic, copy) NSString *userName;      

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *overtime;

@property (nonatomic, copy) NSString *cancletime;

@property (nonatomic, strong) NSMutableArray<XDMyOrderShopModel *> *shopOrderDetail;

@property (nonatomic, copy) NSString *status;

@end

