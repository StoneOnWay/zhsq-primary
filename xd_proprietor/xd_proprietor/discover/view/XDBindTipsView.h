//
//  XDBindTipsView.h
//  xd_proprietor
//
//  Created by cfsc on 2019/7/5.
//  Copyright © 2019年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDBindTipsView : UIView
@property (nonatomic, copy) void (^bindBtnClick)(void);
@end

NS_ASSUME_NONNULL_END
