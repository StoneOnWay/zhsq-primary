//
//  XDVisitListModel.h
//  XD业主
//
//  Created by zc on 2017/8/10.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDVisitArrayModel.h"

@interface XDVisitListModel : NSObject

@property (strong , nonatomic)XDVisitArrayModel *data;//数据

@property (copy , nonatomic)NSString *msg;//状态码

@property (assign , nonatomic)NSInteger resultCode;//是否成功


@end
