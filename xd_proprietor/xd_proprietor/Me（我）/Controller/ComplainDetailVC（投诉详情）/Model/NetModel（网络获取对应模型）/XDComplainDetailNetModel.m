//
//  XDComplainDetailNetModel.m
//  XD业主
//
//  Created by zc on 2017/6/28.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDComplainDetailNetModel.h"

@implementation XDComplainDetailNetModel

- (XDComplainStatusStatus)complainStatusStatus {
    return [self.complainStatusId integerValue];
}

@end
