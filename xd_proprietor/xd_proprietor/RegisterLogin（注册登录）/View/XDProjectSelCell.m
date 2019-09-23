//
//  XDProjectSelCell.m
//  xd_proprietor
//
//  Created by cfsc on 2019/7/30.
//  Copyright © 2019年 zc. All rights reserved.
//

#import "XDProjectSelCell.h"

@implementation XDProjectSelCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.backView.layer.borderWidth = 0.5;
//    self.backView.layer.borderColor = BianKuang.CGColor;
    self.backView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.backView.layer.shadowOffset = CGSizeMake(-1, 3);
    self.backView.layer.shadowOpacity = 0.5;
    self.backView.layer.shadowRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
