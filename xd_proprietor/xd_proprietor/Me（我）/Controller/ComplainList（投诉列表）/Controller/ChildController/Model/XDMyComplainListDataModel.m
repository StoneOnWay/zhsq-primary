//
//  XDMyComplainListDataModel.m
//  XD业主
//
//  Created by zc on 2017/6/28.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDMyComplainListDataModel.h"
#import "XDMyComplainListModel.h"
@implementation XDMyComplainListDataModel

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"complainEntityList" : [XDMyComplainListModel class]};
}


@end
