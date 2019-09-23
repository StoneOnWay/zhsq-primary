//
//  XDWarrantyContainerViewController.m
//  xd_proprietor
//
//  Created by mason on 2018/9/17.
//Copyright © 2018年 zc. All rights reserved.
//

#import "XDWarrantyContainerViewController.h"
#import "XDSegmentedControlView.h"
#import "XDWarrantyHomeViewController.h"
#import <HMSegmentedControl.h>

@interface XDWarrantyContainerViewController ()
<
UIPageViewControllerDelegate,
UIPageViewControllerDataSource,
XDSegmentedControlViewDelegate,
XDWarrantyHomeViewControllerDelegate
>
@property (weak, nonatomic) IBOutlet UIView *topContainerView;

@property (strong, nonatomic) UIPageViewController *pageViewController;
/** controller数组 */
@property (strong, nonatomic) NSMutableArray *viewControllerArray;
/** 当前位置 */
@property (assign, nonatomic) NSInteger currentIndex;
/** <##> */
@property (strong, nonatomic) XDSegmentedControlView *segment;

@property (strong, nonatomic) HMSegmentedControl *segmentControl;

@end

@implementation XDWarrantyContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configView];
    @weakify(self)
    [self configNavigationRightItemWith:@"筛选" andAction:^{
        @strongify(self)
        XDWarrantyHomeViewController *warrantyVC = [XDWarrantyHomeViewController new];
        warrantyVC.title = @"筛选";
        warrantyVC.warrantyPageType = self.warrantyPageType;
        warrantyVC.delegate = self;
        [self.navigationController pushViewController:warrantyVC animated:YES];
    }];
    
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    XDWarrantyListController *funActivityVC = [XDWarrantyListController new];
    funActivityVC.warrantyTaskStatus = XDWarrantyTaskStatusUnFinish;
    funActivityVC.warrantyPageType = self.warrantyPageType;
    
    XDWarrantyListController *activityVC = [XDWarrantyListController new];
    activityVC.warrantyTaskStatus = XDWarrantyTaskStatusFinished;
    activityVC.warrantyPageType = self.warrantyPageType;
    
    [self.viewControllerArray addObjectsFromArray:@[funActivityVC, activityVC]];
    
    [self.pageViewController setViewControllers:@[[self.viewControllerArray objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (void)configView {
//     XDSegmentedControlView *segment = [[XDSegmentedControlView alloc] initWithFrame:self.topContainerView.frame];
//    segment.delegate = self;
//    self.segment = segment;
//    [self.topContainerView addSubview:segment];
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"进行中", @"已完成"]];
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
    self.segmentControl = segmentedControl;
    [self.topContainerView addSubview:segmentedControl];
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
        self.segmentControl.selectedSegmentIndex = self.currentIndex;
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

#pragma mark - Delegate
- (void)didSelectedItemIndex:(NSInteger)index {
    UIPageViewControllerNavigationDirection pageViewControllerNavigationDirection = self.currentIndex < index ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    self.currentIndex = index;
    [self.pageViewController setViewControllers:@[[self.viewControllerArray objectAtIndex:index]] direction:pageViewControllerNavigationDirection animated:YES completion:nil];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    UIPageViewControllerNavigationDirection pageViewControllerNavigationDirection = self.currentIndex < segmentedControl.selectedSegmentIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    self.currentIndex = segmentedControl.selectedSegmentIndex;
    [self.pageViewController setViewControllers:@[[self.viewControllerArray objectAtIndex:segmentedControl.selectedSegmentIndex]] direction:pageViewControllerNavigationDirection animated:YES completion:nil];
}

- (void)filterParameter:(NSDictionary *)parameter {
    XDWarrantyListController *vc = [self.viewControllerArray objectAtIndex:self.currentIndex];
    vc.parameter = [parameter copy];
    [vc loadDataIsFirstPage:YES];
}

- (NSMutableArray *)viewControllerArray {
    if (!_viewControllerArray) {
        _viewControllerArray = [NSMutableArray array];
    }
    return _viewControllerArray;
}

@end
