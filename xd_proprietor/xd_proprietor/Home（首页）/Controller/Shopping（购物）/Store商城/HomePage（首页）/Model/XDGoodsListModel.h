//
//  XDGoodsListModel.h
//  XD业主
//
//  Created by zc on 2018/3/8.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDHomeDataModel.h"
@interface XDGoodsListModel : NSObject

@property (nonatomic, assign) NSInteger ids;
@property (nonatomic, assign) NSInteger typeids;
@property (nonatomic, strong) XDHomeDataModel *shopType;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *discountprice;
@property (nonatomic, copy) NSString *size;

@property (nonatomic, copy) NSString *resource;
@property (nonatomic, copy) NSArray *resourceList;
@property (nonatomic, copy) NSString *detail;

@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *remark;

@end


