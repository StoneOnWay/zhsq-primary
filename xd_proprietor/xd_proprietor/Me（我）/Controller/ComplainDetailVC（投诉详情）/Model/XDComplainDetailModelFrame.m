//
//  XDComplainDetailModelFrame.m
//  XD业主
//
//  Created by zc on 2017/6/22.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDComplainDetailModelFrame.h"



@implementation XDComplainDetailModelFrame

//set方法
- (void)setComplainModel:(XDComplainDetailModel *)complainModel {

    _complainModel = complainModel;
    
    //计算子控件frame
    [self setUpSubviewsFrame];

}

- (void)setUpSubviewsFrame {

    //cell最上的标题
    CGFloat titleX = WMargin;
    CGFloat titleY = 0;

    CGSize titleSize = [self.complainModel.title sizeWithAttributes:titleAttributes];
    self.titleFrame = (CGRect){{titleX,titleY},titleSize};
    
    //是否已完成的label
    CGFloat finishY = titleY;
    CGSize finishSize = [self.complainModel.finishText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:nil].size;
    CGFloat finishX = kScreenWidth-WMargin-finishSize.width;
    self.finishFrame = (CGRect){{finishX,finishY},finishSize};
    
    //正文
    CGFloat textX = WMargin;
    CGFloat textY = CGRectGetMaxY(self.titleFrame) + HMargin;
    CGFloat textW = kScreenWidth - WMargin * 2;
    CGSize textSize = [self.complainModel.text boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttributes context:nil].size;
    self.textFrame = (CGRect){{textX,textY},textSize};
    
    
    //时间
    CGFloat timeY = CGRectGetMaxY(self.textFrame) + HMargin;
    CGSize timeSize = [self.complainModel.time boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:timeAttributes context:nil].size;
    CGFloat timeX = kScreenWidth-WMargin-timeSize.width;
    self.timeFrame = (CGRect){{timeX,timeY},timeSize};
    
    
    //图片 (判断是否有图片)
    if (self.complainModel.photos.count != 0) {
        
        CGFloat photosX = WMargin;
        CGFloat photosY = CGRectGetMaxY(self.timeFrame) + HMargin;
        CGFloat photosW = textW;
        CGFloat photosH = textW/4;
        self.photoViewFrame = CGRectMake(photosX, photosY, photosW, photosH);
        
    }
    
    

}

- (CGFloat)cellHeight {

    if (self.complainModel.photos.count != 0) {
        
        
        return CGRectGetMaxY(self.photoViewFrame)+HMargin*2;
        
    }else {
        
        return CGRectGetMaxY(self.timeFrame)+HMargin*2;
        
    }
    
    

}
@end
