//
//  DCTabBarController.m
//  CDDMall
//
//  Created by apple on 2017/5/26.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//


#import "DCTabBarController.h"
#import "XDHomePageController.h"

@interface DCTabBarController ()<UITabBarControllerDelegate>


@property (nonatomic, strong) NSMutableArray *tabBarItems;
//给item加上badge
@property (nonatomic, weak) UITabBarItem *item;

@end

@implementation DCTabBarController

#pragma mark - LazyLoad
- (NSMutableArray *)tabBarItems {
    
    if (_tabBarItems == nil) {
        _tabBarItems = [NSMutableArray array];
    }
    
    return _tabBarItems;
}

#pragma mark - initialize
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.tabBar.tintColor = RGB(214, 176, 91);
    [self.tabBar setClipsToBounds:YES];

    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -2, kScreenWidth, 50)];
    backView.image = [UIImage imageNamed:@"home_tabbar"];
    [self.tabBar insertSubview:backView atIndex:0];
    self.tabBar.translucent = NO;

}


- (void)setShopModel:(XDShoppingModel *)shopModel {
    _shopModel = shopModel;
    [self addDcChildViewContorller];
}
#pragma mark - 添加子控制器
- (void)addDcChildViewContorller
{
    
    NSArray *childArray = @[
                           
                            @{MallClassKey  : @"XDHomePageController",
                              MallTitleKey  : @"首页",
                              MallImgKey    : @"class_profile",
                              MallSelImgKey : @"class_selected"},
             
                            @{MallClassKey  : @"XDShoppingCartController",
                              MallTitleKey  : @"购物车",
                              MallImgKey    : @"buycar_profilet",
                              MallSelImgKey : @"buycar_selected"},
                            
                            @{MallClassKey  : @"XDMyCenterController",
                              MallTitleKey  : @"我的",
                              MallImgKey    : @"btn_wode_2",
                              MallSelImgKey : @"btn_wode"},
                            
                            ];
    [childArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIViewController *vc = [NSClassFromString(dict[MallClassKey]) new];
        if ([vc isKindOfClass:[XDHomePageController class]]) {
            XDHomePageController *homePage = (XDHomePageController *)vc;
            homePage.shopModel = self.shopModel;
        }
        UITabBarItem *item = vc.tabBarItem;
        item.title = [NSString stringWithFormat:@"%@",dict[MallTitleKey]];
        item.image = [UIImage imageNamed:dict[MallImgKey]];
        item.selectedImage = [UIImage imageNamed:dict[MallSelImgKey]];
//        item.imageInsets = UIEdgeInsetsMake(6, 0,-10, 0);//（当只有图片的时候）需要自动调整
        [self addChildViewController:vc];

        // 添加tabBarItem至数组
        [self.tabBarItems addObject:vc.tabBarItem];
    }];
}

#pragma mark - 控制器跳转拦截
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if(viewController == [tabBarController.viewControllers objectAtIndex:DCTabBarControllerPerson]){

        [tabBarController.navigationController popToRootViewControllerAnimated:NO];

        BaseTabBarViewController *tab = [AppDelegate shareAppDelegate].tabBarViewController;
        tab.selectedIndex = 1;
    
        return NO;
    }
    return YES;
}

#pragma mark - <UITabBarControllerDelegate>
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //点击tabBarItem动画只能都是图片
//    [self tabBarButtonClick:[self getTabBarButton]];
    
//    if ([self.childViewControllers.firstObject isEqual:viewController]) { //根据tabBar的内存地址找到美信发通知jump
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"jump" object:nil];
//    }

}
- (UIControl *)getTabBarButton{
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc]initWithCapacity:0];

    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            [tabBarButtons addObject:tabBarButton];
        }
    }
    UIControl *tabBarButton = [tabBarButtons objectAtIndex:self.selectedIndex];
    
    return tabBarButton;
}

#pragma mark - 点击动画
- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    for (UIView *imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            //需要实现的帧动画,这里根据自己需求改动
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.2,@0.8,@1.0];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            //添加动画
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
    
}

#pragma mark - 更新badgeView
- (void)updateBadgeValue
{
//    _beautyMsgVc.tabBarItem.badgeValue = [DCObjManager dc_readUserDataForKey:@"isLogin"];
}

#pragma mark - 移除通知
- (void)dealloc {
    [_item removeObserver:self forKeyPath:@"badgeValue"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 禁止屏幕旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}

@end
