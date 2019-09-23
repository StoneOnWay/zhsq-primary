//
//  XDProjectModel.h
//  xd_proprietor
//
//  Created by cfsc on 2019/7/31.
//  Copyright © 2019年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDProjectModel : NSObject <NSCoding>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *ip;
@end

NS_ASSUME_NONNULL_END
