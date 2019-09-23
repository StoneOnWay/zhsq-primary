//
//  XDProcessModel.h
//  XD业主
//
//  Created by zc on 2017/6/23.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDProcessModel : NSObject

@property (copy , nonatomic)NSString *handlerComment;

@property (copy , nonatomic)NSString *handlername;

@property (copy , nonatomic)NSString *handlertype;//判断左右

@property (assign , nonatomic)NSInteger notAcceptable;//判断颜色 0:灰色 1:金色

@property (copy , nonatomic)NSString *piclist;

@property (copy , nonatomic)NSString *planDateTime;

@property (strong , nonatomic)NSString *remark;//节点详情

@property (assign , nonatomic)NSInteger planId;

@property (copy , nonatomic)NSString *planName;

@property (copy , nonatomic)NSString *resourcekey;

//
//+ (NSMutableArray *)model;

@end
