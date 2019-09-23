//
//  XDCreateOrderHead.m
//  XD业主
//
//  Created by zc on 2018/3/14.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDCreateOrderHead.h"

@interface XDCreateOrderHead ()

@property (nonatomic, strong) UIView *shopcartHeaderBgView;
@property (nonatomic, strong) UILabel *titlesLabel;

@end

@implementation XDCreateOrderHead

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self addSubview:self.shopcartHeaderBgView];
    [self.shopcartHeaderBgView addSubview:self.titlesLabel];
}


- (UIView *)shopcartHeaderBgView {
    if (_shopcartHeaderBgView == nil){
        _shopcartHeaderBgView = [[UIView alloc] init];
        _shopcartHeaderBgView.backgroundColor = RGB(242, 243, 244);;
    }
    return _shopcartHeaderBgView;
}

- (UILabel *)titlesLabel {
    if (_titlesLabel == nil){
        _titlesLabel = [[UILabel alloc] init];
        _titlesLabel.font = [UIFont systemFontOfSize:14];
        _titlesLabel.textColor = [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1];
    }
    return _titlesLabel;
}

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    self.titlesLabel.text = titleString;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.shopcartHeaderBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.titlesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopcartHeaderBgView).offset(15);
        make.top.bottom.equalTo(self.shopcartHeaderBgView);
    }];
}



@end
