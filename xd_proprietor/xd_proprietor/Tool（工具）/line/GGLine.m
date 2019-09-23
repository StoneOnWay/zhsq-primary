//
//  GGLine.m
//  hotelbrt
//
//  Created by Ron on 9/28/14.
//  Copyright (c) 2014 HGG. All rights reserved.
//

#import "GGLine.h"
#import "UIView+LayoutConstraintHelper.h"
#import "UIView+Utils.h"

@implementation GGLine

- (void)awakeFromNib{
    [super awakeFromNib];
    if (!self.lineColor) {
        self.lineColor = self.dashedMode ? RGB(135, 135, 135) : RGB(199, 199, 199);
    }
    self.lineLength = MAX(0.5, self.lineLength);
    if (self.dashedMode) {
        self.backgroundColor = [UIColor clearColor];
        if (self.dashedWidth <= 0) {
            self.dashedWidth = 2;
        }
    }
    if (_vertical) {
        if(!self.widthConstraint){
            self.translatesAutoresizingMaskIntoConstraints = NO;
            NSLayoutConstraint *widthContraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.lineLength];
            [self addConstraint:widthContraint];
        }
        self.widthConstraint.constant = self.lineLength;
    }else {
        if (!self.heightConstraint) {
            self.translatesAutoresizingMaskIntoConstraints = NO;
            NSLayoutConstraint *heightContraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.lineLength];
            [self addConstraint:heightContraint];
        }
        self.heightConstraint.constant = self.lineLength;
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, self.lineLength);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGFloat lengths[] = {self.dashedWidth,self.dashedWidth};
    if (self.dashedMode) {
        CGContextSetLineDash(context, 0, lengths,2);
    }
    if (_vertical) {
        CGContextMoveToPoint(context, self.width/2, 0);
        CGContextAddLineToPoint(context, self.width/2,self.height);
    }else {
        CGContextMoveToPoint(context, 0, self.height/2);
        CGContextAddLineToPoint(context, self.width,self.height/2);
    }
    CGContextClosePath(context);    
    CGContextStrokePath(context);
}

@end
