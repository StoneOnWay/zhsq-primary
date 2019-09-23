//
//  XDAddMyCarsFootView.h
//  XD业主
//
//  Created by zc on 2017/7/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDAddMyCarsFootView : UITableViewHeaderFooterView

@property(nonatomic,copy)void (^commitBlock)();
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

+ (instancetype)footerViewWithTableView:(UITableView *)tableView;

@end
