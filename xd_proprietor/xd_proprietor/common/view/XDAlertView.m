//
//  XDAlertView.m
//  xd_proprietor
//
//  Created by mason on 2018/9/11.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDAlertView.h"

@implementation XDAlertView

+ (void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle isDelegate:(id)isDelegate clickBlock:(clickBlock)clickBlock
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:window.bounds WithTitle:title andDetail:detailTitle andBody:nil andCancelTitle:nil andOtherTitle:@"知道了" andIsOneBtn:YES clickBlock:clickBlock];
    alertView.delegate = isDelegate;
    [window addSubview:alertView];
}

@end
