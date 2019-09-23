//
//  PCHomeContainerView.m
//  yunshangyi
//
//  Created by mason on 2018/3/28.
//
//

#import "PCHomeContainerView.h"

@interface PCHomeContainerView ()
<
UIPageViewControllerDelegate,
UIPageViewControllerDataSource
>
/** 容器view */
@property (strong, nonatomic) UIView *containerview;
/**<##> */
@property (strong, nonatomic) UIPageViewController *pageViewController;
/** 当前选中的页面<##> */
@property (assign, nonatomic) NSInteger currentSelectedIndex;
/**  */
@property (strong, nonatomic) NSArray *pageViewControllers;

@end

@implementation PCHomeContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupContainerView];
        self.currentSelectedIndex = 0;
    }
    return self;
}

#pragma mark - 初始化
- (void) initPageVC {
    self.pageViewControllers = [self.delegate pageViewControllers];
    if ([self.delegate swipeGesturesAnimated]) {
        self.pageViewController.delegate = self;
        self.pageViewController.dataSource = self;
    }
    [self.pageViewController setViewControllers:@[[self.pageViewControllers objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

#pragma mark - setup UI
- (void) setupContainerView {
    UIPageViewController *pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.containerview = [[UIView alloc] init];
    self.containerview = pageVC.view;
    self.containerview.frame = self.bounds;
    [self addSubview:self.containerview];
    self.pageViewController = pageVC;
}

- (void) didSelectedItemWithIndex:(NSInteger)index {
    if (index > self.pageViewControllers.count - 1) {
        return;
    }
    UIPageViewControllerNavigationDirection directon = UIPageViewControllerNavigationDirectionForward;
    if (self.currentSelectedIndex > index) {
        directon = UIPageViewControllerNavigationDirectionReverse;
    }
    [self.pageViewController setViewControllers:@[[self.pageViewControllers objectAtIndex:index]] direction:directon animated:[self.delegate switchAnimated] completion:nil];
    self.currentSelectedIndex = index;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    NSInteger index = [self indexWithViewController:pageViewController.viewControllers.lastObject];
    self.currentSelectedIndex = index;
    if ([self.delegate respondsToSelector:@selector(didSelectedIndex:)]) {
        [self.delegate didSelectedIndex:index];
    }
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self indexWithViewController:viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    return [self.pageViewControllers objectAtIndex:index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self indexWithViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == self.pageViewControllers.count) {
        return nil;
    }
    return [self.pageViewControllers objectAtIndex:index];
}

- (NSInteger) indexWithViewController:(UIViewController *)viewController {
    for (NSInteger i = 0; i < self.pageViewControllers.count; i++) {
        if (viewController == self.pageViewControllers[i]) {
            return i;
        }
    }
    return NSNotFound;
}

- (NSArray *)pageViewControllers {
    if (!_pageViewControllers) {
        _pageViewControllers = @[];
    }
    return _pageViewControllers;
}

@end


















