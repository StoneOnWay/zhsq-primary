//
//  XDWarrantyListController
//  XD业主
//
//  Created by zc on 2017/6/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDWarrantyListController : UIViewController

/** <##> */
@property (assign, nonatomic) XDWarrantyPageType warrantyPageType;

@property (assign, nonatomic) XDWarrantyTaskStatus warrantyTaskStatus;
/** <##> */
@property (copy, nonatomic) NSDictionary *parameter;

- (void)loadDataIsFirstPage:(BOOL)isFirstPage;

@end
