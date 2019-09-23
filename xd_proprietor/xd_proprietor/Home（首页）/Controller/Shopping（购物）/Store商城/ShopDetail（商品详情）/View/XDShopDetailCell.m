//
//  XDShopDetailCell.m
//  XD业主
//
//  Created by zc on 2018/3/14.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDShopDetailCell.h"

@implementation XDShopDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"XDShopDetailCell";
    XDShopDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDShopDetailCell" owner:nil options:nil]lastObject];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}

@end
