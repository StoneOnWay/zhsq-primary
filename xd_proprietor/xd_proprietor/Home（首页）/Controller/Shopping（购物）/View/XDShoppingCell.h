//
//  XDShoppingCell.h
//  XD业主
//
//  Created by zc on 2018/3/6.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDShoppingModel.h"
@interface XDShoppingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *namesLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) XDShoppingModel *shopModel;
@end
