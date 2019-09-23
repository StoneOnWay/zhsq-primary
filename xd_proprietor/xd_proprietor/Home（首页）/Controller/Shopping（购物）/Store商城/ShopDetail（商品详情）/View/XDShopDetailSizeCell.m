//
//  XDShopDetailSizeCell.m
//  XD业主
//
//  Created by zc on 2018/3/14.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDShopDetailSizeCell.h"

@implementation XDShopDetailSizeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.sizeBtn.layer.cornerRadius = 5;
    [self.sizeBtn.layer setMasksToBounds:YES];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"XDShopDetailSizeCell";
    XDShopDetailSizeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDShopDetailSizeCell" owner:nil options:nil]lastObject];
    }
    cell.backgroundColor = [UIColor whiteColor];;
    return cell;
    
}

@end
