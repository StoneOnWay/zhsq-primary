//
//  KYShopcartFormat.m
//  KYShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import "KYShopcartFormat.h"
#import "KYShopcartBrandModel.h"
#import "MJExtension.h"
#import <UIKit/UIKit.h>

@interface KYShopcartFormat ()

@property (nonatomic, strong) NSMutableArray *shopcartListArray;    /**< 购物车数据源 */

@end

@implementation KYShopcartFormat

- (void)requestShopcartProductList:(BOOL)isfresh {
    //在这里请求数据 当然我直接用本地数据模拟的
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"shopcart" ofType:@"plist"];
//    NSMutableArray *dataArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    if (isfresh) {
        [MBProgressHUD showActivityMessageInWindow:nil];
    }
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSNumber *userId = loginModel.userInfo.userId;
    //请求数据
    NSDictionary *dic = @{
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"userId":userId,
                          };
    
    [[XDAPIManager sharedManager] requestMyShopCart:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        [MBProgressHUD hideHUD];
        KYShopcartBrandModel *brand = [KYShopcartBrandModel mj_objectWithKeyValues:responseObject];
        if ([brand.resultCode isEqualToString:@"0"]) {
         
            [self.shopcartListArray removeAllObjects];
            self.shopcartListArray = [NSMutableArray arrayWithObjects:brand, nil];
            //成功之后回调
            [self.delegate shopcartFormatRequestProductListDidSuccessWithArray:self.shopcartListArray];
        }
    }];

    
}


- (void)selectProductAtIndexPath:(NSIndexPath *)indexPath isSelected:(BOOL)isSelected {
    KYShopcartBrandModel *brandModel = self.shopcartListArray[indexPath.section];
    KYShopcartProductModel *productModel = brandModel.data[indexPath.row];
    productModel.isSelected = isSelected;
    
    BOOL isBrandSelected = YES;
    
    for (KYShopcartProductModel *aProductModel in brandModel.data) {
        if (aProductModel.isSelected == NO) {
            isBrandSelected = NO;
        }
    }
    
    brandModel.isSelected = isBrandSelected;
    
    [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
}

- (void)selectBrandAtSection:(NSInteger)section isSelected:(BOOL)isSelected {
    KYShopcartBrandModel *brandModel = self.shopcartListArray[section];
    brandModel.isSelected = isSelected;
    
    for (KYShopcartProductModel *aProductModel in brandModel.data) {
        aProductModel.isSelected = brandModel.isSelected;
    }
    
    [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
}

- (void)changeCountAtIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count {
    KYShopcartBrandModel *brandModel = self.shopcartListArray[indexPath.section];
    KYShopcartProductModel *productModel = brandModel.data[indexPath.row];
    if (count <= 0) {
        count = 1;
    } else if (count > productModel.productStocks) {
        count = productModel.productStocks;
    }
    
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSInteger cartid = productModel.cartid;
    NSInteger goodsid = productModel.ids;
    //请求数据
    NSDictionary *dic = @{
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"cartid":@(cartid),
                          @"goodsid":@(goodsid),
                          @"number":@(count),
                          };
    [MBProgressHUD showActivityMessageInWindow:nil];
    [[XDAPIManager sharedManager] requestUpDateCartNum:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        [MBProgressHUD hideHUD];
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            //根据请求结果决定是否改变数据
            productModel.count = count;
            [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
        }
    }];

    
    
}

- (void)deleteProductAtIndexPath:(NSIndexPath *)indexPath {
    KYShopcartBrandModel *brandModel = self.shopcartListArray[indexPath.section];
    KYShopcartProductModel *productModel = brandModel.data[indexPath.row];
    
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSInteger cartid = productModel.cartid;
    NSInteger goodsid = productModel.ids;
    //请求数据
    NSDictionary *dic = @{
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"cartid":@(cartid),
                          @"goodsid":@(goodsid),
                          };
    [MBProgressHUD showActivityMessageInWindow:nil];
    [[XDAPIManager sharedManager] requestCartDelete:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        [MBProgressHUD hideHUD];
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            
            //根据请求结果决定是否删除
            [brandModel.data removeObject:productModel];
            if (brandModel.data.count == 0) {
                [self.shopcartListArray removeObject:brandModel];
            } else {
                if (!brandModel.isSelected) {
                    BOOL isBrandSelected = YES;
                    for (KYShopcartProductModel *aProductModel in brandModel.data) {
                        if (!aProductModel.isSelected) {
                            isBrandSelected = NO;
                            break;
                        }
                    }
                    
                    if (isBrandSelected) {
                        brandModel.isSelected = YES;
                    }
                }
            }
            
            [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
            
            if (self.shopcartListArray.count == 0) {
                [self.delegate shopcartFormatHasDeleteAllProducts];
            }
        }
    }];
   
}

