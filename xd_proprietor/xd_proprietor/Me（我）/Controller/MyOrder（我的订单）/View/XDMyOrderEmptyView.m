//
//  XDMyOrderEmptyView.m
//  XD业主
//
//  Created by zc on 2018/3/15.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDMyOrderEmptyView.h"
@interface XDMyOrderEmptyView ()

/* imageView */
@property (strong , nonatomic)UIImageView *emptyImageView;
/* 标语 */
@property (strong , nonatomic)UILabel *sloganLabel;

@end

@implementation XDMyOrderEmptyView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    _emptyImageView = [[UIImageView alloc] init];
    _emptyImageView.image = [UIImage imageNamed:@"orderNoNews"];
    [self addSubview:_emptyImageView];
    
    _sloganLabel = [[UILabel alloc] init];
    _sloganLabel.textColor = [UIColor darkGrayColor];
    _sloganLabel.text = @"您还没有相关的订单";
    _sloganLabel.font = SFont(16);
    _sloganLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_sloganLabel];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(self) setOffset:50];
        if (ISIPHONE_5) {
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }else{
            make.size.mas_equalTo(CGSizeMake(120, 120));
        }
    }];
    
    [_sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(_emptyImageView.mas_bottom)setOffset:25];
    }];
   
}

@end
