//
//  XDCarEditController.h
//  xd_proprietor
//
//  Created by cfsc on 2019/6/15.
//  Copyright © 2019年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDCarPropertyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDCarEditController : UIViewController
@property (nonatomic, strong) XDCarPropertyModel *carModel;
@property (nonatomic, copy) void (^addCarSuccess)(void);
@end

NS_ASSUME_NONNULL_END
