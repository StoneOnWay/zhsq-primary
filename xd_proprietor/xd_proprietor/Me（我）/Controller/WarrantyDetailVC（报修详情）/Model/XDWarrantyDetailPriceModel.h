//
//  XDWarrantyDetailPriceModel.h
//  XD业主
//
//  Created by zc on 2017/6/26.
//  Copyright © 2017年 zc. All rights reserved.
//
//报修价格的模型
#import <Foundation/Foundation.h>

@interface XDWarrantyDetailPriceModel : NSObject

//费用发送的时间 用于判断是否显示费用
@property (copy , nonatomic)NSString *sendFeeDate;
//人工费用
@property (nonatomic, assign) NSInteger manualCost;

//材料费用
@property (nonatomic, assign) NSInteger materialCost;

//总费用
@property (nonatomic, assign) NSInteger totalCost;

//报修类型
@property (nonatomic, copy) NSString *repairsType;

//报修处理人
@property (nonatomic, copy) NSString *disposePerson;

//报修状态
@property (nonatomic, strong) NSString *repairsStatus;


@end
