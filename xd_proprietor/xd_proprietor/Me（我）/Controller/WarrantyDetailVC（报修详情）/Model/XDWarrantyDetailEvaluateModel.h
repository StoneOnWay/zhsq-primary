//
//  XDWarrantyDetailEvaluateModel.h
//  XD业主
//
//  Created by zc on 2017/6/26.
//  Copyright © 2017年 zc. All rights reserved.
//
//报修评论的模型
#import <Foundation/Foundation.h>

@interface XDWarrantyDetailEvaluateModel : NSObject

//评论的内容
@property (copy , nonatomic)NSString *commentContent;
//评论的星星等级
@property (copy , nonatomic)NSString *commentLevel;


@end
