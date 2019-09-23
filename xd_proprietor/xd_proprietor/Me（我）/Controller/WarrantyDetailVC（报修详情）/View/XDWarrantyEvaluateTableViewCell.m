//
//  XDWarrantyEvaluateTableViewCell.m
//  xd_proprietor
//
//  Created by mason on 2018/9/10.
//Copyright © 2018年 zc. All rights reserved.
//

#import "XDWarrantyEvaluateTableViewCell.h"
#import "HCSStarRatingView.h"

@interface XDWarrantyEvaluateTableViewCell()

@property (weak, nonatomic) IBOutlet HCSStarRatingView *starRatingView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation XDWarrantyEvaluateTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setWarrantyDetailNetDataModel:(XDWarrantyDetailNetDataModel *)warrantyDetailNetDataModel {
    _warrantyDetailNetDataModel = warrantyDetailNetDataModel;
    self.starRatingView.value = [warrantyDetailNetDataModel.commentLevel floatValue];
    self.contentLabel.text = warrantyDetailNetDataModel.commentContent;
}

@end
