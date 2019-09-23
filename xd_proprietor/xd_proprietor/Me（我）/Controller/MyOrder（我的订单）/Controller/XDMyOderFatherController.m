//
//  XDMyOderFatherController.m
//  XD业主
//
//  Created by zc on 2018/3/15.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDMyOderFatherController.h"
#import "XDMyPlaceOrderController.h"
#import "XDMyPayforOrderController.h"
#import "XDMyCancelOrderController.h"
#import "XDMyFinishOrderController.h"

#define MarginH 35

@interface XDMyOderFatherController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollerView;

@property (strong, nonatomic) UIView *bgView;
/** 记录上一次选中的Button */
@property (nonatomic , weak) UIButton *selectBtn;
/* 标题按钮地下的指示器 */
@property (weak ,nonatomic) UIView *indicatorView;

@end

@implementation XDMyOderFatherController

- (UIScrollView *)scrollerView
{
    if (!_scrollerView) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollerView.frame = self.view.bounds;
        _scrollerView.showsVerticalScrollIndicator = NO;
        _scrollerView.showsHorizontalScrollIndicator = NO;
        _scrollerView.pagingEnabled = YES;
        _scrollerView.bounces = NO;
        _scrollerView.delegate = self;
        [self.view addSubview:_scrollerView];
    }
    return _scrollerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpChildViewControllers];
    
    [self setUpInit];
    
    [self setUpTopButtonView];
    
    [self addChildViewController];
    
}

#pragma mark - 添加子控制器
-(void)setUpChildViewControllers
{
    
    XDMyPlaceOrderController *placeOrder = [[XDMyPlaceOrderController alloc] init];
    [self addChildViewController:placeOrder];
    
    XDMyPayforOrderController *payOrder = [[XDMyPayforOrderController alloc] init];
    [self addChildViewController:payOrder];
    
    XDMyCancelOrderController *cancelOrder = [[XDMyCancelOrderController alloc] init];
    [self addChildViewController:cancelOrder];
    
    XDMyFinishOrderController *finishOrder = [[XDMyFinishOrderController alloc] init];
    [self addChildViewController:finishOrder];
}

#pragma mark - initialize
- (void)setUpInit
{
    self.view.backgroundColor = backColor;
    self.scrollerView.backgroundColor = self.view.backgroundColor;
    self.scrollerView.contentSize = CGSizeMake(self.view.width * self.childViewControllers.count, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"我的订单";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(turnToPayed) name:@"refreshMyPlaceOrderList" object:nil];
}

- (void)turnToPayed {
    UIButton *firstButton = _bgView.subviews[1];
    [self topBottonClick:firstButton]; 
}
#pragma mark - 头部View
- (void)setUpTopButtonView
{
//    已下单/1已支付/2已取消/3已完成
    NSArray *titles = @[@"已下单",@"已支付",@"已取消",@"已完成"];
    
    CGFloat buttonH = MarginH;
    CGFloat buttonW = kScreenWidth/4;
    CGFloat buttonY = 0;
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, buttonH)];
    _bgView.backgroundColor = backColor;
    [self.view addSubview:_bgView];
    
    for (NSInteger i = 0; i < titles.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titles[i] forState:0];
        [button setTitleColor:RGB(74, 74, 74) forState:UIControlStateNormal];
        button.tag = i;
        button.titleLabel.font = SFont(16);
        [button addTarget:self action:@selector(topBottonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonX = i * buttonW;
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        [_bgView addSubview:button];

    }
    
    for (NSInteger i = 0; i < titles.count; i++) {
        
        if (i <= 2) {
            UIView *linview = [[UIView alloc] initWithFrame:CGRectMake(buttonW *(i+1), buttonH/4, 1, buttonH/2)];
            linview.backgroundColor = [UIColor lightGrayColor];
            [_bgView addSubview:linview];
        }
    }
    
    UIView *linview = [[UIView alloc] initWithFrame:CGRectMake(0, buttonH-1, kScreenWidth, 1)];
    linview.backgroundColor = RGB(200, 200, 200);
    [_bgView addSubview:linview];
    
    UIButton *firstButton = _bgView.subviews[0];
    [self topBottonClick:firstButton]; //默认选择第一个
    
    UIView *indicatorView = [[UIView alloc]init];
    self.indicatorView = indicatorView;
    indicatorView.backgroundColor = [firstButton titleColorForState:UIControlStateSelected];
    
    indicatorView.height = 2;
    indicatorView.y = _bgView.height - indicatorView.height;
    
    [firstButton.titleLabel sizeToFit];
    indicatorView.width = firstButton.titleLabel.width;
    indicatorView.centerX = firstButton.centerX;
    
    [_bgView addSubview:indicatorView];
    
}


#pragma mark - 添加子控制器View
-(void)addChildViewController
{
    NSInteger index = _scrollerView.contentOffset.x / _scrollerView.width;
    UIViewController *childVc = self.childViewControllers[index];
    
    if (childVc.view.superview) return; //判断添加就不用再添加了
    childVc.view.frame = CGRectMake(index * _scrollerView.width, MarginH , _scrollerView.width, _scrollerView.height- MarginH-KYTopNavH);
    [_scrollerView addSubview:childVc.view];
    
}

#pragma mark - <UIScrollViewDelegate>
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self addChildViewController];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    UIButton *button = _bgView.subviews[index];
    
    [self topBottonClick:button];
    
    [self addChildViewController];
}
#pragma mark - 头部按钮点击
- (void)topBottonClick:(UIButton *)button
{
    button.selected = !button.selected;
    [_selectBtn setTitleColor:RGB(74, 74, 74) forState:UIControlStateNormal];
    [button setTitleColor:RGB(208, 175, 107) forState:UIControlStateNormal];
    
    _selectBtn = button;
    
    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.indicatorView.width = button.titleLabel.width;
        weakSelf.indicatorView.centerX = button.centerX;
    }];
    
    CGPoint offset = _scrollerView.contentOffset;
    offset.x = _scrollerView.width * button.tag;
    [_scrollerView setContentOffset:offset animated:YES];
}

@end
