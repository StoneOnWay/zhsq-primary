//
//  XDFunDetailViewController.h
//  xd_proprietor
//
//  Created by xielei on 2019/1/27.
//  Copyright © 2019年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDCommentListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XDFunDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong,nonatomic) XDCommentListModel *listModel;
// 点赞或者删除后需要更新其他页面数据
@property (nonatomic, copy) void (^shouldUpdateFunAllDataBlock)(void);
@end

NS_ASSUME_NONNULL_END
