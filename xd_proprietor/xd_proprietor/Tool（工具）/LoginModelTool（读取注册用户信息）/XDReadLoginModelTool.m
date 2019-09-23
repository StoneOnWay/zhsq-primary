//
//  XDReadLoginModelTool.m
//  XD业主
//
//  Created by zc on 2017/6/25.
//  Copyright © 2017年 zc. All rights reserved.
//

#define KFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"changfan.data"]

#define KProjectModelPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"project.plist"]

#import "XDReadLoginModelTool.h"


@implementation XDReadLoginModelTool

/**
 *  存储个人帐号
 */
+ (void)save:(XDLoginUseModel *)loginModel {
    // 归档
    [NSKeyedArchiver archiveRootObject:loginModel toFile:KFilepath];
}

/**
 *  读取个人帐号
 */
+ (XDLoginUseModel *)loginModel {
    // 读取帐号
    XDLoginUseModel *loginModel = [NSKeyedUnarchiver unarchiveObjectWithFile:KFilepath];
    loginModel.token = XD_Login_Token;
    return loginModel;
}

/**
 *  存储本地项目数组
 */
+ (void)saveProjectArray:(NSArray *)projectArray {
    // 归档
    [NSKeyedArchiver archiveRootObject:projectArray toFile:KProjectModelPath];
}

/**
 *  读取个人帐号
 */
+ (NSArray *)projectArray {
    // 读取帐号
    NSArray *projectArray = [NSKeyedUnarchiver unarchiveObjectWithFile:KProjectModelPath];
    return projectArray;
}

@end
