//
//  XDCommentListModel.m
//  xd_proprietor
//
//  Created by xielei on 2019/1/26.
//  Copyright © 2019年 zc. All rights reserved.
//

#import "XDCommentListModel.h"

@implementation XDCommentListModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"commentList":@"commentList",
             @"content":@"content",
             @"homePicUrl":@"homePicUrl",
             @"mid":@"id",
             @"ownerid":@"ownerid",
             @"picList":@"picList",
             @"resourceskey":@"resourceskey",
             @"time":@"time",
             @"upNumber":@"upNumber"
             };
}
@end
