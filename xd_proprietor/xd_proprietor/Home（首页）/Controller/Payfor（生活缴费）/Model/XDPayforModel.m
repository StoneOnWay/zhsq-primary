//
//  XDPayforModel.m
//  XD业主
//
//  Created by zc on 2017/11/20.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDPayforModel.h"
#import "XDPayforDataModel.h"

@implementation XDPayforModel

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"data" : [XDPayforDataModel class]};
}

@end
