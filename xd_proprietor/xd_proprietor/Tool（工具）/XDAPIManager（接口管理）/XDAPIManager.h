//
//  XDAPIManager.h
//  XＤ
//
//  Created by zc on 17/5/4.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CURRENT_IP_KEY @"currentIpKey"
#define CUR_PROJECT @"curProject"
#define BASE_NAME @"baseName"
#define K_BASE_URL [XDAPIManager sharedManager].myBaseUrl

//正式地址
//static NSString *ID = @"http://222.240.16.134:8081/xiandao";
//static NSString *ID = @"http://134.175.27.151:8080/smartXd";
//static NSString *ID = @"http://49.4.66.251:8081/smart";
////static NSString *ID = @"http://192.168.1.20:69";

static NSString *iscID = @"http://10.10.222.100:80/artemis"; // ISC
//static NSString *ID = @"http://49.4.66.251:8081/smart";
//static NSString *ID = @"http://172.19.13.118:8080/smartxd"; // 本地
//static NSString *ID = @"http://10.10.222.112:9082/smartxd"; // 测试服务器(内网）
static NSString *ID = @"http://222.240.37.83:9082/smartxd"; // 测试服务器(外网）
static NSString *distributionID = @"http://dev.chanfine.com:9082/smartxd"; // 正式服务器
static NSString *jinyangID = @"http://dev.chanfine.com:9082/smartjy"; // 正式服务器（金阳府）
static NSString *hikID = @"https://api2.hik-cloud.com"; //  hik
static NSString *defaultID = @"http://dev.chanfine.com:9082";

//static NSString *ID = @"http://192.168.1.7:8080/";

//测试地址
//static NSString *ID = @"http://121.199.41.147/xiandao";

//周涛id
//static NSString *ID = @"http://192.168.0.44:8081/xiandao";

//李瑶id
//static NSString *ID = @"http://192.168.0.75:10086/xiandao";

//贺刚id
//static NSString *ID = @"http://192.168.0.38:8080";


@interface XDAPIManager : NSObject

@property (nonatomic, copy) NSString *myBaseUrl;

+ (instancetype)sharedManager;

/** 1--
 *  发送短信验证码
 */
- (void)requestsendCfSmsExtWithParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;


/** 2--
 *  登录
 */
- (void)requestLoginWithParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/** 3--
 *  提交首页我的报单
 */
- (void)requestCommitMyWarrantyParameters:(id)parameters constructingBodyWithBlock:(NSArray *)imageDatas CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/** 4--
 *  提交首页我的投诉
 */
- (void)requestCommitMyComplainParameters:(id)parameters constructingBodyWithBlock:(NSArray *)imageDatas CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/** 5--
 *  获取房屋信息的地址
 */
- (void)requestHouseOfAddressWithParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/** 5.1--
 *  扫码之后获取地址名称
 */
- (void)requestScanWithParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/** 6--
 *  获取维修类型
 */

- (void)requesWarrantyOfTypeWithParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/** 7--
 *   我的报修工单列表
 */
- (void)requestWorkOrderListParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/** 8--
 *  我的报修工单列表详情
 */
- (void)requestWorkOrderDetailListParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/** 9--
 *  报修详情进度接口
 */
- (void)requestMyWarrantyOfProgressParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/** 10--
 *  获取联系人
 */
- (void)requestLinkManParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;


/** 11-
 *  是否接受费用
 */
- (void)requestWarrantyAcceptFee:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;



/** 12-
 *  客户确认
 */
- (void)requestWarrantyCustomerEnSure:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/** 13-
 *  报修评价
 */
- (void)requestWarrantyEvalute:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;



/** 14-
 *  我的投诉工单列表
 */
- (void)requestComplainListWithParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;




/** 15-
 *  我的投诉工单详情
 */
- (void)requestComplainOfDetailsWithParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;


/** 16-
 *  我的抽奖信息
 */
- (void)requestChouJiangInfoWithParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/** 17-
 *  我的抽奖详情
 */
- (void)requestChouJiangDetailWithParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/** 18-
 *  投诉详情是否接受方案
 */
- (void)requestWouldAcceptProjectWithParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/** 19-
 *  投诉进度
 */
