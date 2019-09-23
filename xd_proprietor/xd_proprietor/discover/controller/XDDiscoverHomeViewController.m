//
//  XDDiscoverHomeViewController.m
//  xd_proprietor
//
//  Created by mason on 2018/9/4.
//Copyright © 2018年 zc. All rights reserved.
//

#import "XDDiscoverHomeViewController.h"
#import "XDDiscoverViewController.h"
#import "HMSegmentedControl.h"
#import "XDFunActivityViewController.h"
#import "XDActivityViewController.h"
#import "XDFunAddViewController.h"
#import "XDFunDetailViewController.h"

@interface XDDiscoverHomeViewController ()
<
UIPageViewControllerDelegate,
UIPageViewControllerDataSource
>

@property (strong, nonatomic) UIPageViewController *pageViewController;
/** controller数组 */
@property (strong, nonatomic) NSMutableArray *viewControllerArray;
/** 当前位置 */
@property (assign, nonatomic) NSInteger currentIndex;
/** <##> */
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;


@end

@implementation XDDiscoverHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configLeftNavigationBar];
    self.title = @"邻里圈";

    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    XDFunActivityViewController *funActivityVC = [XDFunActivityViewController create];
//    XDActivityViewController *activityVC = [XDActivityViewController new];
    [self.viewControllerArray addObjectsFromArray:@[funActivityVC]];
    
    [self.pageViewController setViewControllers:@[[self.viewControllerArray objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNav) name:@"hasBindOwnerSuccessNoti" object:nil];
}

- (void)updateNav {
    [self configLeftNavigationBar];
}

- (void)configLeftNavigationBar {
//    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"新鲜事", @"活动"]];
//    segmentedControl.frame = CGRectMake(0, 0, kScreenWidth - 100.f, 44.f);
//    segmentedControl.backgroundColor = UIColorHex(2c3447);
//    segmentedControl.type = HMSegmentedControlTypeText;
//    segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
//    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
//    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
//    segmentedControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f], NSForegroundColorAttributeName: UIColorHex(cfcfcf)};
//    segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f], NSForegroundColorAttributeName: UIColorHex(fe552e)};
//    segmentedControl.selectionIndicatorColor = UIColorHex(fe552e);
//    segmentedControl.selectionIndicatorHeight = 3.f;
//    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
////    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
////    self.navigationItem.leftBarButtonItem = leftButtonItem;
//    self.segmentedControl = segmentedControl;
//    self.navigationItem.titleView = segmentedControl;
    
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    if (!loginModel.userInfo.userId) {
        return;
    }
    
    CGFloat top = (NavHeight-StatusBarHeight - 20.f) / 2;
    UIButton *mapbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mapbutton setFrame:CGRectMake(35.f, top, 20.f, 20.f)];
    [mapbutton setImage:[UIImage imageNamed:@"btn_home_add"]forState:UIControlStateNormal];
    [mapbutton addTarget:self action:@selector(addClick)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:mapbutton];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)addClick {
    XDFunAddViewController *funAddVc = [[UIStoryboard storyboardWithName:@"XDDiscoverHomeViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"XDFunAddViewController"];
    funAddVc.didPublishSuccess = ^{
        XDFunActivityViewController *funActivityVC = self.viewControllerArray.firstObject;
        for (XDDiscoverViewController *discoverVC in funActivityVC.viewControllerArray) {
            if (discoverVC.flag != 2) {
                // 关注的不需要刷新
                [discoverVC.collectionView.mj_header beginRefreshing];
            }
        }
    };
    [self.navigationController pushViewController:funAddVc animated:YES];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    UIPageViewControllerNavigationDirection pageViewControllerNavigationDirection = self.currentIndex < segmentedControl.selectedSegmentIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    self.currentIndex = segmentedControl.selectedSegmentIndex;
    [self.pageViewController setViewControllers:@[[self.viewControllerArray objectAtIndex:segmentedControl.selectedSegmentIndex]] direction:pageViewControllerNavigationDirection animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[UIPageViewController class]]) {
        self.pageViewController = segue.destinationViewController;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self indexOfController:viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    return [self.viewControllerArray objectAtIndex:index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self indexOfController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == self.viewControllerArray.count) {
        return nil;
    }
    return [self.viewControllerArray objectAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        self.currentIndex = [self indexOfController:[pageViewController.viewControllers lastObject]];
        self.segmentedControl.selectedSegmentIndex = self.currentIndex;
    }
}

- (NSInteger) indexOfController:(UIViewController *)viewController {
    for (NSInteger i = 0; i < self.viewControllerArray.count; i++) {
        if (viewController == [self.viewControllerArray objectAtIndex:i]) {
            return i;
        }
    }
    return NSNotFound;
}

- (NSMutableArray *)viewControllerArray {
    if (!_viewControllerArray) {
        _viewControllerArray = [NSMutableArray array];
    }
    return _viewControllerArray;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hasBindOwnerSuccessNoti" object:nil];
}


@end
