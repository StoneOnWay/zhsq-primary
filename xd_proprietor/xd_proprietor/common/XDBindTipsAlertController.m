//
//  XDBindTipsAlertController.m
//  xd_proprietor
//
//  Created by cfsc on 2019/7/5.
//  Copyright © 2019年 zc. All rights reserved.
//

#import "XDBindTipsAlertController.h"

@interface XDBindTipsAlertController ()

@end

@implementation XDBindTipsAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle {
    XDBindTipsAlertController *alertVC = [XDBindTipsAlertController alertControllerWithTitle:@"绑定业主" message:@"未绑定业主，App部分功能受限！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"前往绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"稍后绑定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:sureAction];
    [alertVC addAction:cancelAction];
    return alertVC;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
