//
//  XDInfoNewModel.m
//  XD业主
//
//  Created by zc on 2017/6/30.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDInfoNewModel.h"
#import "XDAttachmentModel.h"

@implementation XDInfoNewModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"resourceList":[XDAttachmentModel class]};
}

@end
