//
//  XDActivityItemTableViewCell.m
//  xd_proprietor
//
//  Created by mason on 2018/9/4.
//Copyright © 2018年 zc. All rights reserved.
//

#import "XDActivityItemTableViewCell.h"

@implementation XDActivityItemTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
