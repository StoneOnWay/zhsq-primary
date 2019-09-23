//
//  XDWorkProgressSuperTableViewCell.m
//  zhangyongTest
//
//  Created by Cody on 2017/5/22.
//  Copyright © 2017年 Cody. All rights reserved.
//

#import "XDWorkProgressSuperTableViewCell.h"

@implementation XDWorkProgressSuperTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UILabel *)timeLabel{
    return [self viewWithTag:100];
}

- (UILabel *)statusLabel{
    return [self viewWithTag:101];
}

- (UILabel *)statusLabel1{
    return [self viewWithTag:105];
}

- (UIImageView *)pointImage {

    return [self viewWithTag:102];
}
- (UILabel *)remarkLabel {
    return [self viewWithTag:203];
}

- (UIView *)statusBackBigView {
    return [self viewWithTag:205];
}

- (UIView *)statusBackView{
    return [self viewWithTag:0];
}


- (CAAnimation *)progressiveAnimation:(NSTimeInterval)time{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    
    animation.autoreverses = YES;
    
    animation.duration = time;
    
    animation.repeatCount = MAXFLOAT;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    
    return animation;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsProgressive:(BOOL)isProgressive{
    _isProgressive = isProgressive;
    
    
 
    if (isProgressive) {
        
        NSArray * animationKeys =  self.statusBackView.layer.animationKeys;

        if (animationKeys.count <=0) {
            [self.statusBackView.layer removeAllAnimations];
            [self.statusBackView.layer addAnimation:[self progressiveAnimation:1] forKey:@"animation"];
        }else{
            [self demosAnimationContinue:self.statusBackView];

        }
        
        
    }else{
        [self demosAnimationPause:self.statusBackView];

    }
}

//暂停
- (void)demosAnimationPause:(UIView *)view {
    // 将当前时间CACurrentMediaTime转换为layer上的时间, 即将parent time转换为localtime
    CFTimeInterval pauseTime = [view.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    // 设置layer的timeOffset, 在继续操作也会使用到
    view.layer.timeOffset = pauseTime;
    
    // localtime与parenttime的比例为0, 意味着localtime暂停了
    view.layer.speed = 0;
}

//恢复
- (void)demosAnimationContinue:(UIView *)view {
    // 时间转换
    CFTimeInterval pauseTime = view.layer.timeOffset;
    // 计算暂停时间
    CFTimeInterval timeSincePause =CACurrentMediaTime() - pauseTime;
    // 取消
    view.layer.timeOffset = 0;
    // local time相对于parent time世界的beginTime
    view.layer.beginTime = timeSincePause;
    // 继续
    view.layer.speed = 1;
    
    
}

@end
