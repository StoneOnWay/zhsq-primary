//
//  CFLBannerView.h
//  cfl
//
//  Created by zc on 17/1/13.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CFLBannerView;
@protocol CFLBannerViewDelegate <NSObject>

- (void)bannerView:(CFLBannerView *)view didSelectImageView:(UIImageView *)imageView;

@end

@interface CFLBannerView : UIView<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *bannerScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *bannerPageController;


/*图片的URL*/
@property (nonatomic, strong) NSMutableArray *images;

/*图片轮播定时器*/
@property(strong ,nonatomic) NSTimer *bannerTimer;

/*图片轮播时间间隔*/
@property(assign ,nonatomic) NSTimeInterval interval;

@property (nonatomic, weak) id<CFLBannerViewDelegate> delegate;

/*加载控件*/
+ (id)bannerView;

/*创建定时器*/
- (void)creatTimer;

/*停止定时器*/
- (void)stopTimer;


@end
