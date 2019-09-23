//
//  XDPageInfoModel.h
//  xd_proprietor
//
//  Created by stone on 15/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDPageInfoModel : NSObject

// 查询数据记录总数
@property (nonatomic, strong) NSNumber *total;
// 当前页码
@property (nonatomic, strong) NSNumber *pageNo;
// 每页记录总数
@property (nonatomic, strong) NSNumber *pageSize;
// 数据列表
@property (nonatomic, copy) NSArray *list;

@end

NS_ASSUME_NONNULL_END
