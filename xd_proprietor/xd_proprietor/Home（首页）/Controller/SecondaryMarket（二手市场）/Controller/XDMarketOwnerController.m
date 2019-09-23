//
//  XDMarketOwnerController.m
//  xd_proprietor
//
//  Created by stone on 30/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDMarketOwnerController.h"

@interface XDMarketOwnerController ()

@end

@implementation XDMarketOwnerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_btn_back" frame:CGRectMake(0, 0, 30, 30) target:self action:@selector(goBack)];
}

- (void)goBack {
    [AppDelegate shareAppDelegate].window.rootViewController = [AppDelegate shareAppDelegate].tabBarViewController;
}

@end
