//
//  XDFunActivityViewController.m
//  xd_proprietor
//
//  Created by mason on 2018/9/4.
//Copyright © 2018年 zc. All rights reserved.
//

#import "XDFunActivityViewController.h"

#import "XDDiscoverViewController.h"
#import "HMSegmentedControl.h"

@interface XDFunActivityViewController ()
<
UIPageViewControllerDelegate,
UIPageViewControllerDataSource
>

@property (weak, nonatomic) IBOutlet UIView *segmentdControlContainView;

@property (strong, nonatomic) UIPageViewController *pageViewController;

/** <##> */
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;


@end

@implementation XDFunActivityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configLeftNavigationBar];
    
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    XDDiscoverViewController *notificationListVC = [XDDiscoverViewController new];
    notificationListVC.flag = 1;
    XDDiscoverViewController *notificationListVC2 = [XDDiscoverViewController new];
    notificationListVC2.flag = 2;
    XDDiscoverViewController *notificationListVC3 = [XDDiscoverViewController new];
    notificationListVC3.flag = 3;
    [self.viewControllerArray addObjectsFromArray:@[notificationListVC, notificationListVC2, notificationListVC3]];
    // 点赞后关联刷新
    notificationListVC.relationVcArray = self.viewControllerArray;
    notificationListVC2.relationVcArray = self.viewControllerArray;
    notificationListVC3.relationVcArray = self.viewControllerArray;
    
    [self.pageViewController setViewControllers:@[[self.viewControllerArray objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (void)configLeftNavigationBar {
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部", @"关注", @"我的"]];
    segmentedControl.frame = CGRectMake(0, 0, kScreenWidth, 40.f);
    segmentedControl.backgroundColor = UIColorHex(ffffff);
    segmentedControl.type = HMSegmentedControlTypeText;
    segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f], NSForegroundColorAttributeName: UIColorHex(353535)};
    segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f], NSForegroundColorAttributeName: UIColorHex(aaaaaa)};
    segmentedControl.selectionIndicatorColor = UIColorHex(aaaaaa);
    segmentedControl.selectionIndicatorHeight = 2.f;
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl = segmentedControl;
    [self.segmentdControlContainView addSubview:segmentedControl];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    UIPageViewControllerNavigationDirection pageViewControllerNavigationDirection = self.currentIndex < segmentedControl.selectedSegmentIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    self.currentIndex = segmentedControl.selectedSegmentIndex;
    [self.pageViewController setViewControllers:@[[self.viewControllerArray objectAtIndex:segmentedControl.selectedSegmentIndex]] direction:pageViewControllerNavigationDirection animated:YES completion:nil];
//    XDDiscoverViewController *discoverVC = self.viewControllerArray[segmentedControl.selectedSegmentIndex];
//    [discoverVC.collectionView.mj_header beginRefreshing];
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
//        XDDiscoverViewController *discoverVC = self.viewControllerArray[self.currentIndex];
//        [discoverVC.collectionView.mj_header beginRefreshing];
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

@end
