//
//  AddressCell.h
//  XＤ
//
//  Created by zc on 17/5/12.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *AddressLab;

@property (weak, nonatomic) IBOutlet UIButton *choiceBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic ,copy)void (^selectAddressBtn)();

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
