//
//  XDTabBar.m
//  xd_proprietor
//
//  Created by stone on 30/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDTabBar.h"
#import "XDSecondaryPublishController.h"

@interface XDTabBar ()

@property (nonatomic, weak) UIButton *plusBtn;

@end

@implementation XDTabBar

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger count = self.items.count + 1;
    CGFloat width = self.bounds.size.width / count;
    CGFloat height = self.bounds.size.height;
    NSInteger i = 0;
    CGFloat btnX = 0;
    for (UIControl *tbBtn in self.subviews) {
        if ([tbBtn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (i == self.items.count - 1) {
                i += 1;
            }
            btnX = i * width;
            tbBtn.frame = CGRectMake(btnX, 0, width, height);
            i++;
        }
    }
    
    // 最后添加"+"按钮,只添加一次使用懒加载
    self.plusBtn.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 - 10);
}

- (UIButton *)plusBtn {
    if (_plusBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        _plusBtn = btn;
        [_plusBtn setImage:[UIImage imageNamed:@"secondary_add"] forState:UIControlStateNormal];
        [_plusBtn addTarget:self action:@selector(plusAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_plusBtn];
        [_plusBtn sizeToFit];
    }
    return _plusBtn;
}

- (void)plusAction:(UIButton *)plusBtn {
    UIViewController *topVc = [[AppDelegate shareAppDelegate] topVC:[UIApplication sharedApplication].keyWindow.rootViewController];
    XDSecondaryPublishController *publish = [[XDSecondaryPublishController alloc] init];
    [topVc.navigationController pushViewController:publish animated:NO];
}

@end
