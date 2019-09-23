//
//  KYShopcartCell.m
//  KYShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import "KYShopcartCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "KYShopcartCountView.h"

@interface KYShopcartCell ()

@property (nonatomic, strong) UIButton *productSelectButton;
@property (nonatomic, strong) UIImageView *productImageView;//商品图片
@property (nonatomic, strong) UILabel *productNameLable;//商品名字
@property (nonatomic, strong) UILabel *productSizeLable;//商品规格
@property (nonatomic, strong) UILabel *productPriceLable;//商品价格
@property (nonatomic, strong) KYShopcartCountView *shopcartCountView;
@property (nonatomic, strong) UILabel *discountPriceLable;//商品折后价
@property (nonatomic, strong) UILabel *productCountLabel;//商品数量
@property (nonatomic, strong) UIView *shopcartBgView;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *labelLineView;//原件那根线
@end

@implementation KYShopcartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self.contentView addSubview:self.shopcartBgView];
    [self.shopcartBgView addSubview:self.productSelectButton];
    [self.shopcartBgView addSubview:self.productImageView];
    [self.shopcartBgView addSubview:self.productNameLable];
    [self.shopcartBgView addSubview:self.productSizeLable];
    [self.shopcartBgView addSubview:self.productPriceLable];
    [self.shopcartBgView addSubview:self.productCountLabel];
    [self.shopcartBgView addSubview:self.shopcartCountView];
    [self.shopcartBgView addSubview:self.discountPriceLable];
    [self.shopcartBgView addSubview:self.topLineView];
    [self.shopcartBgView addSubview:self.labelLineView];
}

