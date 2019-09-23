//
//  XDHTTPManager.h
//  XＤ
//
//  Created by zc on 17/5/4.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface XDHTTPManager : AFHTTPSessionManager


+ (instancetype)sharedManager;

- (void)POST:(NSString *)path parameters:(id)parameters completionHandle:(void(^)(id responseObject,NSError *error))completionHandle;

- (void)GET:(NSString *)path parameters:(id)parameters completionHandle:(void(^)(id responseObject,NSError *error))completionHandle;

// 以文件形式上传
- (void)POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(NSString *)imagePath name:(NSString *)name completionHandle:(void (^)(id, NSError *))completionHandle;

// 以文件流形式上传
- (void)POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(NSArray *)imageDatas completionHandle:(void (^)(id, NSError *))completionHandle;

@end
