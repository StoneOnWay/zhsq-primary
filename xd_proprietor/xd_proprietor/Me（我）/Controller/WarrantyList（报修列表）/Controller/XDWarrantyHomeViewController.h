//
//  XDWarrantyHomeViewController.h
//  xd_proprietor
//
//  Created by mason on 2018/9/10.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XDWarrantyHomeViewControllerType) {
    /* 工单/报修 */
    XDWarrantyHomeViewControllerTypeWarranty,
    /* 投诉 */
    XDWarrantyHomeViewControllerTypeComplaint,
    /* 保修筛选 */
    XDWarrantyHomeViewControllerTypeFiltrate,
    /* 评价 */
    XDWarrantyHomeViewControllerTypeEvaluate
};

@protocol XDWarrantyHomeViewControllerDelegate<NSObject>

@optional
- (void)filterParameter:(NSDictionary *)parameter;

@end

@interface XDWarrantyHomeViewController : UIViewController

/** <##> */
@property (assign, nonatomic) XDWarrantyHomeViewControllerType warrantyHomeViewControllerType;

@property (weak, nonatomic) id<XDWarrantyHomeViewControllerDelegate>delegate;
/** <##> */
@property (copy, nonatomic) NSString *ID;
/** <##> */
@property (copy, nonatomic) NSString *taskId;
/** 只有筛选才需要<##> */
@property (assign, nonatomic) XDWarrantyPageType warrantyPageType;

@end
