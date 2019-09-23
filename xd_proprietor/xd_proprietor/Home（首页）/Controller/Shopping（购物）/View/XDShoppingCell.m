//
//  XDShoppingCell.m
//  XD业主
//
//  Created by zc on 2018/3/6.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDShoppingCell.h"

@implementation XDShoppingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setShopModel:(XDShoppingModel *)shopModel {
    _shopModel = shopModel;
    self.addressLabel.text = shopModel.address;
    self.namesLabel.text = shopModel.name;
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"XDShoppingCell";
    XDShoppingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDShoppingCell" owner:nil options:nil]lastObject];
    }
    cell.backgroundColor = backColor;
    return cell;
    
}

@end
