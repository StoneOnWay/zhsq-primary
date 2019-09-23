//
//  XDCardPageModel.m
//  xd_proprietor
//
//  Created by stone on 16/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDCardPageModel.h"
#import "XDCardInfoModel.h"

@implementation XDCardPageModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list":[XDCardInfoModel class]};
}

@end
