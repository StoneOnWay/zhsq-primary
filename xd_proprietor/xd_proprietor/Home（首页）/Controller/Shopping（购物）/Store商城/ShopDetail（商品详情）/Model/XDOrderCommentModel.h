//
//  XDOrderCommentModel.h
//  XD业主
//
//  Created by zc on 2018/3/22.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDOrderCommentOwerModel.h"

@interface XDOrderCommentModel : NSObject

@property (nonatomic, strong) XDOrderCommentOwerModel *owners;
@property (nonatomic, assign) NSInteger goosid;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger ids;
@property (nonatomic, assign) NSInteger stargrade;
@property (nonatomic, assign) NSInteger orderid;
@property (nonatomic, copy) NSString *commentdatetime;
@property (nonatomic, assign) NSInteger ownerid;
@property (nonatomic, assign) NSInteger commentgrade;

@end


