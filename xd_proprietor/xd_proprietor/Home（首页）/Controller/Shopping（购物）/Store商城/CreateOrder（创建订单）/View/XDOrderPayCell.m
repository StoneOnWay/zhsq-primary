//
//  XDOrderPayCell.m
//  XD业主
//
//  Created by zc on 2018/4/24.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDOrderPayCell.h"

@implementation XDOrderPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"XDOrderPayCell";
    XDOrderPayCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDOrderPayCell" owner:nil options:nil]lastObject];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}
@end
