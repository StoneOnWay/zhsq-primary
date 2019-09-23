//
//  XDWarrantyDetailModel.h
//  XD业主
//
//  Created by zc on 2017/6/22.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDWarrantyDetailModel : NSObject

//描述（水管质量差）Frame
@property (nonatomic, copy) NSString *title;
//地址
@property (nonatomic, copy) NSString *address;
//正文详情
@property (nonatomic, copy) NSString *text;
//时间
@property (nonatomic, copy) NSString *time;

//进程的（已解决还是待确认）Frame
@property (nonatomic, copy) NSString *finishText;

//图片
@property (nonatomic, strong) NSArray *photos;

//是否有图片(用来区分 那个解决方案没有图片的原因，可以不需要在重复创建)
//@property (nonatomic ,assign) BOOL isHavePhotos;


//测试
+ (NSMutableArray *)model;


@end
