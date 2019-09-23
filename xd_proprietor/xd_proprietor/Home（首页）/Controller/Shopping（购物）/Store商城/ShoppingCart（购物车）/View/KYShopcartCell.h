//
//  KYShopcartCell.h
//  KYShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShopcartCellBlock)(BOOL isSelected);
typedef void(^ShopcartCellEditBlock)(NSInteger count);

@interface KYShopcartCell : UITableViewCell

@property (nonatomic, copy) ShopcartCellBlock shopcartCellBlock;
@property (nonatomic, copy) ShopcartCellEditBlock shopcartCellEditBlock;

- (void)configureShopcartCellWithProductURL:(NSString *)productURL
                                productName:(NSString *)productName
                               productPrice:(NSString *)productPrice
                                productDisCountPrice:(NSString *)disCountPrice
                               productCount:(NSInteger)productCount
                               productSize:(NSString *)productSize
                            productSelected:(BOOL)productSelected;

@property (nonatomic, assign) BOOL isEdit; //是否在编辑状态

@end
