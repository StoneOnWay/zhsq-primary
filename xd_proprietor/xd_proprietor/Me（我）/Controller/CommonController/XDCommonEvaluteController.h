//
//  XDCommonEvaluteController.h
//  XD业主
//
//  Created by zc on 2017/6/23.
//  Copyright © 2017年 zc. All rights reserved.
//
/**********评价控制器**********/

#import <UIKit/UIKit.h>

@interface XDCommonEvaluteController : UIViewController

// 因为工单和投诉重用这个控制器
@property (nonatomic ,copy)NSString *navTitle;

// 用来上传评价的参数
@property (nonatomic ,copy)NSString *taskId;

// 报事报修用来上传评价的参数如果不是为空就是评价报事报修的
//如果没空就是评价投诉的
@property (nonatomic ,strong)NSNumber *repairsId;

// 投诉用来上传评价的参数
@property (nonatomic ,strong)NSNumber *ComplainId;

@end
