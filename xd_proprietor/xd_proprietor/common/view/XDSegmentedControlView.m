//
//  XDSegmentedControlView.m
//  xd_proprietor
//
//  Created by mason on 2018/9/6.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDSegmentedControlView.h"

@interface XDSegmentedControlView()

/** <##> */
@property (strong, nonatomic) UIView *line;

@end

@implementation XDSegmentedControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"进行中", @"已完成"]];
    segmentedControl.frame = CGRectMake(15.f, 15.f, kScreenWidth - 30.f, 35.f);
    self.segmentedControl = segmentedControl;
    [self addSubview:segmentedControl];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = UIColorHex(eeeeee);
    [segmentedControl setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f], NSForegroundColorAttributeName:UIColorHex(353535)} forState:UIControlStateNormal];
    [segmentedControl setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f], NSForegroundColorAttributeName:UIColorHex(aaaaaa)} forState:UIControlStateSelected];
    [segmentedControl addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventValueChanged];
    
    UIView *line = [[UIView alloc] init];
    CGFloat lineHeight = 1.f / [UIScreen mainScreen].scale;
    line.frame = CGRectMake(0, CGRectGetHeight(self.frame) - lineHeight, kScreenWidth, lineHeight);
    line.backgroundColor = UIColorHex(eeeeee);
    [self addSubview:line];
    self.line = line;
}

- (void)clickItem:(UISegmentedControl *)segmentedControl {
    if ([self.delegate respondsToSelector:@selector(didSelectedItemIndex:)]) {
        [self.delegate didSelectedItemIndex:segmentedControl.selectedSegmentIndex];
    }
}


@end






















