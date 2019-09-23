//
//  XDPayforModel.h
//  XD业主
//
//  Created by zc on 2017/11/20.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDPayforModel : NSObject
/**
 *  返回字段
 */
@property (copy, nonatomic) NSString *msg;
/**
 *  数据
 */
@property (strong, nonatomic) NSArray *data;
/**
 *  0等于成功
 */
@property (copy, nonatomic) NSString *resultCode;
@end
