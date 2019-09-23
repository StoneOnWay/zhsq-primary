//
//  XDCollectView.m
//  XD业主
//
//  Created by zc on 2017/6/16.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDCollectView.h"
#import "XDWarrantyViewController.h"
#import "XDMyConplainController.h"
#import "XDInformNewsListController.h"
#import "XDHomeNearController.h"
#import "XDOpenClokController.h"
#import "XDNeighborController.h"
#import "XDPayforListController.h"
#import "XDPostMessageController.h"
#import "XDShoppingViewController.h"
#import "XDServeceController.h"
#import "DCTabBarController.h"
#import "PresentTransitionAnimated.h"
#import "DismissTransitionAnimated.h"

@interface XDCollectView ()<UIViewControllerTransitioningDelegate>

@end

@implementation XDCollectView

//报事报修
- (IBAction)warranty:(id)sender {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    XDWarrantyViewController *VC= [storyboard instantiateViewControllerWithIdentifier:@"XDWarrantyViewController"];
    [[self viewController].navigationController pushViewController:VC animated:YES];
    
}
//投诉建议
- (IBAction)sugesstions:(id)sender {
    XDMyConplainController *myVC = [[XDMyConplainController alloc] init];
    [[self viewController].navigationController pushViewController:myVC animated:YES];
    
}

//生活缴费
- (IBAction)lifeCost:(id)sender {
    
    XDPayforListController *payfor = [[XDPayforListController alloc] init];
    [[self viewController].navigationController pushViewController:payfor animated:YES];
    
}

//业户通知
- (IBAction)ownerNotice:(id)sender {
    
    XDNotOpenController *onOpen = [[XDNotOpenController alloc] init];
    [[self viewController].navigationController pushViewController:onOpen animated:YES];
    
    
}

//小区公告
- (IBAction)xiaoquAnnouncement:(id)sender {
    
    XDInformNewsListController *informVC = [[XDInformNewsListController alloc] init];
    [[self viewController].navigationController pushViewController:informVC animated:YES];
    
}

//服务
- (IBAction)service:(id)sender {
    
    XDServeceController *servece = [[XDServeceController alloc] init];
    [[self viewController].navigationController pushViewController:servece animated:YES];
    
}

//购物
- (IBAction)shopping:(id)sender {
    
//    DCTabBarController *shopcartVC = [[DCTabBarController alloc] init];
//    shopcartVC.transitioningDelegate = self;
//    [[self viewController] presentViewController:shopcartVC animated:YES completion:nil];
    
    XDShoppingViewController *shopping = [[XDShoppingViewController alloc] init];
    [[self viewController].navigationController pushViewController:shopping animated:YES];
}


//周边
- (IBAction)surrounding:(id)sender {
    
    XDHomeNearController *near = [[XDHomeNearController alloc] init];
    [[self viewController].navigationController pushViewController:near animated:YES];
    
}

//邻里
- (IBAction)near:(id)sender {

    XDNeighborController *neighbor = [[XDNeighborController alloc] init];
    [[self viewController].navigationController pushViewController:neighbor animated:YES];
}


//更多功能
- (IBAction)more:(id)sender {
    XDNotOpenController *onOpen = [[XDNotOpenController alloc] init];
    [[self viewController].navigationController pushViewController:onOpen animated:YES];
}


- (UIViewController *)viewController
{
    //nextResponder是指下一个处理事件的对象，UIApplication, UIViewController,UIView和所有继承自UIView的UIKit类(包括UIWindow,继承自UIView)都直接或间接的继承自UIResponder,所以它们的实例都是responder object对象,都实现了上述4个方法。UIResponder中的默认实现是什么都不做，但UIKit中UIResponder的直接子类(UIView,UIViewController…)的默认实现是将事件沿着responder chain继续向上传递到下一个responder,即nextResponder。所以在定制UIView子类的上述事件处理方法时，如果需要将事件传递给next responder,可以直接调用super的对应事件处理方法，super的对应方法将事件传递给next responder,即使用
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        //(这里跳不出来。。。)有人说这里跳不出来，其实是因为它没有当前这个view放入ViewController中，自然也就跳不出来了，会死循环，使用时需要注意。
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma Mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[PresentTransitionAnimated alloc] init];
}
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[DismissTransitionAnimated alloc] init];
}

@end
