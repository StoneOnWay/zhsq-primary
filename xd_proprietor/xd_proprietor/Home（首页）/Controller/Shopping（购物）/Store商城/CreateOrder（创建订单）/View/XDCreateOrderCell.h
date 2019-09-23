//
//  XDCreateOrderCell.h
//  XD业主
//
//  Created by zc on 2018/3/14.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDGoodsListModel.h"
#import "KYShopcartProductModel.h"
#import "XDMyOrderShopModel.h"

@interface XDCreateOrderCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic, copy) NSString *imageUrl;
//商品详情直接购买
@property (nonatomic, copy) XDGoodsListModel *listModel;
//从购物车购买
@property (nonatomic, copy) KYShopcartProductModel *cartModel;

//订单详情赋值
@property (nonatomic, copy) XDMyOrderShopModel *shopModel;

@end
