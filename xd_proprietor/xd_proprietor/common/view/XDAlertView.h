//
//  XDAlertView.h
//  xd_proprietor
//
//  Created by mason on 2018/9/11.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDAlertView : UIView

+ (void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle isDelegate:(id)isDelegate clickBlock:(clickBlock)clickBlock;

@end
