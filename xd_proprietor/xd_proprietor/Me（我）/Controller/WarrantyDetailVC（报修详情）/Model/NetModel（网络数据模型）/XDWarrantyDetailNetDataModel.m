//
//  XDWarrantyDetailNetDataModel.m
//  XD业主
//
//  Created by zc on 2017/6/26.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDWarrantyDetailNetDataModel.h"

@implementation XDWarrantyDetailNetDataModel

- (XDWorkOrderStatus)workOrderStatus {
    return [self.repairsStatusId integerValue];
}

@end
