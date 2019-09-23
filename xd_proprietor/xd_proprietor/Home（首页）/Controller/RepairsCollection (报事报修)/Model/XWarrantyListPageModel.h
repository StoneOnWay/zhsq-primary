//
//  XWarrantyListPageModel.h
//  XD业主
//
//  Created by zc on 2017/6/26.
//  Copyright © 2017年 zc. All rights reserved.
//
// pagination这个的模型

#import <Foundation/Foundation.h>

@interface XWarrantyListPageModel : NSObject


/** string  当前页面*/
@property (nonatomic, copy) NSString *currentPage;

/** string 	页面的大小*/
@property (nonatomic, strong) NSNumber *pageSize;

/** string 	一共多少页面*/
@property (nonatomic, copy) NSString *totalPages;

/** string 	请求结果有多少*/
@property (nonatomic, copy) NSString *totalResults;


@end
