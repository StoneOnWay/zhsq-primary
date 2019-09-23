//
//  XDInfoNewModel.h
//  XD业主
//
//  Created by zc on 2017/6/30.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDInfoNewModel : NSObject

/** string  图片*/
@property (nonatomic, copy) NSString *noticeImgUrl;

// noticeImgUrl加载的图片
@property (nonatomic, strong) UIImage *noticeImg;

/** string 	*/
@property (nonatomic, strong) NSNumber *receive;

/** string     */
@property (nonatomic, strong) NSString *resources;

/** string 	标题*/
@property (nonatomic, copy) NSString *title;

/** string 	*/
@property (nonatomic, strong) NSNumber *publisher;

/** string 	点赞数*/
@property (nonatomic, strong) NSNumber *upNO;

/** string 	*/
@property (nonatomic, copy) NSString *publisherName;

/** string 	是否已阅读*/
@property (nonatomic, strong) NSNumber *readedNO;

/** string 	*/
@property (copy , nonatomic)NSString *publishTime;

/** string 	*/
@property (nonatomic, strong) NSNumber *noticeId;

/** string 	*/
@property (nonatomic, copy) NSString *detailUrl;

/** string 	正文*/
@property (nonatomic, copy) NSString *remark;

/** string 	*/
@property (nonatomic, copy) NSString *content;


@property (nonatomic, assign) NSInteger praises;

/** string 	阅读数*/
@property (nonatomic, assign) NSInteger reads;

// 通知类型
@property (nonatomic, strong) NSNumber *noticeType;

@property (nonatomic, copy) NSArray *resourceList;

// 封面图片
@property (nonatomic, copy) NSString *coverImgUrl;

@end
