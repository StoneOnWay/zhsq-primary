//
//  XDWorkProgressTableViewCell.m
//  xd_proprietor
//
//  Created by mason on 2018/9/7.
//Copyright © 2018年 zc. All rights reserved.
//

#import "XDWorkProgressTableViewCell.h"

@interface XDWorkProgressTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation XDWorkProgressTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentLabel.numberOfLines = 0;
}

- (void)setProcessModel:(XDProcessModel *)processModel {
    _processModel = processModel;
    [self.timeLabel setAttributedText:[self timeAttributedStr:processModel.planDateTime]];
    self.titleLabel.text = processModel.planName;
    if ([processModel.remark containsString:@"/"]) {
        [self.contentLabel setAttributedText:[self attributedStr:processModel.remark]];
    } else {
        self.contentLabel.text = processModel.remark;
    }
    
    if ([processModel.handlertype integerValue] == 0) {
        self.iconImageView.image = [UIImage imageNamed:@"icon_public_employee"];
    } else {
        self.iconImageView.image = [UIImage imageNamed:@"icon_public_user"];
    }
}


- (NSAttributedString *)timeAttributedStr:(NSString *)time {
    NSMutableAttributedString *resultAttr = [[NSMutableAttributedString alloc] initWithString:time attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f], NSForegroundColorAttributeName : UIColorHex(353535)}];
    NSRange range = [time rangeOfString:@" "];
    [resultAttr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11.f],} range:NSMakeRange(range.location + range.length, time.length - range.location - range.length)];
    return resultAttr;
}

- (NSAttributedString *)attributedStr:(NSString *)content {
    NSMutableAttributedString *resultAttr = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11.f], NSForegroundColorAttributeName : UIColorHex(353535)}];
    NSRange range = [content rangeOfString:@"/"];
    [resultAttr addAttributes:@{NSForegroundColorAttributeName : UIColorHex(fe552e)} range:NSMakeRange(range.location + range.length, content.length - range.location - range.length)];
    return resultAttr;
}

@end





