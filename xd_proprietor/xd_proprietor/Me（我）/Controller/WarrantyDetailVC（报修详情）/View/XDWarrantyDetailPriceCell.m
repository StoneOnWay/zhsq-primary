//
//  XDWarrantyDetailPriceCell.m
//  XD业主
//
//  Created by zc on 2017/6/23.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDWarrantyDetailPriceCell.h"

@implementation XDWarrantyDetailPriceCell

-(void)awakeFromNib {

    [super awakeFromNib];
    
    self.menPrice.layer.borderColor = [BianKuang CGColor];
    self.menPrice.layer.cornerRadius = 5;
    self.menPrice.layer.borderWidth = 1.0;
    [self.menPrice.layer setMasksToBounds:YES];
    
    self.materialPrice.layer.borderColor = [BianKuang CGColor];
    self.materialPrice.layer.cornerRadius = 5;
    self.materialPrice.layer.borderWidth = 1.0;
    [self.materialPrice.layer setMasksToBounds:YES];
    
    self.totalPrice.layer.borderColor = [BianKuang CGColor];
    self.totalPrice.layer.cornerRadius = 5;
    self.totalPrice.layer.borderWidth = 1.0;
    [self.totalPrice.layer setMasksToBounds:YES];
    
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"XDWarrantyDetailPriceCell";
    XDWarrantyDetailPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDWarrantyDetailPriceCell" owner:nil options:nil]lastObject];
    }
    cell.backgroundColor = backColor;
    return cell;
    
}

@end
