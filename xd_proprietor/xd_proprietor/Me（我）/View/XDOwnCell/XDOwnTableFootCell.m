//
//  XDOwnTableFootCell.m
//  XD业主
//
//  Created by zc on 2017/6/16.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDOwnTableFootCell.h"

@implementation XDOwnTableFootCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"XDOwnTableFootCell";
    XDOwnTableFootCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XDOwnTableFootCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
    
}

@end
