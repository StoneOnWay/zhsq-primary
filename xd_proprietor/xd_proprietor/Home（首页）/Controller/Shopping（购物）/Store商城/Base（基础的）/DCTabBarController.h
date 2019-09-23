//
//  DCTabBarController.h
//  CDDMall
//
//  Created by apple on 2017/5/26.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDShoppingModel.h"
typedef enum : NSUInteger {
    DCTabBarControllerHome = 0, //首页
    DCTabBarControllerShoppingCart = 1,  //美媚榜
    DCTabBarControllerPerson = 2, //个人中心
} DCTabBarControllerType;

@interface DCTabBarController : UITabBarController

/* 控制器type */
@property (assign , nonatomic)DCTabBarControllerType tabVcType;

@property (strong , nonatomic)XDShoppingModel *shopModel;

@end
