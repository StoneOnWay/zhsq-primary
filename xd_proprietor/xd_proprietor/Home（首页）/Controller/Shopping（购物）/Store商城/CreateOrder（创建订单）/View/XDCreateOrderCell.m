//
//  XDCreateOrderCell.m
//  XD业主
//
//  Created by zc on 2018/3/14.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDCreateOrderCell.h"
#import "XDResourceListModel.h"

@implementation XDCreateOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.discountLabel.textColor = [UIColor redColor];
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"XDCreateOrderCell";
    XDCreateOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDCreateOrderCell" owner:nil options:nil]lastObject];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}
- (void)setListModel:(XDGoodsListModel *)listModel {
    
    _listModel = listModel;
    
    self.nameLabel.text = listModel.name;
    self.sizeLabel.text = listModel.size;
    self.numLabel.text = @"× 1";
    float discount = [listModel.discountprice floatValue];
    self.discountLabel.text = [NSString stringWithFormat:@"¥ %.2f",discount];
    
    float price = [listModel.price floatValue];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",price];
    
    XDResourceListModel *resourceModel = listModel.resourceList.firstObject;
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",K_BASE_URL,resourceModel.url];
    NSString *imgUrl = [urlString  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"moren_pic_little"]];
}

- (void)setCartModel:(KYShopcartProductModel *)cartModel {
 
    _cartModel = cartModel;
    
    self.nameLabel.text = cartModel.name;
    self.sizeLabel.text = cartModel.size;
    self.numLabel.text = [NSString stringWithFormat:@"× %ld",cartModel.count];
    float discount = [cartModel.discountprice floatValue];
    self.discountLabel.text = [NSString stringWithFormat:@"¥ %.2f",discount];
    
    float price = [cartModel.price floatValue];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",price];
    
    KYShopcartResoucelistModel *resourceModel = cartModel.resourceList.firstObject;
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",K_BASE_URL,resourceModel.url];
    NSString *imgUrl = [urlString  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"moren_pic_little"]];
    
}

- (void)setShopModel:(XDMyOrderShopModel *)shopModel {
    
    _shopModel = shopModel;
    
    self.nameLabel.text = shopModel.shopGoods.name;
    self.sizeLabel.text = shopModel.shopGoods.size;
    self.numLabel.text = [NSString stringWithFormat:@"× %ld",shopModel.number];
    float discount = [shopModel.shopGoods.discountprice floatValue];
    self.discountLabel.text = [NSString stringWithFormat:@"¥ %.2f",discount];
    
    float price = [shopModel.shopGoods.price floatValue];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",price];
    
    KYShopcartResoucelistModel *resourceModel = shopModel.shopGoods.resourceList.firstObject;
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",K_BASE_URL,resourceModel.url];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"moren_pic_little"]];
    
}


@end
