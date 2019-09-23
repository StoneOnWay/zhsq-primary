//
//  XDChooseContactController.h
//  XD业主
//
//  Created by zc on 2017/6/20.
//  Copyright © 2017年 zc. All rights reserved.
//
//所有联系人

#import <UIKit/UIKit.h>
@class XDChooseContactController;
@protocol XDChooseContactControllerDelegate <NSObject>
@optional
-(void)XDChooseContactControllerWithName:(NSString *)name andPhoneNumb:(NSString *)phone;

@end

@interface XDChooseContactController : UITableViewController

@property(nonatomic,weak)id<XDChooseContactControllerDelegate>delegate;


@end
