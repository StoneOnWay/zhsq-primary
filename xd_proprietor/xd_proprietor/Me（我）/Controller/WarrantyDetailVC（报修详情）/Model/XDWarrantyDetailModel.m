//
//  XDWarrantyDetailModel.m
//  XD业主
//
//  Created by zc on 2017/6/22.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDWarrantyDetailModel.h"

@implementation XDWarrantyDetailModel

+ (NSMutableArray *)model{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i<5; i++) {
        XDWarrantyDetailModel *model = [[XDWarrantyDetailModel alloc] init];
        if (i == 0) {
            model.title = @"水管质量差";
            model.finishText = @"已评价";
            model.text = @"家第三方将诶速度快的撒的建安路附近大路口附近啊";
        }else if (i ==1){
            model.title = @"现场情况";
            model.text = @"家第三方将诶赛换地方is大速度快的撒的建安路附近大路口附近啊";
            
        }else if (i ==2){
            model.title = @"解决方案";
            model.text = @"家第三方家第三方将诶赛换地方is大速度快的撒的建安路附近大路口附近啊家第三方将诶赛换地方is大速度快的撒的建安路附近大路口附近啊";
        }else {
            
            model.title = @"处理结果";
            model.text = @"已经安装完成";
        }
        
        
        model.time = @"2017-06-22 15:23:55";
//        model.photos = @[@"",@"",@""];
        
        
        
        [arr addObject: model];
    }
    return arr;
}



@end
