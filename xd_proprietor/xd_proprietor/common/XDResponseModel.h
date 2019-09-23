//
//  XDResponseModel.h
//  xd_proprietor
//
//  Created by stone on 15/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDResponseModel : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSDictionary *data;

@end

NS_ASSUME_NONNULL_END
