//
//  SDPaymentTool.h
//  ModuleProject
//
//  Created by 李奕辰 on 2017/3/9.
//  Copyright © 2017年 Twinkle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCSingleton.h"


// WechatPayHeader
#import "WXApi.h"
#import "payRequsestHandler.h"


// UnionPayHeader


/************************************************************相关参数**************************************************************************************************/

                                 /**********************支付宝相关参数**************************************/

// NOTE: 支付宝分配给开发者的应用ID(如2014072300007148)
#define KALIAPPID @""

// NOTE: 私钥
// rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
#define KRSA2PRIVATEKEY @""

// NOTE: (非必填项)支付宝服务器主动通知商户服务器里指定的页面http路径
#define KNOTIFYURL @""


                                /**********************微信相关参数**************************************/

// NOTE: 微信APPID
#define WECHATAPPID @"wx4b10935662bcf67c"

// NOTE: 商户号
#define MERCHANTNUMBERID @"1493082972"

// NOTE: 商户密钥
#define WECHATPRIVATEKEY @"19caa17485a346778c6307ccdc70c9d6"





typedef void(^RequestSuccessAndResponseStringBlock)(NSString *string);


@interface SDPaymentTool : NSObject<WXApiDelegate>
YCSingletonH(SDPaymentTool);

@property (nonatomic,copy) RequestSuccessAndResponseStringBlock successBlock;

///**
// *  支付宝支付
// */
//- (void)AliPayWithMoney:(NSString *)money ProductName:(NSString*)name ProductDesc:(NSString*)productDesc OrderNumber:(NSString *)orderNumber;

/**
 *  微信支付
 */
- (void)WechatPayWithMoney:(NSString *)money OrderName:(NSString*)ordername OrderNumber:(NSString *)orderNumber;

/**
 *  微信支付
 */
- (void)WechatPayWithParamer:(NSDictionary *)params;

/**
 *  支付成功时候的回调
 */
-(void)paySuccessWithBlock:(RequestSuccessAndResponseStringBlock)payBlock;

@end