- (void)beginToDeleteSelectedProducts {
    NSMutableArray *selectedArray = [[NSMutableArray alloc] init];
    for (KYShopcartBrandModel *brandModel in self.shopcartListArray) {
        for (KYShopcartProductModel *productModel in brandModel.data) {
            if (productModel.isSelected) {
                [selectedArray addObject:productModel];
            }
        }
    }
    
    [self.delegate shopcartFormatWillDeleteSelectedProducts:selectedArray];
}

- (void)deleteSelectedProducts:(NSArray *)selectedArray {
    //网络请求
    //根据请求结果决定是否批量删除
    NSMutableArray *emptyArray = [[NSMutableArray alloc] init];
    for (KYShopcartBrandModel *brandModel in self.shopcartListArray) {
        [brandModel.data removeObjectsInArray:selectedArray];
        
        if (brandModel.data.count == 0) {
            [emptyArray addObject:brandModel];
        }
    }
    
    if (emptyArray.count) {
        [self.shopcartListArray removeObjectsInArray:emptyArray];
    }
    
    [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
    
    if (self.shopcartListArray.count == 0) {
        [self.delegate shopcartFormatHasDeleteAllProducts];
    }
}

- (void)starProductAtIndexPath:(NSIndexPath *)indexPath {
    //这里写收藏的网络请求
    
}

- (void)starSelectedProducts {
    //这里写批量收藏的网络请求
    
}

- (void)selectAllProductWithStatus:(BOOL)isSelected {
    for (KYShopcartBrandModel *brandModel in self.shopcartListArray) {
        brandModel.isSelected = isSelected;
        for (KYShopcartProductModel *productModel in brandModel.data) {
            productModel.isSelected = isSelected;
        }
    }
    
    [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
}

- (void)settleSelectedProducts {
    NSMutableArray *settleArray = [[NSMutableArray alloc] init];
    for (KYShopcartBrandModel *brandModel in self.shopcartListArray) {
        NSMutableArray *selectedArray = [[NSMutableArray alloc] init];
        for (KYShopcartProductModel *productModel in brandModel.data) {
            if (productModel.isSelected) {
                [selectedArray addObject:productModel];
            }
        }
    
        brandModel.selectedArray = selectedArray;
        
        if (selectedArray.count) {
            [settleArray addObject:brandModel];
        }
    }
    
    [self.delegate shopcartFormatSettleForSelectedProducts:settleArray];
}

#pragma mark private methods

- (float)accountTotalPrice {
    float totalPrice = 0.f;
    for (KYShopcartBrandModel *brandModel in self.shopcartListArray) {
        for (KYShopcartProductModel *productModel in brandModel.data) {
            if (productModel.isSelected) {
                totalPrice += [productModel.discountprice floatValue] * productModel.count;
            }
        }
    }
    
    return totalPrice;
}

- (NSInteger)accountTotalCount {
    NSInteger totalCount = 0;
    
    for (KYShopcartBrandModel *brandModel in self.shopcartListArray) {
        for (KYShopcartProductModel *productModel in brandModel.data) {
            if (productModel.isSelected) {
                totalCount += productModel.count;
            }
        }
    }
    
    return totalCount;
}

- (BOOL)isAllSelected {
    if (self.shopcartListArray.count == 0) return NO;
    
    BOOL isAllSelected = YES;
    
    for (KYShopcartBrandModel *brandModel in self.shopcartListArray) {
        if (brandModel.isSelected == NO) {
            isAllSelected = NO;
        }
    }
    
    return isAllSelected;
}

@end
