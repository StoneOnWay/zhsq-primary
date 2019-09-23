//
//  ContactCell.h
//  XＤ
//
//  Created by zc on 17/4/2.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic ,copy)void (^selectContactBtn)();

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
