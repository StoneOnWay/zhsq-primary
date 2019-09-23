//
//  XDContactFootView.h
//  XD业主
//
//  Created by zc on 2017/6/20.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface XDContactFootView : UITableViewHeaderFooterView

+ (instancetype)footerViewWithTableView:(UITableView *)tableView;


@property(nonatomic, copy)void (^btnClicked)(NSInteger index);

@end
