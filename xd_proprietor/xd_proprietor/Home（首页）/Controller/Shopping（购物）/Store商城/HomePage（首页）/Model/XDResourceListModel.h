//
//  XDResourceListModel.h
//  XD业主
//
//  Created by zc on 2018/3/8.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDResourceListModel : NSObject

@property (nonatomic, assign) NSInteger resourceid;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *oldurl;
@property (nonatomic, copy) NSString *uploadtime;
@property (nonatomic, copy) NSString *resourcekey;

@end
