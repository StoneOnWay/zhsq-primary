//
//  XDOwnTableViewCell.m
//  XD业主
//
//  Created by zc on 2017/6/16.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDOwnTableViewCell.h"


@implementation XDOwnTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"XDOwnTableViewCell";
    XDOwnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XDOwnTableViewCell" owner:nil options:nil] lastObject];
    }

    return cell;
    
}

@end