- (void) configureShopcartCellWithProductURL:(NSString *)productURL productName:(NSString *)productName productPrice:(NSString *)productPrice productDisCountPrice:(NSString *)disCountPrice productCount:(NSInteger)productCount productSize:(NSString *)productSize productSelected:(BOOL)productSelected {
    
    NSURL *encodingURL = [NSURL URLWithString:[productURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [self.productImageView sd_setImageWithURL:encodingURL placeholderImage:[UIImage imageNamed:@"moren_pic_little"]];
    self.productNameLable.text = productName;
    self.discountPriceLable.text = [NSString stringWithFormat:@"¥ %@",disCountPrice];
    self.productPriceLable.text = [NSString stringWithFormat:@"¥ %@",productPrice];;
    self.productCountLabel.text = [NSString stringWithFormat:@"× %ld",productCount];
    self.productSizeLable.text = productSize;
    self.productSelectButton.selected = productSelected;
    [self.shopcartCountView configureShopcartCountViewWithProductCount:productCount productStock:20000];
}

- (void)productSelectButtonAction {
    self.productSelectButton.selected = !self.productSelectButton.isSelected;
    if (self.shopcartCellBlock) {
        self.shopcartCellBlock(self.productSelectButton.selected);
    }
}

- (UIButton *)productSelectButton
{
    if(_productSelectButton == nil)
    {
        _productSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_productSelectButton setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
        [_productSelectButton setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
        [_productSelectButton addTarget:self action:@selector(productSelectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _productSelectButton;
}

- (UIImageView *)productImageView {
    if (_productImageView == nil){
        _productImageView = [[UIImageView alloc] init];
        _productImageView.contentMode = UIViewContentModeScaleAspectFill;
        _productImageView.clipsToBounds = YES;
    }
    return _productImageView;
}

- (UILabel *)productNameLable {
    if (_productNameLable == nil){
        _productNameLable = [[UILabel alloc] init];
        _productNameLable.font = [UIFont systemFontOfSize:14];
        _productNameLable.textColor = [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1];
    }
    return _productNameLable;
}

- (UILabel *)productSizeLable {
    if (_productSizeLable == nil){
        _productSizeLable = [[UILabel alloc] init];
        _productSizeLable.font = [UIFont systemFontOfSize:13];
        _productSizeLable.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
    }
    return _productSizeLable;
}
- (UILabel *)productCountLabel {
    if (_productCountLabel == nil){
        _productCountLabel = [[UILabel alloc] init];
        _productCountLabel.font = [UIFont systemFontOfSize:13];
        _productCountLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
    }
    return _productCountLabel;
}

- (UILabel *)productPriceLable {
    if (_productPriceLable == nil){
        _productPriceLable = [[UILabel alloc] init];
        [_productPriceLable setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _productPriceLable.font = [UIFont systemFontOfSize:13];
        _productPriceLable.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
    }
    return _productPriceLable;
}

- (UILabel *)discountPriceLable {
    if (_discountPriceLable == nil){
        _discountPriceLable = [[UILabel alloc] init];
        [_discountPriceLable setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _discountPriceLable.font = [UIFont systemFontOfSize:14];
        _discountPriceLable.textColor = [UIColor colorWithRed:0.918  green:0.141  blue:0.137 alpha:1];
    }
    return _discountPriceLable;
}

- (KYShopcartCountView *)shopcartCountView {
    if (_shopcartCountView == nil){
        _shopcartCountView = [[KYShopcartCountView alloc] init];
        __weak __typeof(self) weakSelf = self;
        _shopcartCountView.shopcartCountViewEditBlock = ^(NSInteger count){
            weakSelf.productCountLabel.text = [NSString stringWithFormat:@"× %ld",count];
            if (weakSelf.shopcartCellEditBlock) {
                weakSelf.shopcartCellEditBlock(count);
            }
        };
    }
    return _shopcartCountView;
}



- (UIView *)shopcartBgView {
    if (_shopcartBgView == nil){
        _shopcartBgView = [[UIView alloc] init];
        _shopcartBgView.backgroundColor = [UIColor whiteColor];
    }
    return _shopcartBgView;
}

- (UIView *)topLineView {
    if (_topLineView == nil){
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    }
    return _topLineView;
}

- (UIView *)labelLineView {
    if (_labelLineView == nil){
        _labelLineView = [[UIView alloc] init];
        _labelLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _labelLineView;
}

- (void)setIsEdit:(BOOL)isEdit {
    _isEdit = isEdit;
    self.shopcartCountView.hidden = !isEdit;
    self.productCountLabel.hidden = isEdit;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.productSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopcartBgView).offset(10);
        make.centerY.equalTo(self.shopcartBgView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopcartBgView).offset(55);
        make.centerY.equalTo(self.shopcartBgView);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.productNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(15);
        make.top.equalTo(self.productImageView.mas_top);
        make.right.equalTo(self.shopcartBgView).offset(-5);
    }];
    
    [self.productSizeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(15);
        make.centerY.equalTo(self.productImageView.mas_centerY);
        make.height.equalTo(@20);
    }];
    
    [self.productCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(15);
        make.bottom.equalTo(self.productImageView.mas_bottom);
        make.height.equalTo(@20);
    }];
    
    
    [self.shopcartCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(10);
        make.bottom.equalTo(self.productImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(90, 25));
        
    }];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopcartBgView).offset(50);
        make.top.right.equalTo(self.shopcartBgView);
        make.height.equalTo(@0.4);
    }];
    
    [self.discountPriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productPriceLable.mas_left);
        make.centerY.equalTo(self.productSizeLable.mas_centerY);
        make.height.equalTo(@20);
    }];
    
    [self.productPriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self.productCountLabel.mas_centerY);
        make.height.equalTo(@20);
    }];
    
    [self.labelLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productPriceLable.mas_left);
        make.right.equalTo(self.productPriceLable.mas_right);
        make.centerY.equalTo(self.productPriceLable.mas_centerY);
        make.height.equalTo(@1);
    }];
    
    [self.shopcartBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopcartBgView).offset(50);
        make.top.right.equalTo(self.shopcartBgView);
        make.height.equalTo(@0.4);
    }];
}

@end
