//
//  HBHomeSegmentNavigationBar.m
//  HotBear
//
//  Created by Cody on 2017/3/31.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBHomeSegmentNavigationBar.h"

@implementation HBHomeSegmentNavigationBar
{
    
    
    NSMutableArray <UILabel *>* _itemViews;
    
}

- (id)initWithFrame:(CGRect)frame items:(NSArray <NSString *>*)items withDelegate:(id)delegate{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.delegate = delegate;
        
        _itemViews = [NSMutableArray array];
        
        CGFloat width = frame.size.width/items.count;
        
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height- 1.5, width, 1.5)];
        _lineView.backgroundColor = self.deSelectColor;
        [self addSubview:_lineView];
        
//        _indicatorLayer = [CALayer layer];
//        _indicatorLayer.bounds = CGRectMake(0, 0, width, 3);
//        _indicatorLayer.position = CGPointMake(0, frame.size.height);
//        _indicatorLayer.backgroundColor = self.deSelectColor.CGColor;
//        _indicatorLayer.anchorPoint = CGPointMake(0, 0.5);
//        [self.layer addSublayer:_indicatorLayer];
        
        for (int i = 0 ; i < items.count; i++) {
            
            NSString * title = items[i];
            
            UILabel * label = [[UILabel alloc] init];
            
            label.frame = CGRectMake(i*width, frame.size.height/2-40/2, width, 40);
            label.text = title;
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = self.defualtCololr;
            label.tag = i;
            label.textAlignment = NSTextAlignmentCenter;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSegment:)];
            [label addGestureRecognizer:tap];
            label.userInteractionEnabled = YES;
            [self addSubview:label];
            
            [_itemViews addObject:label];
            
        }
    }
    
    return self;
    
}


- (void)setPointX:(CGFloat )pointX {
    _pointX = pointX;
    CGRect frame = _lineView.frame;
    frame.origin.x = pointX;
    _lineView.frame = frame;

}

- (void)setDeSelectColor:(UIColor *)deSelectColor{
    
    _deSelectColor = deSelectColor;
//    _indicatorLayer.backgroundColor = deSelectColor.CGColor;
    _lineView.backgroundColor = deSelectColor;
    

}

- (void)setDefualtCololr:(UIColor *)defualtCololr{
    _defualtCololr = defualtCololr;
    for (UILabel * label in _itemViews) {
        label.textColor = defualtCololr;

    }
}

- (void)setOffsetY:(CGFloat)offsetY{
    _offsetY = offsetY;
    for (UILabel * label in _itemViews) {
        CGRect rect = label.frame;
        rect.origin.y = self.frame.size.height/2-40/2 + self.offsetY;
        label.frame = rect;
    }
}

- (void)tapSegment:(UITapGestureRecognizer *)tap{
    
    
    UILabel * currentLabel = (UILabel *)tap.view;
    self.currentIndex = currentLabel.tag;
    
    
    for (UILabel * label in _itemViews) {
        if (label.tag ==currentLabel.tag) {
            label.textColor = self.deSelectColor;
        }else{
            label.textColor = self.defualtCololr;
        }
    }
    
    [self.delegate deSelectIndex:currentLabel.tag withSegmentBar:self];

}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    for (UILabel * label in _itemViews) {
        if (label.tag == currentIndex) {
            label.textColor = self.deSelectColor;
        }else{
            label.textColor = self.defualtCololr;
        }
    }
}



 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
     
     CGContextRef contextRef = UIGraphicsGetCurrentContext();
     
     CGContextSetLineWidth(contextRef, 2.0f);
     
     CGContextSetFillColorWithColor(contextRef, [UIColor redColor].CGColor);
     CGContextSetStrokeColorWithColor(contextRef, [UIColor lightGrayColor].CGColor);
     CGContextMoveToPoint(contextRef, 0, rect.size.height);
     CGContextAddLineToPoint(contextRef, rect.size.width, rect.size.height);
     
     CGContextStrokePath(contextRef);
 }


@end
