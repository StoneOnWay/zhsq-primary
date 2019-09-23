//
//  XDContentEditTableViewCell.h
//  xd_proprietor
//
//  Created by mason on 2018/9/7.
//Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDWarrantyDetailNetDataModel.h"

typedef NS_ENUM(NSInteger, XDContentEditType) {
    XDContentEditTypeInput,
    XDContentEditTypeLabel
};

@interface XDContentEditTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *priceView;

/** <##> */
@property (copy, nonatomic) NSDictionary *dictionary;

@property (strong, nonatomic) XDWarrantyDetailNetDataModel *warrantyDetailNetDataModel;

@end
