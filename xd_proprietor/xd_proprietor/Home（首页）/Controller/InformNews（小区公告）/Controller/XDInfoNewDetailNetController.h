//
//  XDInfoNewDetailNetController.h
//  XD业主
//
//  Created by zc on 2017/6/30.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDInfoNewModel.h"

@interface XDInfoNewDetailNetController : UIViewController

//公告模型
@property (nonatomic , strong) XDInfoNewModel *infoModel;
///** 标题*/
//@property (nonatomic , strong)NSString *titleName;
//
///** 发布者名字 	*/
//@property (nonatomic, copy) NSString *publisherName;
//
///** 发布时间 	*/
//@property (copy , nonatomic)NSString *publishTime;
//
///** webView Url 	*/
//@property (nonatomic, copy) NSString *detailUrl;

@property (nonatomic, copy) void (^readCountDidUpdate)(void);

@end
