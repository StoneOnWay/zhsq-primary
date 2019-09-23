//
//  CFLBannerView.m
//  cfl
//
//  Created by zc on 17/1/13.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "CFLBannerView.h"
#import "UIImageView+WebCache.h"



@interface CFLBannerView ()

/*用于实现无线循序*/
@property (nonatomic, strong) NSMutableArray *imgs;

@end
@implementation CFLBannerView

- (NSMutableArray *)imgs{
    if (!_imgs) {
        _imgs = [NSMutableArray array];
    }
    return _imgs;
}

+ (id)bannerView{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}


- (void)setImages:(NSMutableArray *)images{
    _images = images;
    
    
    for (UIView *view in self.bannerScrollView.subviews) {
        if ([view isMemberOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    [self.imgs removeAllObjects];
    
    //把最后一张图片放在第一张位置
    [self.imgs addObject:images[images.count - 1]];
    
    for (int i = 0; i < images.count; i ++) {
        [self.imgs addObject:images[i]];
    }
    
    //把第一张图片放在最后位置
    [self.imgs addObject:images[0]];
    
    // 3.向滚动视图中添加多个图片子视图
    for (int i = 0; i < self.imgs.count; i ++) {
        
        // 创建一个图片视图对象
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        
        // 设置图片视图的位置及大小
        imageView.frame = CGRectMake(i * self.frame.size.width , 0,self.frame.size.width, self.frame.size.height);
        
        // 设置imageView的内容
        
        if ([self.imgs[i] rangeOfString:@"http"].location != NSNotFound) {
            NSString *url = self.imgs[i];
            
            NSLog(@"url:%@",url);
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"banner2"] options:SDWebImageRefreshCached];
            
        }else{
            
            imageView.image = [UIImage imageNamed:self.imgs[i]];
        }
        
        // 将图片视图添加到滚动视图中
        [self.bannerScrollView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        
        [imageView addGestureRecognizer:tap];
    }
    
    //4.设置滚动视图的滚动范围
    self.bannerScrollView.contentSize = CGSizeMake(self.bannerScrollView.subviews.count * self.frame.size.width, 0);
    
    // 配置滚动视图到达边缘时不弹跳
    self.bannerScrollView.bounces = NO;
    
    // 配置滚动视图整页滚动
    self.bannerScrollView.pagingEnabled = YES;
    
    // 配置滚动视图不显示水平滚动条提示
    self.bannerScrollView.showsHorizontalScrollIndicator = NO;
    self.bannerScrollView.showsVerticalScrollIndicator = NO;
    
    self.bannerPageController.numberOfPages = images.count;
    
    [self.bannerScrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
}

- (void)creatTimer {
    self.bannerTimer = [NSTimer scheduledTimerWithTimeInterval:self.interval
                                                        target:self
                                                      selector:@selector(changeScrollOffset)
                                                      userInfo:nil
                                                       repeats:YES];
    // 调整timer 的优先级
    NSRunLoop *mainLoop = [NSRunLoop mainRunLoop];
    
    [mainLoop addTimer:self.bannerTimer forMode:NSRunLoopCommonModes];
}
- (void)changeScrollOffset {
    
    NSInteger page = self.bannerPageController.currentPage;
    
    page ++;
    
    [self.bannerScrollView setContentOffset:CGPointMake(self.frame.size.width  * (page + 1), 0) animated:NO];
    
}
- (void)stopTimer
{
    [self.bannerTimer invalidate];
    self.bannerTimer = nil;
}
#pragma  mark **************UIScrollViewDelegate*******************

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    int index = offsetX / self.frame.size.width;
    if (index == 0) {
        [self.bannerScrollView setContentOffset:CGPointMake(self.frame.size.width * (self.imgs.count-2), 0) animated:NO];
        self.bannerPageController.currentPage = self.images.count - 1;
    }else if (index == self.imgs.count -1){
        [self.bannerScrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
        self.bannerPageController.currentPage = 0;
    }else{
        self.bannerPageController.currentPage = index - 1;
    }
}
/**
 手指开始拖动的时候, 就让计时器停止
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self stopTimer];
    
    self.bannerTimer = nil ;
}
/**
 手指离开屏幕的时候, 就让计时器开始工作
 */
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    [self creatTimer];
}


- (void)tap:(UITapGestureRecognizer *)tapGR{
    UIImageView *imageView = (UIImageView *)tapGR.view;
    
    if ([self.delegate respondsToSelector:@selector(bannerView:didSelectImageView:)]) {
        
        [self.delegate bannerView:self didSelectImageView:imageView];
    }
}





@end
