//
//  XDProcessModel.h
//  XD业主
//
//  Created by zc on 2017/6/23.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDProcessModel.h"

@implementation XDProcessModel

+ (NSMutableArray *)model {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i<9; i++) {
        XDProcessModel *model = [[XDProcessModel alloc] init];
        switch (i) {
            case 0:
                model.notAcceptable = 1;
                model.handlertype = @"0";
                model.planName = @"未受理";
                model.planDateTime = @"2017-06-23 15:55:55";
                break;
            case 1:
                model.notAcceptable = 1;
                model.handlertype = @"1";
                model.planName = @"接受地点受理";
                model.planDateTime = @"2017-06-23 15:55:55";
                
                break;
            case 2:
                model.notAcceptable = 0;
                model.handlertype = @"1";
                model.planName = @"已受理";
                model.planDateTime = @"2017-06-23 15:55:55";
                break;
            case 3:
                model.notAcceptable = 1;
                model.handlertype = @"1";
                model.planName = @"未受理";
                model.planDateTime = @"2017-06-23 15:55:55";
                break;
            case 4:
                model.notAcceptable = 0;
                model.handlertype = @"0";
                model.planName = @"未受理";
                model.planDateTime = @"2017-06-23 15:55:55";
                break;
            case 5:
                model.notAcceptable = 1;
                model.handlertype = @"1";
                model.planName = @"未受理";
                model.planDateTime = @"2017-06-23 15:55:55";
                break;
            case 6:
                model.notAcceptable = 1;
                model.handlertype = @"1";
                model.planName = @"未受理";
                model.planDateTime = @"2017-06-23 15:55:55";
                break;
                
            default:
                
                model.notAcceptable = 1;
                model.handlertype = @"1";
                model.planName = @"未受理";
                model.planDateTime = @"2017-06-23 15:55:55";
                
                break;
        }
        [arr addObject:model];
        
    }
    
    
    return arr;
    
}

@end
