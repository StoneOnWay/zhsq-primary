//
//  BaseTabBarViewController.m
//  XD业主
//
//  Created by zc on 2017/6/16.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "BaseNavigationController.h"
#import "XDHomeViewController.h"
#import "XDOwnViewController.h"
//#import "XDNeighborController.h"
#import "XDDiscoverHomeViewController.h"
#import "XDMessageViewController.h"
#import "XDHomePageViewController.h"
#import "XDMyViewController.h"

@interface BaseTabBarViewController ()<UITabBarControllerDelegate>

@property(nonatomic ,strong) UIViewController *lastViewController;
@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.tabBar.tintColor = RGB(44, 52, 71);
    //去掉分割线
//    [self.tabBar setClipsToBounds:YES];
    //设置tabbar的背景
    self.hidesBottomBarWhenPushed = YES;
//    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -2, kScreenWidth, 50)];
//    backView.image = [UIImage imageNamed:@"home_tabbar"];
//    [self.tabBar insertSubview:backView atIndex:0];
//    self.tabBar.translucent = NO;

    [self initChildViewControllers];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    // UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
    return UIStatusBarStyleLightContent;
}

- (void)initChildViewControllers {
    NSMutableArray *childVCArray = [[NSMutableArray alloc] initWithCapacity:3];
    //添加两个子控件
    XDHomePageViewController *homeVC = [XDHomePageViewController new];
    [self setViewController:homeVC title:@"首页" normalImage:@"btn_tab_home_nor" selectedImage:@"btn_tab_home_sel" vcList:childVCArray];
    
    XDDiscoverHomeViewController *discoverVC = [XDDiscoverHomeViewController create];
    [self setViewController:discoverVC title:@"邻里圈" normalImage:@"btn_tab_find_nor" selectedImage:@"btn_tab_find_sel" vcList:childVCArray];
    
//    XDMessageViewController *messageVC = [XDMessageViewController new];
//    [self setViewController:messageVC title:@"消息" normalImage:@"btn_tab_news_nor" selectedImage:@"btn_tab_news_sel" vcList:childVCArray];
    
    XDMyViewController *ownVC = [XDMyViewController new];
    ownVC.tabBarController.delegate = self;
    [self setViewController:ownVC title:@"我" normalImage:@"btn_tab_my_nor" selectedImage:@"btn_tab_my_sel" vcList:childVCArray];
   
    self.viewControllers = childVCArray;
}

- (void)setViewController:(UIViewController *)vc title:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage vcList:(NSMutableArray *)vcList {
    [vc.tabBarItem setTitle:title];
    [vc.tabBarItem setImage:[UIImage imageNamed:normalImage]];
    [vc.tabBarItem setSelectedImage:[UIImage imageNamed:selectedImage]];
    BaseNavigationController *discoverNavC = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [vcList addObject:discoverNavC];
}

//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
//{
//    if([viewController isKindOfClass:[XDNeighborController class]])    //"我的账号"
//    {
//        if (![self.lastViewController isKindOfClass:[XDNeighborController class]]) {
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshNeighbor" object:nil];
//        }
//       
//    }
//    self.lastViewController = viewController;
//    return YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
