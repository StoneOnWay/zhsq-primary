//
//  XDSelectProjectController.h
//  xd_proprietor
//
//  Created by cfsc on 2019/7/30.
//  Copyright © 2019年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDProjectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDSelectProjectController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) void (^didSelectedProject)(XDProjectModel *model);
@end

NS_ASSUME_NONNULL_END
