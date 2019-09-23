//
//  XDSwitchGridCell.m
//  XD业主
//
//  Created by zc on 2018/3/7.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDSwitchGridCell.h"
#import "XDHomeDataModel.h"
#import "UIImageView+WebCache.h"

@interface XDSwitchGridCell ()

/* 商品图片 */
@property (strong , nonatomic)UIImageView *gridImageView;

/* 名字 */
@property (strong , nonatomic)UILabel *nameLabel;

@end


@implementation XDSwitchGridCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI
{
    self.backgroundColor = litterBackColor;

    _gridImageView = [[UIImageView alloc] init];
    _gridImageView.contentMode = UIViewContentModeScaleAspectFill;
    _gridImageView.clipsToBounds = YES;
    [self addSubview:_gridImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = SFont(15);
    _nameLabel.textColor = textsColor;
    [self addSubview:_nameLabel];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_gridImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(self)setOffset:KYMargin];
        make.size.mas_equalTo(CGSizeMake(self.width * 0.9, self.width * 0.9));
    }];

    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.left.mas_equalTo(self);
        [make.bottom.mas_equalTo(self)setOffset:-10];
    }];
}

- (void)setHomeModel:(XDHomeDataModel *)homeModel {
    _homeModel = homeModel;
    _nameLabel.text = homeModel.name;
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",K_BASE_URL,homeModel.pic];
    [_gridImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"moren_pic_little"]];

}
@end
