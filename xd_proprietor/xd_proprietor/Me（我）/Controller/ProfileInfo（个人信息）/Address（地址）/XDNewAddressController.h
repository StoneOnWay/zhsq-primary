//
//  XDNewAddressController.h
//  XD业主
//
//  Created by zc on 2017/6/29.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDNewAddressController;
@protocol XDNewAddressControllerDelegate <NSObject>
@optional
-(void)XDNewAddressControllerWithLouPan:(NSString *)louPan withLouDong:(NSString *)louDong withDanYuan:(NSString *)danYuan withFangHao:(NSString *)fangHao;

@end

@interface XDNewAddressController : UIViewController

@property(nonatomic,weak)id<XDNewAddressControllerDelegate>delegate;

@end
