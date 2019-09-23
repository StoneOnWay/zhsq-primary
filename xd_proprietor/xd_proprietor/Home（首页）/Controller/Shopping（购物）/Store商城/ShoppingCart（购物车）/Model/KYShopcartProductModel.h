//
//  KYShopcartProductModel.h
//  KYShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KYShopcartResoucelistModel.h"
@interface KYShopcartProductModel : NSObject

@property (nonatomic, assign) NSInteger ids;      //商品id标识

@property (nonatomic, assign) NSInteger homeid; 

@property (nonatomic, assign) NSInteger cartid;      //购物车id标识

@property (nonatomic, copy) NSString *detail;

@property (nonatomic, copy) NSString *resource;

@property (nonatomic, copy) NSString *createtime;

@property (nonatomic, assign) NSInteger count;       //商品数

@property (nonatomic, copy) NSString *homename; //商店名称

@property (nonatomic, copy) NSString *discountprice;      //折后价

@property (nonatomic, copy) NSString *size; //规格大小

@property (nonatomic, copy) NSString *shopType;

@property (nonatomic, copy) NSString *price; //原价

@property (nonatomic, strong) NSMutableArray<KYShopcartResoucelistModel *> *resourceList;

@property (nonatomic, copy) NSString *updatetime;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, copy) NSString *name;  //商品名称

@property (nonatomic, copy) NSString *typeids;

@property (nonatomic, assign) NSInteger productStocks;      //库存暂时没得 默认2万

@property(nonatomic, assign)BOOL isSelected;    //记录相应row是否选中（自定义）

@end



