//
//  XDGoodsListCell.m
//  XD业主
//
//  Created by zc on 2018/3/7.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDGoodsListCell.h"
#import "XDGoodsListModel.h"
#import "XDResourceListModel.h"

@interface XDGoodsListCell ()

/* 商品图片 */
@property (strong , nonatomic)UIImageView *gridImageView;

/* 购物车图片 */
@property (strong , nonatomic)UIButton *cartButton;

/* 名字 */
@property (strong , nonatomic)UILabel *nameLabel;

/* 实际价格 */
@property (strong , nonatomic)UILabel *realPrice;

/* 优惠前价格 */
@property (strong , nonatomic)UILabel *prePrice;

/* 优惠前价格那个横线 */
@property (strong , nonatomic)UIView *lineView;

/* 横线宽度 */
@property (assign , nonatomic)CGFloat lineWidth;

@end


@implementation XDGoodsListCell

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
    _nameLabel.font = SFont(13);
    _nameLabel.textColor = textsColor;
    [self addSubview:_nameLabel];
    
    _realPrice = [[UILabel alloc] init];
    _realPrice.font = SFont(15);
    _realPrice.textColor = textsColor;
    [_realPrice setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self addSubview:_realPrice];
    
    _prePrice = [[UILabel alloc] init];
    _prePrice.font = SFont(12);
    _prePrice.textColor = [UIColor lightGrayColor];
    [self addSubview:_prePrice];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_lineView];
    
    _cartButton = [[UIButton alloc] init];
    [_cartButton setImage:[UIImage imageNamed:@"shop_car"] forState:UIControlStateNormal];
    [_cartButton addTarget:self action:@selector(cartButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cartButton];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_gridImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(self)setOffset:KYMargin];
        make.size.mas_equalTo(CGSizeMake(self.width- 20, self.width- 20));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self);
        [make.top.mas_equalTo(_gridImageView.mas_bottom)setOffset: 10];
    }];
    
    [_realPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.bottom.mas_equalTo(self)setOffset: -11];
        [make.left.mas_equalTo(self) setOffset:5];
        make.right.mas_equalTo(_prePrice.mas_left);
    }];
    
    [_cartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_realPrice);
        [make.right.mas_equalTo(self) setOffset:-10];
        make.size.mas_equalTo(CGSizeMake(25,25));
    }];
    
    [_prePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_realPrice);
//        [make.left.mas_equalTo(_realPrice.mas_right)];
        [make.right.mas_equalTo(_cartButton.mas_left) setOffset:-3];
    }];
    
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_realPrice);
        make.left.mas_equalTo(_prePrice.mas_left);
        make.width.mas_equalTo(self.lineWidth);
        make.height.mas_equalTo(1);
    }];
    
    
}
//_url    __NSCFString *    @"upload/shop/goods_images/1520229548514_c.jpg,upload/shop/goods_images/1520229605860_c.jpg"    0x00000001c44c6a50
- (void)setListModel:(XDGoodsListModel *)listModel {
    
    _listModel = listModel;
    _realPrice.text = [NSString stringWithFormat:@"¥ %@ ",listModel.discountprice];
    _prePrice.text = [NSString stringWithFormat:@"¥ %@",listModel.price];
    _nameLabel.text = listModel.name;
    XDResourceListModel *resourceModel = listModel.resourceList.firstObject;
    NSArray *urlArray = [resourceModel.url componentsSeparatedByString:@","]; //从字符,中分隔成2个元素的数组
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",K_BASE_URL,urlArray.firstObject];
    NSString *imgUrl = [urlString  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_gridImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"moren_pic_little"]];
    
    self.lineWidth = self.width - 40 - [self evaluteTextWidth:_realPrice];
    if (self.lineWidth > [self evaluteTextWidth:_prePrice]) {
        self.lineWidth = [self evaluteTextWidth:_prePrice];
    }
}

- (CGFloat)evaluteTextWidth:(UILabel *)label {
    
    NSDictionary *textAtt = @{NSFontAttributeName : label.font};
    
    CGSize evaluteLabelSize = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size;
    CGFloat evaluteLabelSizeW = evaluteLabelSize.width;
    
    return evaluteLabelSizeW +2;
}

- (void)cartButtonClick {
    !_cartBtnBeClickedBlock ? : _cartBtnBeClickedBlock(); //block回调
}
@end
