//
//  KYShopcartBottomView.h
//  KYShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShopcartBotttomViewAllSelectBlock)(BOOL isSelected);
typedef void(^ShopcartBotttomViewSettleBlock)(void);
typedef void(^ShopcartBotttomViewStarBlock)(void);
typedef void(^ShopcartBotttomViewDeleteBlock)(void);

@interface KYShopcartBottomView : UIView

@property (nonatomic, copy) ShopcartBotttomViewAllSelectBlock shopcartBotttomViewAllSelectBlock;
@property (nonatomic, copy) ShopcartBotttomViewSettleBlock shopcartBotttomViewSettleBlock;
@property (nonatomic, copy) ShopcartBotttomViewStarBlock shopcartBotttomViewStarBlock;
@property (nonatomic, copy) ShopcartBotttomViewDeleteBlock shopcartBotttomViewDeleteBlock;


@property (nonatomic, strong) NSString *totalPrice;

- (void)configureShopcartBottomViewWithTotalPrice:(float)totalPrice
                                       totalCount:(NSInteger)totalCount
                                    isAllselected:(BOOL)isAllSelected;

- (void)changeShopcartBottomViewWithStatus:(BOOL)status;

@end
