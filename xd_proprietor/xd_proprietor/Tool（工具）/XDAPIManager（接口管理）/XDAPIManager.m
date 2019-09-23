//
//  XDAPIManager.m
//  XＤ
//
//  Created by zc on 17/5/4.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDAPIManager.h"
#import "XDHTTPManager.h"

@implementation XDAPIManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static XDAPIManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        NSDictionary *curPro = [[NSUserDefaults standardUserDefaults] valueForKey:CUR_PROJECT];
        if (!curPro) {
            curPro = @{
                       @"ip": @"http://dev.chanfine.com:9082/smartxd",
                       @"projectName": @"云西府"
                       };
        }
        manager.myBaseUrl = curPro[@"ip"];
    });
//    manager.myBaseUrl = @"http://222.240.37.83:9082/smartjy";
    return manager;
}

#pragma mark - ISC
/**
 *  获取布控车辆
 */
- (void)requestGetAlarmCarsListParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/isc/alarmCar/page.action",K_BASE_URL];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  车辆布控
 */
- (void)requestAddAlarmCarParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/isc/alarmCar/addition.action",K_BASE_URL];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  取消车辆布控
 */
- (void)requestDeleteAlarmCarParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/isc/alarmCar/deletion.action",K_BASE_URL];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  车辆出入记录
 */
- (void)requestCarOutRecordParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/isc/crossRecords/page.action",K_BASE_URL];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  获取某个用户名下所有车辆
 */
- (void)requestGetAllCarsListParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/resource/v1/vehicle/advance/vehicleList", iscID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  访客预约列表
 */
- (void)requestVisitListParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/visitor/v1/appointment/records",iscID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  访客邀约新增
 */
- (void)requestNewVisitParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/visitor/v1/appointment",iscID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
    
}

/**
 *  查询人员列表
 */
- (void)requestPersonListParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/resource/v1/person/advance/personList",iscID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  查询卡片列表
 */
- (void)requestCardListParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/irds/v1/card/advance/cardList",iscID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  根据证件号码查询人员信息
 */
- (void)requestPersonInfoWithCertificateParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/resource/v1/person/certificateNo/personInfo",iscID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  根据手机号码查询人员信息
 */
- (void)requestPersonInfoWithPhoneNumParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/resource/v1/person/phoneNo/personInfo", iscID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  批量开卡
 */
- (void)requestBindCardsParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/cis/v1/card/bindings",iscID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  查询停车账单
 */
- (void)requestParkPaymentParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/isc/pay/quickPreBill.action",K_BASE_URL];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  账单确认支付
 */
- (void)requestPayReceiptParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/isc/pay/receipt.action",K_BASE_URL];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  门禁开锁二维码
 */
- (void)requestUnlockQrCodeParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/v1/community/access/visitors/actions/getQrcode",hikID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

#pragma mark --
/** 5.1--
 *  扫码之后获取地址名称
 */
- (void)requestScanWithParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/patrol/queryPatrolAddressByCode.action",ID];
    [[XDHTTPManager sharedManager] GET:path parameters:parameters completionHandle:completionHande];
}

/** 
 *   支付列表的获取
 */
- (void)requestPayForListParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande
{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/api/pay/query.action",ID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *   支付详细参数 获取流水号
 */
- (void)requestPayForDetailDateParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande
{
    
    
    NSString *path = [NSString stringWithFormat:@"%@/api/pay/createpayinfo.action",ID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}


/**
 *  ************商城************
 */

/**
 *  购物列表
 */
- (void)requestShoppingList:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/shop/getShopHomeList.action",ID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  分类列表
 */
- (void)requestTypeList:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/shop/getHomeType.action",ID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}
/**
 *  商品列表
 */
- (void)requestGoodsList:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/shop/getTypeGood.action",ID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  加入购物车
 */
- (void)requestAddGoods:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/shop/addGoods.action",ID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}
/**
 *  我的购物车
 */
- (void)requestMyShopCart:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/shop/myShopCar.action",ID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}
/**
 *  更新购物车数量
 */
- (void)requestUpDateCartNum:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/shop/updateCartNumber.action",ID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  删除某个商品
 */
- (void)requestCartDelete:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/shop/delCartDetail.action",ID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  创建订单
 */
- (void)requestCreateOrder:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/shop/createOrder.action",ID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  获取订单列表
 */
- (void)requestGetMyOrder:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/shop/getMyOders.action",ID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}
/**
 *  更改订单状态  取消订单
 */
- (void)requestUpdateOrderStatus:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/shop/updateOrderStatus.action",ID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  更新收货地址
 */
- (void)requestUpdateCollectOrderAddress:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/shop/updateAddress.action",ID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  获取评论数据
 */
- (void)requestGetCommentData:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/shop/getCommentByGoodsId.action",ID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  添加评论
 */
- (void)requestAddCommentData:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/shop/addComment.action",ID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  微信支付
 */
- (void)requestWeixinPayParam:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/wxpay/getPayParam.action",ID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  添加车辆
 */
- (void)requestAddCarParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/car/addCar.action",ID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
    
}

/**
 *  修改车辆
 */
- (void)requestRecomposeCarParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/car/updateCar.action", ID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  删除车辆
 */
- (void)requestDeleteCarParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/car/deleteCar.action",ID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
    
}

