//
//  XDMyDetailCommentCell.m
//  XD业主
//
//  Created by zc on 2018/3/23.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDMyDetailCommentCell.h"

@interface XDMyDetailCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end
@implementation XDMyDetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.discountLabel.textColor = [UIColor redColor];
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"XDMyDetailCommentCell";
    XDMyDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDMyDetailCommentCell" owner:nil options:nil]lastObject];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}
- (void)setShopModel:(XDMyOrderShopModel *)shopModel {
    
    _shopModel = shopModel;
    
    self.nameLabel.text = shopModel.shopGoods.name;
    self.sizeLabel.text = shopModel.shopGoods.size;
    self.numLabel.text = [NSString stringWithFormat:@"× %ld",shopModel.number];
    float discount = [shopModel.shopGoods.discountprice floatValue];
    self.discountLabel.text = [NSString stringWithFormat:@"¥ %.2f",discount];
    
    float price = [shopModel.shopGoods.price floatValue];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",price];
    
    KYShopcartResoucelistModel *resourceModel = shopModel.shopGoods.resourceList.firstObject;
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",K_BASE_URL,resourceModel.url];
    NSString *imgUrl = [urlString  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"moren_pic_little"]];
    
}

- (IBAction)clickCommentBtn:(UIButton *)sender {
    
    !_commentClickBlock ? : _commentClickBlock();
}


@end
