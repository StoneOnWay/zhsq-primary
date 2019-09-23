//
//  XDHTTPManager.m
//  XＤ
//
//  Created by zc on 17/5/4.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDHTTPManager.h"

#define BaseURL [NSURL URLWithString:@"http://baidu.com/"]

@implementation XDHTTPManager


+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static XDHTTPManager *manager;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initWithBaseURL:BaseURL];
        
        // 设置Https加密策略
//        AFSecurityPolicy *security  = [AFSecurityPolicy defaultPolicy];
//        security.allowInvalidCertificates = YES;
//        manager.securityPolicy = security;
        
        manager.requestSerializer.timeoutInterval = 15.0f;
        //NSLocalizedDescription=Request failed: unacceptable content-type: text/html}
        //数据类型解析失败，这个错误工作中经常见到
        //设置更多的数据类型
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript" ,@"text/html", nil];
    });
    return manager;
}

- (void)POST:(NSString *)path parameters:(id)parameters completionHandle:(void(^)(id responseObject,NSError *error))completionHandle {
    // add by stone
    if ([path hasPrefix:iscID]) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    } else {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
    }

    [self POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        completionHandle(responseObject,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        completionHandle(nil,error);
    }];
}

- (void)GET:(NSString *)path parameters:(id)parameters completionHandle:(void (^)(id, NSError *))completionHandle
{
    [self GET:path parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandle(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandle(nil,error);
    }];
    
}

// 以文件形式上传
- (void)POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(NSString *)imagePath name:(NSString *)name completionHandle:(void (^)(id, NSError *))completionHandle {

    [self POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传的参数(上传图片，以文件的格式)
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:imagePath] name:name error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        completionHandle(responseObject,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        completionHandle(nil,error);
        
    }];
    
}

// 以文件流形式上传
- (void)POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(NSArray *)imageDatas completionHandle:(void (^)(id, NSError *))completionHandle {
    
    [self POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //上传的参数(上传图片，以文件流的格式)
        if (imageDatas.count != 0) {
            
            for (int i = 0; i < imageDatas.count; i++) {
                NSData *data = [imageDatas objectAtIndex:i];
                [formData appendPartWithFileData:data name:@"pic" fileName:[NSString stringWithFormat:@"image%ld.png",(long)i]  mimeType:@"image/png"];
                
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        completionHandle(responseObject,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        completionHandle(nil,error);
        
    }];
    
}

@end
