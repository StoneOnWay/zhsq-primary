//
//  AddressCell.m
//  XＤ
//
//  Created by zc on 17/5/12.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"AddressCell";
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddressCell" owner:nil options:nil] lastObject];
    }
    return cell;
    
}
- (IBAction)choiceBtnClicked:(UIButton *)sender {
    
    if (self.selectAddressBtn) {
        self.selectAddressBtn();
    }
}

@end
