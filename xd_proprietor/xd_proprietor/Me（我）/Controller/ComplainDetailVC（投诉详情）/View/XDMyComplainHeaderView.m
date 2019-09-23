//
//  XDMyComplainHeaderView.m
//  XD业主
//
//  Created by zc on 2017/6/22.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDMyComplainHeaderView.h"

@implementation XDMyComplainHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.textColor = RGB(74, 74, 74);
    self.XDLabel.textColor = RGB(69, 145, 107);
    self.addressLabel.textColor = RGB(155, 155, 155);

    self.headImage.layer.cornerRadius = 19;
    [self.headImage.layer setMasksToBounds:YES];
    
}

- (void)setNameText:(NSString *)nameText {
    
    _nameText = [nameText copy];
    self.nameLabel.text = nameText;
    CGRect tmpRect = [nameText boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:SFont(13),NSFontAttributeName, nil] context:nil];
    CGFloat contentW = tmpRect.size.width+1;
    self.nameLabelConstaint.constant = contentW;
    
}

- (void)setAddressText:(NSString *)addressText {
    _addressText = addressText;
    self.addressLabel.text = addressText;
    
}

- (void)setRoomAddress:(NSString *)roomAddress {
    _roomAddress = roomAddress;
    self.XDLabel.text = roomAddress;
    
}
- (void)setIconUrl:(NSString *)iconUrl {
    _iconUrl = iconUrl;
    NSString *stringUrl = [NSString stringWithFormat:@"%@/%@",K_BASE_URL,iconUrl];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:stringUrl] placeholderImage:[UIImage imageNamed:@"tsxq2_user"] options:SDWebImageRefreshCached];
    
}

- (IBAction)callPhoneBtnClicked:(id)sender {
    
    NSString *string = [NSString stringWithFormat:@"tel:%@",_phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    
}
- (IBAction)dingweiBtnClicked:(id)sender {
    
    
    
}

@end
