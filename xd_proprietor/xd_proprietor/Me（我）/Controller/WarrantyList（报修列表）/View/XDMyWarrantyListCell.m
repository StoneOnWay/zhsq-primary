//
//  XDMyWarrantyListCell.m
//  XD业主
//
//  Created by zc on 2017/6/22.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDMyWarrantyListCell.h"

@implementation XDMyWarrantyListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"XDMyWarrantyListCell";
    XDMyWarrantyListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XDMyWarrantyListCell" owner:nil options:nil] lastObject];
    }
    return cell;
    
}

@end
