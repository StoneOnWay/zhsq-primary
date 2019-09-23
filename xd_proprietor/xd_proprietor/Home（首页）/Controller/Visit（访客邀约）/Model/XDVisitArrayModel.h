//
//  XDVisitArrayModel.h
//  XD业主
//
//  Created by zc on 2017/8/10.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XWarrantyListPageModel.h"

@interface XDVisitArrayModel : NSObject

/** string 	维修的类型*/
@property (nonatomic, strong) XWarrantyListPageModel *pagination;

/** string 	维修的列表*/
@property (nonatomic, strong) NSArray *datalist;

@end
