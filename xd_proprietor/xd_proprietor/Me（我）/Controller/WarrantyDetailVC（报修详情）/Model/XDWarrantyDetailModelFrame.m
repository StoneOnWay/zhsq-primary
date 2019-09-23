//
//  XDWarrantyDetailModelFrame.m
//  XD业主
//
//  Created by zc on 2017/6/22.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDWarrantyDetailModelFrame.h"

@implementation XDWarrantyDetailModelFrame

- (void)setWarrantyModel:(XDWarrantyDetailModel *)warrantyModel {
    _warrantyModel = warrantyModel;

    //计算子控件frame
    [self setUpWarrantySubviewsFrame];
    
    
}
- (void)setUpWarrantySubviewsFrame {
    
    //cell最上的标题
    CGFloat titleX = WMargin;
    CGFloat titleY = 0;
    
    CGSize titleSize = [self.warrantyModel.title sizeWithAttributes:titleAttributes];
    self.titleFrame = (CGRect){{titleX,titleY},titleSize};
    
    //维修地址
    CGFloat textY = CGRectGetMaxY(self.titleFrame) + HMargin;
    if (self.warrantyModel.address.length != 0) {
        CGSize planTimeSize = [self.warrantyModel.address boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttributes context:nil].size;
        self.addressFrame = (CGRect){{WMargin,textY},planTimeSize};
        textY = CGRectGetMaxY(self.addressFrame) + HMargin;
    }
    
    //是否已完成的label
    CGFloat finishY = titleY;
    CGSize finishSize = [self.warrantyModel.finishText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:nil].size;
    CGFloat finishX = kScreenWidth-WMargin-finishSize.width;
    self.finishFrame = (CGRect){{finishX,finishY},finishSize};
    
    //正文
    CGFloat textX = WMargin;
    CGFloat textW = kScreenWidth - WMargin * 2;
    CGSize textSize = [self.warrantyModel.text boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttributes context:nil].size;
    self.textFrame = (CGRect){{textX,textY},textSize};
    
    
    //时间
    CGFloat timeY = CGRectGetMaxY(self.textFrame) + HMargin;
    CGSize timeSize = [self.warrantyModel.time boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:timeAttributes context:nil].size;
    CGFloat timeX = kScreenWidth-WMargin-timeSize.width;
    self.timeFrame = (CGRect){{timeX,timeY},timeSize};
    
    
    //图片 (判断是否有图片)
    if (self.warrantyModel.photos.count != 0) {
        
        CGFloat photosX = WMargin;
        CGFloat photosY = CGRectGetMaxY(self.timeFrame) + HMargin;
        CGFloat photosW = textW;
        CGFloat photosH = textW/4;
        self.photoViewFrame = CGRectMake(photosX, photosY, photosW, photosH);
        
    }
    
    
    
}

- (CGFloat)cellHeight {
    
    if (self.warrantyModel.photos.count != 0) {
        
        
        return CGRectGetMaxY(self.photoViewFrame)+HMargin*2;
        
    }else {
        
        return CGRectGetMaxY(self.timeFrame)+HMargin*2;
        
    }
    
    
    
}
@end
