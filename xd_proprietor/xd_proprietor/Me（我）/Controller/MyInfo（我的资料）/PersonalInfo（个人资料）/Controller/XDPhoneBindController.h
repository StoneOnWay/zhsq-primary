//
//  XDPhoneBindController.h
//  xd_proprietor
//
//  Created by cfsc on 2019/7/4.
//  Copyright © 2019年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDPhoneBindController : UIViewController
@property (nonatomic, copy) void (^bindSuccessBlock)(void);
@end

NS_ASSUME_NONNULL_END
