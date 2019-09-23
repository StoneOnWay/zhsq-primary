//
//  XDSecondaryTabBarController.m
//  xd_proprietor
//
//  Created by stone on 30/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDSecondaryTabBarController.h"
#import "BaseNavigationController.h"
#import "XDTradeListController.h"
#import "XDMarketOwnerController.h"
#import "XDTabBar.h"

@interface XDSecondaryTabBarController () <UITabBarControllerDelegate>

@end

@implementation XDSecondaryTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self initChildViewControllers];
}

- (void)setupTabbar {
    XDTabBar *tabbar = [[XDTabBar alloc] init];
    [self setValue:tabbar forKey:@"tabBar"];
}

-(void)initChildViewControllers {
//    NSMutableArray *childVCArray = [[NSMutableArray alloc] initWithCapacity:3];
    XDTradeListController *listVC = [XDTradeListController new];
    [self setViewController:listVC title:@"市场" normalImage:@"secondary_market" selectedImage:@"secondary_market_selected"];
    XDMarketOwnerController *ownVC = [XDMarketOwnerController new];
    [self setViewController:ownVC title:@"我的" normalImage:@"secondary_own" selectedImage:@"secondary_own_selected"];
    // 使用这种方式设置自控制器会有默认不选中的问题
//    self.viewControllers = childVCArray;
    // 自定义tabbar
    [self setupTabbar];
}

- (void)setViewController:(UIViewController *)vc title:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage {
    [vc.tabBarItem setTitle:title];
    [vc.tabBarItem setImage:[UIImage imageNamed:normalImage]];
    [vc.tabBarItem setSelectedImage:[UIImage imageNamed:selectedImage]];
    BaseNavigationController *naVC = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:naVC];
}

@end
