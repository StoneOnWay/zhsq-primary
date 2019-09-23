//
//  XDCreateOrderController.h
//  XD业主
//
//  Created by zc on 2018/3/14.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDCreateOrderController : UIViewController

//商品详情直接购买
@property (nonatomic, strong) NSArray *shopModelArray;
//购物车批量购买
@property (nonatomic, strong) NSArray *cartModelArray;

//刷新购物车
@property (nonatomic, copy) dispatch_block_t refreshCart;

//总价
@property (nonatomic, strong) NSString *totalString;
@end
