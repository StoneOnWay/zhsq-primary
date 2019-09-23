//
//  XDHomeTableViewCell.m
//  XD业主
//
//  Created by zc on 2017/6/19.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDHomeTableViewCell.h"

@implementation XDHomeTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"XDHomeTableViewCell";
    XDHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XDHomeTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.backgroundColor = backColor;
    return cell;
    
}


@end
