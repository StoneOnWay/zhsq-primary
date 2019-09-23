//
//  XDCarManageController.h
//  xd_proprietor
//
//  Created by stone on 21/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDCarPropertyModel.h"

NS_ASSUME_NONNULL_BEGIN
// 添加车辆
@interface XDCarManageController : UIViewController
@property (nonatomic, strong) XDCarPropertyModel *carModel;
@property (nonatomic, copy) void (^addCarSuccess)(void);
@end

NS_ASSUME_NONNULL_END
