//
//  XDFaceCell.m
//  xd_proprietor
//
//  Created by cfsc on 2019/6/13.
//  Copyright © 2019年 zc. All rights reserved.
//

#import "XDFaceCell.h"

@implementation XDFaceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.faceImageView.layer.cornerRadius = self.faceImageView.bounds.size.height / 2;
    self.faceImageView.layer.masksToBounds = YES;
}

- (void)setUserModel:(XDloginUserInfoModel *)userModel {
    _userModel = userModel;
    
    [self.faceImageView sd_setImageWithURL:[NSURL URLWithString:userModel.faceDisUrl] placeholderImage:[UIImage imageNamed:@"moren_tx_hui"]];
    self.nameLabel.text = userModel.name;
}

@end
