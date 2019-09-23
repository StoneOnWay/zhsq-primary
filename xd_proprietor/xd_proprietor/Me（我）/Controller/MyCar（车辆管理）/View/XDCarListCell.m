//
//  XDCarListCell.m
//  xd_proprietor
//
//  Created by stone on 22/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDCarListCell.h"
#import "XDCarPropertyModel.h"

@implementation XDCarListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCarModel:(XDCarPropertyModel *)carModel {
    _carModel = carModel;
    if (carModel.carPhoto) {
        NSString *imageUrl = [NSString stringWithFormat:@"%@/%@", K_BASE_URL, carModel.carPhoto];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"load_fail"]];
    } else {
        self.iconImageView.image = [UIImage imageNamed:@"car_default"];
    }
    
    self.plateNoLabel.text = carModel.vehiclecode;
    self.plateTypeLabel.text = carModel.plateType;
    self.plateColorLabel.text = carModel.plateColor;
    self.carTypeLabel.text = carModel.carType;
    self.carColorLabel.text = carModel.carColor;
    if (carModel.vehiclestatus && carModel.vehiclestatus.intValue == -1) {
        self.checkingImageView.hidden = NO;
        self.charterLabel.hidden = YES;
    } else {
        self.checkingImageView.hidden = YES;
        
        // 审核通过状态下才有包期信息
        self.charterLabel.hidden = NO;
        UIColor *allowColor = [UIColor colorWithHexString:@"13AD57"];
        CGSize size = [carModel.charterName sizeWithAttributes:@{NSFontAttributeName:self.charterLabel.font}];
        self.charterLabelWidthContraints.constant = size.width + 10;
        self.charterLabel.text = carModel.charterName;
        [self drawTypeLabel:self.charterLabel color:allowColor];
    }
}

- (void)drawTypeLabel:(UILabel *)label color:(UIColor *)color {
    label.layer.borderColor = color.CGColor;
    label.layer.cornerRadius = 2.0f;
    label.layer.masksToBounds = YES;
    label.layer.borderWidth = 1.0f;
    label.textColor = color;
}

@end
