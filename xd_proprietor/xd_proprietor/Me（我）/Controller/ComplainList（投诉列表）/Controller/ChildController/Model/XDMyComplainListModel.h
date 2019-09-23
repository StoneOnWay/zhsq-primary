//
//  XDMyComplainListModel.h
//  XD业主
//
//  Created by zc on 2017/6/28.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDMyComplainListModel : NSObject

/** string  服务器需要传的参数*/
@property (nonatomic, copy) NSString *piid;

/** string 	报修的id*/
@property (nonatomic, strong) NSNumber *complainId;

/** string 	维修状态*/
@property (nonatomic, copy) NSString *complainStatus;

/** string 	维修的时间*/
@property (nonatomic, copy) NSString *complainDateTime;

/** string 	维修的标题*/
@property (nonatomic, copy) NSString *complainTitle;

/** string 	*/
@property (nonatomic, copy) NSString *resourcekey;

/** string 	用于判定这个维修该由谁操作*/
@property (nonatomic, strong) NSArray *jbpmOutcomes;


/** string 	图片的路径*/
@property (nonatomic, strong) NSArray *complainImageUrl;


//是否是自己进行操作
@property (copy , nonatomic)NSString *taskid;


@end
