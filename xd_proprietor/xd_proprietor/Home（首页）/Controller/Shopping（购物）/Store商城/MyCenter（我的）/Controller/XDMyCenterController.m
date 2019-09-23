//
//  XDMyCenterController.m
//  XD业主
//
//  Created by zc on 2018/3/6.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDMyCenterController.h"

@interface XDMyCenterController ()

@end

@implementation XDMyCenterController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"我的先导";
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backColor;
    
    
}


@end
