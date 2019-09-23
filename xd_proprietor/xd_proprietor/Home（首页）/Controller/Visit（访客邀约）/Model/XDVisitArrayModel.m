//
//  XDVisitArrayModel.m
//  XD业主
//
//  Created by zc on 2017/8/10.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDVisitArrayModel.h"
#import "XDVisitModel.h"

@implementation XDVisitArrayModel

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"datalist" : [XDVisitModel class]};
}
@end
