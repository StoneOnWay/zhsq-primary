//
//  XDWarrantyWorkProgressTableViewCell.h
//  xd_proprietor
//
//  Created by mason on 2018/9/7.
//Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDWarrantyDetailNetDataModel.h"

@interface XDWarrantyWorkProgressTableViewCell : UITableViewCell

@property (strong, nonatomic) XDWarrantyDetailNetDataModel *warrantyDetailNetDataModel;

/** <##> */
@property (copy, nonatomic) NSDictionary *dictionary;


@end
