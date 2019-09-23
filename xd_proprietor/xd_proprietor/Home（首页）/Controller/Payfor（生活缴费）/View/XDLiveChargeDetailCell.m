//
//  XDLiveChargeDetailCell.m
//  XD业主
//
//  Created by zc on 2017/7/25.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDLiveChargeDetailCell.h"

@implementation XDLiveChargeDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"XDLiveChargeDetailCell";
    XDLiveChargeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDLiveChargeDetailCell" owner:nil options:nil]lastObject];
    }
    cell.backgroundColor = backColor;
    return cell;
    
}
@end
