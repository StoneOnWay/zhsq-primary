//
//  XDJsInteraction.m
//  xd_proprietor
//
//  Created by cfsc on 2019/7/13.
//  Copyright © 2019年 zc. All rights reserved.
//

#import "XDJsInteraction.h"

@implementation XDJsInteraction

- (void)testIOSInteraction:(NSString *)str {
    NSString *toast = [NSString stringWithFormat:@"测试按钮点击-%@", str];
    [XDUtil showToast:toast];
}

@end
