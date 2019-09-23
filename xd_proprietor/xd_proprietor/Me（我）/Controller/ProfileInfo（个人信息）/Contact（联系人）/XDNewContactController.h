//
//  XDNewContactController.h
//  XD业主
//
//  Created by zc on 2017/6/29.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDNewContactController;
@protocol XDNewContactControllerDelegate <NSObject>
@optional
-(void)XDNewContactControllerWithName:(NSString *)name andPhoneNumber:(NSString *)phone withRelationShip:(NSString *)relationShip;

@end


@interface XDNewContactController : UIViewController

@property(nonatomic,weak)id<XDNewContactControllerDelegate>delegate;


@end
