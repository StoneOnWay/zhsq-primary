//
//  KYRefreshView.m
//  XD业主
//
//  Created by zc on 2017/6/27.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "KYRefreshView.h"
@interface KYRefreshView ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UILabel *label;

@end

@implementation KYRefreshView

+ (KYRefreshView*)sharedView {
    
    static dispatch_once_t once;
    static KYRefreshView *sharedView;
#if !defined(SV_APP_EXTENSIONS)
    dispatch_once(&once, ^{
        UIWindow *window=[[UIApplication sharedApplication].delegate window];
        sharedView = [[self alloc] initWithFrame:window.bounds];
    });
#else
    dispatch_once(&once, ^{
        sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
#endif
    return sharedView;
}

- (void)setUpSubView:(KYRefreshView *)refreshView{
    
    //添加大背景
    self.backView = [[UIView alloc] initWithFrame:refreshView.bounds];
    [refreshView addSubview:self.backView];
    self.label.hidden = YES;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        UIView *views = [[UIView alloc] initWithFrame:refreshView.bounds];
        views.backgroundColor = [UIColor blackColor];;
        views.alpha = 0.1;
        [self.backView addSubview:views];
        
        //图片控件,坐标和大小
        UIImageView *imageView=[[UIImageView alloc]init];
        imageView.width = 80;
        imageView.height = 80;
        imageView.centerX = refreshView.centerX;
        imageView.centerY = refreshView.centerY;
        
        // 给图片控件添加图片对象
        [imageView setImage:[UIImage imageNamed:@"loading_image0"]];
        //图片控件添加到视图上面去
        [self.backView addSubview:imageView];
        
        //创建一个可变数组
        NSMutableArray *ary=[NSMutableArray new];
        for(int I=0;I< 10;I++){
            //通过for 循环,把我所有的 图片存到数组里面
            NSString *imageName=[NSString stringWithFormat:@"loading_image%d",I];
            UIImage *image=[UIImage imageNamed:imageName];
            [ary addObject:image];
        }
        
        // 设置图片的序列帧 图片数组
        imageView.animationImages=ary;
        //动画重复次数
        imageView.animationRepeatCount = MAXFLOAT;
        //动画执行时间,多长时间执行完动画
        imageView.animationDuration=1.0;
        //开始动画
        [imageView startAnimating];
        
    });
    
}

- (void)setUpWithStatus:(NSString *)status SubView:(KYRefreshView *)refreshView{
    
    //添加大背景
    self.backView = [[UIView alloc] initWithFrame:refreshView.bounds];
    [refreshView addSubview:self.backView];
    
    self.label.hidden = NO;
    self.label.text = status;
    self.label.width = [self evaluteTextWidth:self.label];
    self.label.height = 40;
    self.label.centerX = refreshView.centerX;
    self.label.centerY = refreshView.centerY;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        UIView *views = [[UIView alloc] initWithFrame:refreshView.bounds];
        views.backgroundColor = [UIColor blackColor];;
        views.alpha = 0.1;
        [self.backView addSubview:views];
        //图片控件添加到视图上面去
        [self.backView addSubview:self.label];
        
    });
    
}


- (CGFloat)evaluteTextWidth:(UILabel *)label {
    
    NSDictionary *textAtt = @{NSFontAttributeName : label.font};
    
    CGSize evaluteLabelSize = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size;
    CGFloat evaluteLabelSizeW = evaluteLabelSize.width;
    
    return evaluteLabelSizeW +16;
}


+ (void)show {
    
    UIWindow *window=[[UIApplication sharedApplication].delegate window];
    KYRefreshView *refreshView = [self sharedView];
    [refreshView setUpSubView:refreshView];
    [window addSubview:refreshView];
    
}

+ (void)showWithStatus:(NSString *)status {
    
    UIWindow *window=[[UIApplication sharedApplication].delegate window];
    KYRefreshView *refreshView = [self sharedView];
    [refreshView setUpWithStatus:status SubView:refreshView];
    
    [window addSubview:refreshView];
    
}


+ (void)dismiss {
    
    [self sharedView].backView = nil;
    [[self sharedView].backView removeFromSuperview];
    [[self sharedView] removeFromSuperview];
    
}


+ (void)dismissDeleyWithDuration:(CGFloat)deley {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(deley * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self dismiss];
        
    });
    
}

- (UILabel *)label {
    if (_label) {
        return _label;
    }
    _label = [[UILabel alloc]init];
    _label.font = CFont(13, 14);
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    _label.backgroundColor = [UIColor blackColor];
    _label.layer.cornerRadius = 10;
    [_label.layer setMasksToBounds:YES];
    return _label;
}

- (void)dealloc {
    
    
}


@end
