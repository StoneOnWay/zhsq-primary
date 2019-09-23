//
//  KYRefreshView.h
//  XD业主
//
//  Created by zc on 2017/6/27.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYRefreshView : UIView

+ (void)showWithStatus:(NSString *)status;

+ (void)show;


+ (void)dismiss;


+ (void)dismissDeleyWithDuration:(CGFloat)deley;

@end
