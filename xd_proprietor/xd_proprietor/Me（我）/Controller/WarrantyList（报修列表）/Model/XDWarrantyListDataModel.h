//
//  XDWarrantyListDataModel.h
//  XD业主
//
//  Created by zc on 2017/6/26.
//  Copyright © 2017年 zc. All rights reserved.
//
//未完成的报修列表模型

#import <Foundation/Foundation.h>
#import "XDWarrantyModel.h"
#import "XDPageModel.h"

@interface XDWarrantyListDataModel : NSObject<YYModel>


/** string 	维修的类型*/
@property (nonatomic, strong) XDPageModel *pagination;

/** string 	维修的列表*/
@property (nonatomic, strong) NSArray *list;


@end
