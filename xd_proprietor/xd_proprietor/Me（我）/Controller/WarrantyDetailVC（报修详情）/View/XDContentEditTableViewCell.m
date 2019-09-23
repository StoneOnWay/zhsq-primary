//
//  XDContentEditTableViewCell.m
//  xd_proprietor
//
//  Created by mason on 2018/9/7.
//Copyright © 2018年 zc. All rights reserved.
//

#import "XDContentEditTableViewCell.h"

@interface XDContentEditTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *priceTextBorderView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation XDContentEditTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.priceTextBorderView.layer.cornerRadius = 5.f;
    self.priceTextBorderView.layer.masksToBounds = YES;
    self.priceTextBorderView.layer.borderColor = UIColorHex(007cc2).CGColor;
    self.priceTextBorderView.layer.borderWidth = 1.f;
}

- (void)setDictionary:(NSDictionary *)dictionary {
    _dictionary = dictionary;
    self.titleLabel.text = dictionary[@"value"][@"title"];
    self.textField.text = dictionary[@"value"][@"content"];
    [self setPriceCell:[dictionary[@"SUBKEY"] integerValue] == XDContentEditTypeInput];
}

- (void)setPriceCell:(BOOL)priceCell {
    if (priceCell) {
        self.priceView.hidden = NO;
        self.subTitleLabel.hidden = YES;
    } else {
        self.priceView.hidden = YES;
        self.subTitleLabel.hidden = NO;
    }
}


@end
