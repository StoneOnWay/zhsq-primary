//
//  XDComplainDetailEvaluteModel.h
//  XD业主
//
//  Created by zc on 2017/6/28.
//  Copyright © 2017年 zc. All rights reserved.
//
//投诉评价的模型
#import <Foundation/Foundation.h>

@interface XDComplainDetailEvaluteModel : NSObject

//评论的内容
@property (copy , nonatomic)NSString *commentContent;
//评论的星星等级
@property (copy , nonatomic)NSString *commentLevel;


@end