/**
 *  锁车和解锁车辆 1锁车  2解锁
 */
- (void)requestUnlockCarParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/car/unlockCar.action",ID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
    
}

/**
 *  获取开锁二维码地址
 */
- (void)requestCodeImageUrlParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/authority/ownercode.action",ID];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

#pragma mark -
/**
 *  访客二维码生成
 */
- (void)requestVisitorQrCodeParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/getHIKVisionVisitorQRcode.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  人脸下发
 */
- (void)requestFaceUploadParameters:(id)parameters constructingBodyWithBlock:(NSString *)imagePath name:(NSString *)name CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/HIKVisionFaceDistribution.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters constructingBodyWithBlock:imagePath name:name completionHandle:completionHande];
}

/**
 *  访客来访记录列表
 */
- (void)requestVisitHistoryListParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/getVisitorRecord.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 23-
 *  公告
 */
- (void)requestFindnotice:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/findnotices.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  轮播与热点查询
 */
- (void)requestFindHotAndBanner:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/getTurnsAndHottopics.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  编辑个人信息
 */
- (void)requestEditPersonalInformationParameters:(id)parameters constructingBodyWithBlock:(NSArray *)imageDatas CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/editPersonalInformation.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters constructingBodyWithBlock:imageDatas completionHandle:completionHande];
}

/** 3--
 *  提交我的报单
 */
- (void)requestCommitMyWarrantyParameters:(id)parameters constructingBodyWithBlock:(NSArray *)imageDatas CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande{
    NSString *path = [NSString stringWithFormat:@"%@/api/job/add.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters constructingBodyWithBlock:imageDatas completionHandle:completionHande];
}

/** 4--
 *  提交我的投诉
 */
- (void)requestCommitMyComplainParameters:(id)parameters constructingBodyWithBlock:(NSArray *)imageDatas CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/complains/complainInfoCommit.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters constructingBodyWithBlock:imageDatas completionHandle:completionHande];
}

/** 5--
 *  获取房屋信息的地址
 */
- (void)requestHouseOfAddressWithParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/getRepairsAddress.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] GET:path parameters:parameters completionHandle:completionHande];
}

/** 6--
 *  获取维修类型
 */
- (void)requesWarrantyOfTypeWithParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/getRepairsType.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] GET:path parameters:parameters completionHandle:completionHande];
}

/**
 *  获取服务器时间（或者加一个小时）
 */
- (void)requestGetNowDateParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/ApiDate/nowDateAddHour.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  公告更更新阅读数
 */
- (void)requestUpDateReadNumParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    
    NSString *path = [NSString stringWithFormat:@"%@/api/readNumber.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  根据动态id获取公告详情
 */
- (void)requestSelectNoticesParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/selectNotices.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] GET:path parameters:parameters completionHandle:completionHande];
}

/**
 *  公告更更新点赞数
 */
- (void)requestUpDateZanNumParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/NoticesUp.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] GET:path parameters:parameters completionHandle:completionHande];
}

/**
 *  公告取消点赞
 */
- (void)requestDeleteNoticesUpParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/deleteNoticesUp.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] GET:path parameters:parameters completionHandle:completionHande];
}

/**
 *  工单刷选中请求工单类别
 */
- (void)requestWarrantyScreenTypeParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/employee/queryJobtypes.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  投诉刷选中请求工单类别
 */
- (void)requestComplainScreenTypeParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/getComplainType.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 7--
 *   我的报修工单列表
 */
