//
//  XDDisposeMenCell.h
//  XD业主
//
//  Created by zc on 2017/6/22.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDDisposeMenCell : UITableViewCell

//处理人姓名
@property (weak, nonatomic) IBOutlet UILabel *disposeName;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
