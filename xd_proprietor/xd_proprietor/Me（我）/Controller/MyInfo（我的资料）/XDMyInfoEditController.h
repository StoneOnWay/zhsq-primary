//
//  XDMyInfoEditController.h
//  XD业主
//
//  Created by zc on 2017/6/28.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDMyInfoEditController;
@protocol XDMyInfoEditControllerDelegate <NSObject>
@optional
-(void)XDMyInfoEditControllerWithUsualName:(NSString *)usualName withUsualAddress:(NSString *)usualAddress withUsualContact:(NSString *)usualContact withMyHeadImage:(UIImage *)headImage;

@end

@interface XDMyInfoEditController : UIViewController

@property(nonatomic,weak)id<XDMyInfoEditControllerDelegate>delegate;

@property(nonatomic ,strong)UIImage *headImage;

@property(nonatomic,copy)NSString *textName;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

//名字输入框
@property (weak, nonatomic) IBOutlet UITextField *nameText;
//地址
@property (weak, nonatomic) IBOutlet UITextField *addressTextF;
//联系人
@property (weak, nonatomic) IBOutlet UITextField *contactTextF;

@end
