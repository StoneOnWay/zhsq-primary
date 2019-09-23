//
//  XDCarCharterCell.m
//  xd_proprietor
//
//  Created by cfsc on 2019/6/17.
//  Copyright © 2019年 zc. All rights reserved.
//

#import "XDCarCharterCell.h"
#import "XDCarPropertyModel.h"

@implementation XDCarCharterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)charterAction:(id)sender {
    if (self.charterBtnClick) {
        self.charterBtnClick();
    }
}

- (void)setCarModel:(XDCarPropertyModel *)carModel {
    _carModel = carModel;
    self.charterNameLabel.text = carModel.charterName;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.charterBtn setTitle:@"包期" forState:UIControlStateNormal];
    if ([carModel.charterName isEqualToString:@"已包期"]) {
        // 七天内到期处理：改为续费
        NSString *nowTimeStr = [XDUtil getNowTimeStrWithFormatter:CarCharterDateFormatter];
        NSInteger dayCount = [XDUtil getDistanceWithFirstDate:nowTimeStr secondDate:carModel.endTime dateFormatter:CarCharterDateFormatter];
        if (dayCount > 31) {
            self.charterBtn.hidden = YES;
        } else {
            self.charterBtn.hidden = NO;
            [self.charterBtn setTitle:@"续费" forState:UIControlStateNormal];
        }
        
        self.charterTimeLabel.text = [NSString stringWithFormat:@"%@至%@", carModel.startTime, carModel.endTime];
        self.charterTimeLabelHeightConstraint.constant = 17;
        [self layoutIfNeeded];
    } else {
        self.charterTimeLabelHeightConstraint.constant = 0;
        [self layoutIfNeeded];
        if ([carModel.charterName isEqualToString:@"未包期"]) {
            self.charterBtn.hidden = NO;
        } else {
            self.charterBtn.hidden = YES;
        }
    }
}

@end
