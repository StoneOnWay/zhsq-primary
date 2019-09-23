//
//  XDCreateOrderFootView.h
//  XD业主
//
//  Created by zc on 2018/3/15.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDCreateOrderFootView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *countString;
+ (instancetype)footerViewWithTableView:(UITableView *)tableView;
@end
