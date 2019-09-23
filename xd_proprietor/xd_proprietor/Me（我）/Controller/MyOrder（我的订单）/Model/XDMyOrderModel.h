//
//  XDMyOrderModel.h
//  XD业主
//
//  Created by zc on 2018/3/15.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDPageModel.h"
#import "XDMyOrderDetailModel.h"


@interface XDMyOrderModel : NSObject

@property (nonatomic, strong) NSMutableArray<XDMyOrderDetailModel *> *orderDetail;

@property (nonatomic, strong) XDPageModel *pagination;

@end
