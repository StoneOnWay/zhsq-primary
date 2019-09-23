//
//  XDReadLoginModelTool.h
//  XD业主
//
//  Created by zc on 2017/6/25.
//  Copyright © 2017年 zc. All rights reserved.
//
/*****读取登录用户信息数据*****/
#import <Foundation/Foundation.h>
@class XDLoginUseModel;

@interface XDReadLoginModelTool : NSObject

/**
 *  存储个人帐号
 */
+ (void)save:(XDLoginUseModel *)loginModel;

/**
 *  读取个人帐号
 */
+ (XDLoginUseModel *)loginModel;

/**
 *  存储本地项目数组
 */
+ (void)saveProjectArray:(NSArray *)projectArray;

/**
 *  读取个人帐号
 */
+ (NSArray *)projectArray;

@end
