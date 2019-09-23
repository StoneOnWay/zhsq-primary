//
//  XDWarrantyModel.h
//  XD业主
//
//  Created by zc on 2017/6/26.
//  Copyright © 2017年 zc. All rights reserved.
//

//列表的单个数据模型

#import <Foundation/Foundation.h>

@interface XDWarrantyModel : NSObject

/** string  服务器需要传的参数*/
@property (nonatomic, copy) NSString *piid;
/** repairsId/complainId<##> */
@property (copy, nonatomic) NSString *ID;
/** repairsStatus<##>/complainStatus */
@property (copy, nonatomic) NSString *status;
/** repairsTime/complainDateTime<##> */
@property (copy, nonatomic) NSString *time;
/** repairsTitle/complainTitle<##> */
@property (copy, nonatomic) NSString *title;
/** string     用于判定这个维修该由谁操作*/
@property (nonatomic, strong) NSArray *jbpmOutcomes;
//是否是自己进行操作
@property (copy , nonatomic)NSString *taskid;

/** 工单独有<##> */
@property (copy, nonatomic) NSString *repairsTypeName;//维修的类型

/** 投诉独有<##> */
/** string     */
@property (nonatomic, copy) NSString *resourcekey;
/** string     图片的路径*/
@property (nonatomic, strong) NSArray *complainImageUrl;

@end
