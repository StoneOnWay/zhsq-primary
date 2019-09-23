//
//  XDChooseAddressController.h
//  XD业主
//
//  Created by zc on 2017/6/29.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDChooseAddressController;
@protocol XDChooseAddressControllerDelegate <NSObject>
@optional
-(void)XDChooseAddressControllerWithName:(NSString *)name;

@end

@interface XDChooseAddressController : UITableViewController

@property(nonatomic,weak)id<XDChooseAddressControllerDelegate>delegate;


@end
