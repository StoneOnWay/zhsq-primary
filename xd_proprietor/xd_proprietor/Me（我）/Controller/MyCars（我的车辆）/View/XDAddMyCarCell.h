//
//  XDAddMyCarCell.h
//  XD业主
//
//  Created by zc on 2017/7/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDAddMyCarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabels;
@property (weak, nonatomic) IBOutlet UITextField *inputText;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
