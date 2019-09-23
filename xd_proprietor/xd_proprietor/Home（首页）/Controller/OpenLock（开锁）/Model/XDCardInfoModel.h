//
//  XDCardInfoModel.h
//  xd_proprietor
//
//  Created by stone on 16/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDCardInfoModel : NSObject

// 卡片ID
@property (nonatomic, copy) NSString *cardId;
// 卡号
@property (nonatomic, copy) NSString *cardNo;
// 持卡人ID
@property (nonatomic, copy) NSString *personId;
// 持卡人姓名
@property (nonatomic, copy) NSString *personName;

@end

NS_ASSUME_NONNULL_END
