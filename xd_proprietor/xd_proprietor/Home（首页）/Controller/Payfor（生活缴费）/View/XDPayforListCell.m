//
//  XDPayforListCell.m
//  XD业主
//
//  Created by zc on 2017/11/14.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDPayforListCell.h"

@implementation XDPayforListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"XDPayforListCell";
    XDPayforListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDPayforListCell" owner:nil options:nil]lastObject];
    }
    cell.backgroundColor = backColor;
    return cell;
    
}

- (void)setDataModel:(XDPayforDataModel *)dataModel {
    _dataModel = dataModel;
    self.muchMoney.text = [NSString stringWithFormat:@"¥ %@ 元",dataModel.fee];
    self.roomName.text = dataModel.adds;
    self.billTime.text = dataModel.term;
    self.timeLimit.text = dataModel.shouldpaydate;
}
@end
