//
//  XDWorkProgressViewController.h
//  xd_proprietor
//
//  Created by mason on 2018/9/7.
//Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDWorkProgressViewController : UITableViewController
/** <##> */
@property (assign, nonatomic) XDWarrantyPageType warrantyPageType;
//维修id
@property (copy, nonatomic) NSNumber *repairsId;

@end