- (void)requestWorkOrderListParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande
{
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/queryJobList.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 8--
 *  我的报修工单列表详情
 */
- (void)requestWorkOrderDetailListParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande; {
    NSString *path = [NSString stringWithFormat:@"%@/api/job/queryJobDetail.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 9--
 *  报修详情进度接口
 */
- (void)requestMyWarrantyOfProgressParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/job/queryJobDetailProcessInfo.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 10--
 *  获取联系人
 */
- (void)requestLinkManParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/getLinkmanList.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 11-
 *  是否接受费用
 */
- (void)requestWarrantyAcceptFee:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/acceptPrice.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 12-
 *  客户确认
 */
- (void)requestWarrantyCustomerEnSure:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/confirmWorkOrderFinish.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 13-
 *  报修评价
 */
- (void)requestWarrantyEvalute:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/commentWorkOrder.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 14-
 *  我的投诉列表
 */
- (void)requestComplainListWithParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/complains/queryMyComplainList.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 15-
 *  我的投诉工单详情
 */
- (void)requestComplainOfDetailsWithParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/complains/getComplainDetail.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 16-
 *  我的抽奖信息
 */
- (void)requestChouJiangInfoWithParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/raffle/selectItemByownerId.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 17-
 *  我的抽奖详情
 */
- (void)requestChouJiangDetailWithParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/raffle/getRaffleLottery.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 18-
 *  投诉详情是否接受方案
 */
- (void)requestWouldAcceptProjectWithParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/complains/customIsAcceptSolutionComplain.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 19-
 *  投诉进度
 */
- (void)requestComplainProcessWithParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/complains/queryMyComplainPlan.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 20-
 *  是否满意
 */
- (void)requestIsManYiEvalute:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/complains/customIsSatisfactionSolutionComplain.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 21-
 *  投诉评价
 */
- (void)requestComplainEvalute:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/complains/customCommentComplain.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 22-
 *  是否接受整改措施
 */
- (void)requestIsMeaSure:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/complains/customAcceptMeasureComplain.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 24-
 *  新建地址
 */
- (void)requestCreateCommonAddressParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/createCommonAddress.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 25-
 *  创建新联系人
 */
- (void)requestCreateNewLinkManParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/createLinkman.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 26-
 *  查询业主属于哪个楼盘
 */
- (void)requestQueryProjectsParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/queryProjects.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 27-
 *  查询业主房屋楼栋
 */
- (void)requestQueryBuildingsParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/queryBuildings.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 28-
 *  查询业主单元房号
 */
- (void)requesQueryCellsParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/queryCells.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/** 29-
 *  查询房屋
 */
- (void)requestQueryRoomsParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/queryRooms.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  承接查验
 */
- (void)requestChengJieChaYanParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/message/getMessageList.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/*
 *  便民电话接口   projectId
 */
- (void)requestGetAllPhoneWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject ,NSError*error))completionHande{
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/getAllPhone.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  查询业主信息
 */
- (void)requestOwnerInfoParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/getOwnerInfo.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] GET:path parameters:parameters completionHandle:completionHande];
}

/**
 *  更新业主信息缓存
 */
- (void)updateOwnerInfoParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/checkOwner.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

#pragma mark - discover
// 关注帖子
- (void)requestFollowWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject ,NSError*error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/theme/follow.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

// 取消关注 /api/theme/cancelfollow.action
- (void)requestcancelFollowWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject ,NSError*error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/theme/cancelfollow.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

// 获取我发布的帖子 /api/theme/getAllThemmByOwnerid.action
- (void)requestgetAllThemmByOwneridWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject ,NSError*error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/theme/getAllThemmByOwnerid.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

// 获取我关注的帖子 /api/theme/getMyFollow.action
- (void)requestGetFollowThemesByOwneridWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject ,NSError*error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/theme/getMyFollow.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

