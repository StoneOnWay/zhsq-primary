//
//  XDTradeListController.m
//  xd_proprietor
//
//  Created by stone on 30/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDTradeListController.h"

@interface XDTradeListController ()

@end

@implementation XDTradeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"二手市场";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_btn_back" frame:CGRectMake(0, 0, 30, 30) target:self action:@selector(goBack)];
}

- (void)goBack {
    [AppDelegate shareAppDelegate].window.rootViewController = [AppDelegate shareAppDelegate].tabBarViewController;
}


@end
