//
//  XDFunDetailHeaderView.m
//  xd_proprietor
//
//  Created by stone on 28/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDFunDetailHeaderView.h"

@implementation XDFunDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    }
    return self;
}

@end
