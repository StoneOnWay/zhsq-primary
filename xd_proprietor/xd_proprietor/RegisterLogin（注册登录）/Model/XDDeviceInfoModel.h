//
//  XDDeviceInfoModel.h
//  xd_proprietor
//
//  Created by stone on 9/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDDeviceInfoModel : NSObject<NSCoding>
@property (nonatomic, copy) NSString *deviceSerial;
@property (nonatomic, copy) NSString *location;
@end

NS_ASSUME_NONNULL_END