// 获取所有帖子 /api/theme/getAllTheme.action
- (void)requestgetAllThemeWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject ,NSError*error))completionHande{
    NSString *path = [NSString stringWithFormat:@"%@/api/theme/getAllTheme.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

// 查看帖子详情 /api/theme/getByThemeId.action
- (void)requestgetByThemeIWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject ,NSError*error))completionHande{
    NSString *path = [NSString stringWithFormat:@"%@/api/theme/getByThemeId.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

// 帖子评论  /api/theme/comment.action
- (void)requestCommentWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject ,NSError*error))completionHande{
    NSString *path = [NSString stringWithFormat:@"%@/api/theme/comment.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

// 帖子点赞  /api/theme/upTheme.action
- (void)requestupThemeWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject,NSError*error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/theme/upTheme.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

// 删除帖子  /api/theme/delByThemeId.action
- (void)requestDeleteThemeWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject,NSError*error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/theme/delByThemeId.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  邻里发帖
 */
- (void)requestPostMessageParameters:(id)parameters constructingBodyWithBlock:(NSArray *)imageDatas CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/postmanagement/addpost.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters constructingBodyWithBlock:imageDatas completionHandle:completionHande];
}

// 发布帖子
- (void)requestaddThemeWithParameters:(id)parameters constructingBodyWithBlock:(NSArray *)imageDatas CompletionHandle:(void (^)(id responseObject, NSError *error))completionHande{
    NSString *path = [NSString stringWithFormat:@"%@/api/theme/addTheme.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters constructingBodyWithBlock:imageDatas completionHandle:completionHande];
}

#pragma mark - login
/**
 *  发送短信验证码
 */
- (void)requestsendCfSmsExtWithParameters:(id)parameters CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    //    //这个是测试不发送短信
    //    NSString *path = [NSString stringWithFormat:@"%@/api/smsSend.action",ID];
    
    NSString *path = [NSString stringWithFormat:@"%@/api/getLoginCode.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  登录
 */
-(void)requestLoginWithParameters:(id)parameters CompletionHandle:(void (^)(id, NSError *))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/loginOwner.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] GET:path parameters:parameters completionHandle:completionHande];
}

/**
 *  获取我的车辆列表
 */
-(void)requestMyVehicleListWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/vehicleinfo/query.action",self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  添加我的车辆
 */
- (void)requestAddMyVehicleWithParameters:(id)parameters constructingBodyWithBlock:(NSArray *)imageDatas CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/vehicleinfo/add.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters constructingBodyWithBlock:imageDatas completionHandle:completionHande];
}

/**
 *  修改单个车辆信息
 */
- (void)requestUpdateMyVehicleWithParameters:(id)parameters constructingBodyWithBlock:(NSArray *)imageDatas CompletionHandle:(void(^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/vehicleinfo/update.action", self.myBaseUrl];
//    NSString *path = @"http://172.19.13.170:8080/smartxd/api/vehicleinfo/update.action";
    [[XDHTTPManager sharedManager] POST:path parameters:parameters constructingBodyWithBlock:imageDatas completionHandle:completionHande];
}

/**
 *  删除单个车辆
 */
- (void)requesDeleteMyVehicleWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/vehicleinfo/delete.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  全部家庭成员信息查询
 */
- (void)requestGetOwnerFamilyInfosWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/owner/getOwnerFamilyInfos.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] GET:path parameters:parameters completionHandle:completionHande];
}

/**
 *  查询车辆包租信息
 */
- (void)requestGetCarCharterInfoWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/isc/car/charge/page.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  车辆充值
 */
- (void)requestCarCharterWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/isc/car/charge.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  获取停车库列表
 */
- (void)requestGetParkListWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/isc/park/parklist.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] POST:path parameters:parameters completionHandle:completionHande];
}

/**
 *  第三方绑定手机号
 */
- (void)requestLinkPhoneNoWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/linkPhoneNo.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] GET:path parameters:parameters completionHandle:completionHande];
}

/**
 *  查询第三方登录是否绑定手机号
 */
- (void)requestCheckIsBindPhoneNoWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/queryPhoneNo.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] GET:path parameters:parameters completionHandle:completionHande];
}

/**
 *  业主绑定第三方
 */
- (void)requestLinkThirdPartyAccountWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/linkThirdPartyAccount.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] GET:path parameters:parameters completionHandle:completionHande];
}

/**
 *  第三方解除绑定
 */
- (void)requestDeleteThirdPartyAccountWithParameters:(id)parameters CompletionHandle:(void (^)(id responseObject, NSError *error))completionHande {
    NSString *path = [NSString stringWithFormat:@"%@/api/deleteThirdPartyAccount.action", self.myBaseUrl];
    [[XDHTTPManager sharedManager] GET:path parameters:parameters completionHandle:completionHande];
}


@end
