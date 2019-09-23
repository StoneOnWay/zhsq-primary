//
//  XDVisitDetailController.h
//  XD业主
//
//  Created by zc on 2017/8/10.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDVisitModel.h"

@interface XDVisitDetailController : UIViewController

@property(nonatomic,strong)XDVisitModel *visitModel;

@property(nonatomic,assign)BOOL isAddNew;
@end
