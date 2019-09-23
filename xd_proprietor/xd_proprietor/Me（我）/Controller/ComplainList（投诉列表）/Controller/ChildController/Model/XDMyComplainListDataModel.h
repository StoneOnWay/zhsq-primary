//
//  XDMyComplainListDataModel.h
//  XD业主
//
//  Created by zc on 2017/6/28.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDPageModel.h"
@interface XDMyComplainListDataModel : NSObject

/** string 	维修的类型*/
@property (nonatomic, strong) XDPageModel *pagination;

/** string 	维修的列表*/
@property (nonatomic, strong) NSArray *complainEntityList;


@end
