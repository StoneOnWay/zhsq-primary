//
//  XDMyPlaceOrderCell.m
//  XD业主
//
//  Created by zc on 2018/3/15.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDMyPlaceOrderCell.h"
#import "XDMyOrderShopModel.h"

@implementation XDMyPlaceOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.cancelBtn.layer setCornerRadius:5];
    [self.cancelBtn.layer setMasksToBounds:YES];
    
    [self.payforBtn.layer setCornerRadius:5];
    [self.payforBtn.layer setMasksToBounds:YES];
    
    self.backgroundColor = backColor;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"XDMyPlaceOrderCell";
    XDMyPlaceOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDMyPlaceOrderCell" owner:nil options:nil]lastObject];
    }
    return cell;
    
}
- (IBAction)clickPayforBtn:(UIButton *)sender {
    
    !_payforClickBlock ? : _payforClickBlock();
}
- (IBAction)clickCancelBtn:(UIButton *)sender {
    !_cancelClickBlock ? : _cancelClickBlock();
}

- (void)setDetailModel:(XDMyOrderDetailModel *)detailModel {
    
    _detailModel = detailModel;
    XDMyOrderShopModel *shopModel = detailModel.shopOrderDetail.firstObject;
    
    //测试而已
    NSDate *date = [NSDate date];
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [dateformater stringFromDate:date];
    self.orderNum.text = dateString;
    
    self.nameLabel.text = shopModel.homeName;
    NSMutableString *timeString = [NSMutableString stringWithFormat:@"%@", detailModel.createtime];
    [timeString deleteCharactersInRange:NSMakeRange(timeString.length-3, 3)];
    self.timeLabels.text = timeString;
    self.payWayLabel.text = @"未知";
    self.moneyLabel.text = [NSString stringWithFormat:@"¥ %@",detailModel.countprice];
    
    
    
}

@end