- (void)requestComplainProcessWithParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/** 20-
 *  是否满意
 */
- (void)requestIsManYiEvalute:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/** 21-
 *  报修评价
 */
- (void)requestComplainEvalute:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/** 22-
 *  是否接受整改措施
 */
- (void)requestIsMeaSure:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;


/**
 *  新建地址
 */
- (void)requestCreateCommonAddressParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  创建新联系人
 */
- (void)requestCreateNewLinkManParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;




/**
 *  查询业主属于哪个楼盘
 */
- (void)requestQueryProjectsParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  查询业主房屋楼栋
 */
- (void)requestQueryBuildingsParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  查询业主单元房号
 */
- (void)requesQueryCellsParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  查询房屋
 */
- (void)requestQueryRoomsParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;


/**
 *  承接查验
 */
- (void)requestChengJieChaYanParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;


/**
 *  公告更更新阅读数
 */
- (void)requestUpDateReadNumParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  公告更更新点赞数
 */
- (void)requestUpDateZanNumParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;


/**
 *  工单刷选中请求工单类别
 */
- (void)requestWarrantyScreenTypeParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  投诉刷选中请求工单类别
 */
- (void)requestComplainScreenTypeParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  获取服务器时间（或者加一个小时）
 */
- (void)requestGetNowDateParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;


/**
 *  邻里发帖
 */
- (void)requestPostMessageParameters:(id)parameters constructingBodyWithBlock:(NSArray *)imageDatas CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande ;

/**
 *   支付列表的获取
 */
- (void)requestPayForListParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;


/**
 *   支付详细参数 获取流水号
 */
- (void)requestPayForDetailDateParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;


/**
 *  购物列表
 */
- (void)requestShoppingList:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;
/**
 *  分类列表
 */
- (void)requestTypeList:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;
/**
 *  商品列表
 */
- (void)requestGoodsList:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  加入购物车
 */
- (void)requestAddGoods:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  我的购物车
 */
- (void)requestMyShopCart:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  更新购物车数量
 */
- (void)requestUpDateCartNum:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  删除某个商品
 */
- (void)requestCartDelete:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  创建订单
 */
- (void)requestCreateOrder:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  获取订单列表
 */
- (void)requestGetMyOrder:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  更改订单状态  取消订单
 */
- (void)requestUpdateOrderStatus:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  更新收货地址
 */
- (void)requestUpdateCollectOrderAddress:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  获取评论数据
 */
- (void)requestGetCommentData:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  添加评论
 */
- (void)requestAddCommentData:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  微信支付
 */
- (void)requestWeixinPayParam:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/*
 *  便民电话接口
 */
- (void)requestGetAllPhoneWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject ,NSError*error))completionHande;

// 关注帖子  /api/theme/follow.action
- (void)requestFollowWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject ,NSError*error))completionHande;
// 取消关注 /api/theme/cancelfollow.action
- (void)requestcancelFollowWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject ,NSError*error))completionHande;

// 获取我发布的帖子 /api/theme/getAllThemmByOwnerid.action
- (void)requestgetAllThemmByOwneridWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject ,NSError*error))completionHande;

// 获取我关注的帖子 /api/theme/getMyFollow.action
- (void)requestGetFollowThemesByOwneridWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject ,NSError*error))completionHande;

// 获取所有帖子 /api/theme/getAllTheme.action
- (void)requestgetAllThemeWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject ,NSError*error))completionHande;

// 查看帖子详情 /api/theme/getByThemeId.action
- (void)requestgetByThemeIWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject ,NSError*error))completionHande;

// 帖子评论  /api/theme/comment.action
- (void)requestCommentWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject ,NSError*error))completionHande;

// 帖子点赞  /api/theme/upTheme.action
- (void)requestupThemeWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject ,NSError*error))completionHande;

// 发布帖子  /api/theme/addTheme.action
- (void)requestaddThemeWithParameters:(id)parameters constructingBodyWithBlock:(NSArray *)imageDatas CompletionHandle:(void (^)(id responseObject ,NSError*error))completionHande;

/**
 *  添加车辆
 */
