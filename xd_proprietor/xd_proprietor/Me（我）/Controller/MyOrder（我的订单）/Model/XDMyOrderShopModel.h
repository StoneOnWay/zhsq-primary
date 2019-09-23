//
//  XDMyOrderShopModel.h
//  XD业主
//
//  Created by zc on 2018/3/15.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KYShopcartResoucelistModel.h"
#import "XDGoodsListModel.h"

@interface XDMyOrderShopModel : NSObject

@property (nonatomic, assign) NSInteger ids;

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, assign) NSInteger homeid;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *homeName;

@property (nonatomic, assign) NSInteger orderid;

@property (nonatomic, copy) NSString *goodsPrice;

@property (nonatomic, copy) NSString *goodsid;

@property (nonatomic, copy) NSMutableArray<KYShopcartResoucelistModel *> *pics;
@property (nonatomic, strong) XDGoodsListModel *shopGoods;

@end

