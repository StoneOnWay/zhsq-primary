//
//  XDVisitModel.h
//  XD业主
//
//  Created by zc on 2017/8/10.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDVisitModel : NSObject

@property (copy , nonatomic)NSString *state;//状态

@property (copy , nonatomic)NSString *employnum;//

@property (copy , nonatomic)NSString *visitorname;//访客姓名

@property (copy , nonatomic)NSString *ownerid;//用户id

@property (copy , nonatomic)NSString *picpath;//图片路径

@property (copy , nonatomic)NSString *effectivetime;//有效时间

@property (copy , nonatomic)NSString *openid;//二维码数据

@property (copy , nonatomic)NSString *effectiveno;//失效？

@property (copy , nonatomic)NSString *imei;//

@property (copy , nonatomic)NSString *iseffective;//是否有效

@property (copy , nonatomic)NSString *maketime;//制作时间

@property (copy , nonatomic)NSString *openflag;//

@property (copy , nonatomic)NSString *physicakey;//

@property (copy , nonatomic)NSString *deadline;//


@property (nonatomic, copy) NSString *visitorName;
@property (nonatomic, copy) NSString *effectTime;
@property (nonatomic, copy) NSString *expireTime;
@property (nonatomic, assign) int effectNum;
@property (nonatomic, copy) NSString *codeUrlStr;

@end
