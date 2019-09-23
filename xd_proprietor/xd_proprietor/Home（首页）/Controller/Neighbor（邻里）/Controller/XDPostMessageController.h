//
//  XDPostMessageController.h
//  XD业主
//
//  Created by zc on 2017/8/11.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDPostMessageController : UIViewController

@property(nonatomic,strong)UIWebView *webView;

@property(nonatomic,copy)void (^refreshWebview)();
@end
