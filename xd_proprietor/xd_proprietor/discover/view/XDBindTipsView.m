//
//  XDBindTipsView.m
//  xd_proprietor
//
//  Created by cfsc on 2019/7/5.
//  Copyright © 2019年 zc. All rights reserved.
//

#import "XDBindTipsView.h"

@implementation XDBindTipsView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil].firstObject;
    }
    return self;
}

- (IBAction)bindAction:(id)sender {
    if (self.bindBtnClick) {
        self.bindBtnClick();
    }
}
@end
