//
//  XDWarrantyDetailProprietorInfoTableViewCell.m
//  xd_proprietor
//
//  Created by mason on 2018/9/7.
//Copyright © 2018年 zc. All rights reserved.
//

#import "XDWarrantyDetailProprietorInfoTableViewCell.h"

@interface XDWarrantyDetailProprietorInfoTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;

@end

@implementation XDWarrantyDetailProprietorInfoTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.headerImageView.layer.cornerRadius = self.headerImageView.width/2.f;
    self.headerImageView.layer.masksToBounds = YES;
}

- (void)setUserinfoNetModel:(XDUserinfoNetModel *)userinfoNetModel {
    _userinfoNetModel = userinfoNetModel;
    NSURL *url = [NSURL URLWithString:[K_BASE_URL stringByAppendingPathComponent:userinfoNetModel.userHearImageUrl]];
    [self.headerImageView setImageWithURL:url placeholder:DefaultHeaderImage];
    self.nickLabel.text = userinfoNetModel.userName;
    self.roomLabel.text = userinfoNetModel.userRoomAddress;
}


@end
