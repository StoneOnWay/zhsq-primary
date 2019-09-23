//
//  XDAddProjectController.h
//  xd_proprietor
//
//  Created by cfsc on 2019/9/19.
//  Copyright © 2019年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDProjectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDAddProjectController : UIViewController
@property (nonatomic, copy) void (^didAddProject)(XDProjectModel *model);
@end

NS_ASSUME_NONNULL_END
