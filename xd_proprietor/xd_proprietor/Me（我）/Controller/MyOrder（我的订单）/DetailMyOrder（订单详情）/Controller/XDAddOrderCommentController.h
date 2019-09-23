//
//  XDAddOrderCommentController.h
//  XD业主
//
//  Created by zc on 2018/3/22.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDMyOrderDetailModel.h"
#import "XDMyOrderShopModel.h"

@interface XDAddOrderCommentController : UIViewController

/** 模型 */
@property (nonatomic, strong) XDMyOrderDetailModel *detailModel;

/** 模型 */
@property (nonatomic, strong) XDMyOrderShopModel *shopModel;

@property (nonatomic, copy)dispatch_block_t refreshFinish;

@end
