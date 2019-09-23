//
//  XDContactModel.h
//  XD业主
//
//  Created by zc on 2017/6/25.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDContactModel : NSObject

/** string 	联系人id*/
@property (nonatomic, strong) NSNumber *linkmanId;

/** string  联系人电话*/
@property (nonatomic, copy) NSString *linkmanMobileNo;

/** string 	联系人名字*/
@property (nonatomic, copy) NSString *linkmanName;

/** string 	与联系人的关系*/
@property (nonatomic, copy) NSString *relationship;


@end