- (void)requestAddCarParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  修改车辆
 */
- (void)requestRecomposeCarParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  删除车辆
 */
- (void)requestDeleteCarParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  锁车和解锁车辆 1锁车  2解锁
 */
- (void)requestUnlockCarParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  获取开锁二维码地址
 */
- (void)requestCodeImageUrlParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  获取某个用户名下所有车辆
 */
- (void)requestGetAllCarsListParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  获取布控车辆
 */
- (void)requestGetAlarmCarsListParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  取消车辆布控
 */
- (void)requestDeleteAlarmCarParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  车辆布控
 */
- (void)requestAddAlarmCarParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  车辆出入记录
 */
- (void)requestCarOutRecordParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  访客预约列表
 */
- (void)requestVisitListParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  访客来访记录列表
 */
- (void)requestVisitHistoryListParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  访客邀约新增
 */
- (void)requestNewVisitParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  查询人员列表
 */
- (void)requestPersonListParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  查询卡片列表
 */
- (void)requestCardListParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  根据证件号码查询人员信息
 */
- (void)requestPersonInfoWithCertificateParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  根据手机号码查询人员信息
 */
- (void)requestPersonInfoWithPhoneNumParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  批量开卡
 */
- (void)requestBindCardsParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  查询停车账单
 */
- (void)requestParkPaymentParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  账单确认支付
 */
- (void)requestPayReceiptParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  门禁开锁二维码
 */
- (void)requestUnlockQrCodeParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  访客二维码生成
 */
- (void)requestVisitorQrCodeParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  人脸下发
 */
- (void)requestFaceUploadParameters:(id)parameters constructingBodyWithBlock:(NSString *)imagePath name:(NSString *)name CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  公告
 */
- (void)requestFindnotice:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  编辑个人信息
 */
- (void)requestEditPersonalInformationParameters:(id)parameters constructingBodyWithBlock:(NSArray *)imageDatas CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  查询业主信息
 */
- (void)requestOwnerInfoParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  更新业主信息缓存
 */
- (void)updateOwnerInfoParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  获取我的车辆列表
 */
-(void)requestMyVehicleListWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject, NSError *error))completionHande;

/**
 *  添加我的车辆
 */
- (void)requestAddMyVehicleWithParameters:(id)parameters constructingBodyWithBlock:(NSArray *)imageDatas CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  修改单个车辆信息
 */
- (void)requestUpdateMyVehicleWithParameters:(id)parameters constructingBodyWithBlock:(NSArray *)imageDatas CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  删除单个车辆
 */
-(void)requesDeleteMyVehicleWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject, NSError *error))completionHande;

/**
 *  轮播与热点查询
 */
- (void)requestFindHotAndBanner:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

// 删除帖子  /api/theme/delByThemeId.action
- (void)requestDeleteThemeWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject,NSError*error))completionHande;

/**
 *  全部家庭成员信息查询
 */
-(void)requestGetOwnerFamilyInfosWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject, NSError *error))completionHande;

/**
 *  查询车辆包租信息
 */
- (void)requestGetCarCharterInfoWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject, NSError *error))completionHande;

/**
 *  车辆充值
 */
- (void)requestCarCharterWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject, NSError *error))completionHande;

/**
 *  获取停车库列表
 */
- (void)requestGetParkListWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject, NSError *error))completionHande;

/**
 *  第三方绑定手机号
 */
- (void)requestLinkPhoneNoWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject, NSError *error))completionHande;

/**
 *  查询第三方登录是否绑定手机号
 */
- (void)requestCheckIsBindPhoneNoWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject, NSError *error))completionHande;

/**
 *  业主绑定第三方
 */
- (void)requestLinkThirdPartyAccountWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject, NSError *error))completionHande;

/**
 *  第三方解除绑定
 */
- (void)requestDeleteThirdPartyAccountWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject, NSError *error))completionHande;

/**
 *  根据动态id获取公告详情
 */
- (void)requestSelectNoticesParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;

/**
 *  公告取消点赞
 */
- (void)requestDeleteNoticesUpParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande;
@end
