//
//  XDMyComplainDetailController.h
//  XD业主
//
//  Created by zc on 2017/6/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XDMyComplainDetailController : UIViewController

//维修id
@property (nonatomic ,strong)NSNumber *complainId;

//由列表传过来的参数底部视图的类型（无，是否接受价格，评价）
@property (nonatomic,copy) NSString *jbpmOutcomes;

//自己需要操作的时候需要传这个参数
@property (nonatomic,copy) NSString *taskid;

//自己需要操作的时候需要传这个参数
@property (nonatomic,copy) NSString *piid;

//返回并刷新
@property (nonatomic ,copy) void(^backToRefresh)();

@end
