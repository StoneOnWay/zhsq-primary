//
//  XDMyComplainListCell.m
//  XD业主
//
//  Created by zc on 2017/6/22.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDMyComplainListCell.h"

@implementation XDMyComplainListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"XDMyComplainListCell";
    XDMyComplainListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XDMyComplainListCell" owner:nil options:nil] lastObject];
    }
    cell.backgroundColor = backColor;
    return cell;
    
}

@end
