//
//  XDWarrantyDetailNetDataModel.h
//  XD业主
//
//  Created by zc on 2017/6/26.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDUserinfoNetModel.h"

typedef NS_ENUM(NSInteger, XDWorkOrderStatus) {
    /** 未受理 */
    XDWorkOrderStatusUnAccept = 1,
    /** 客服接单 */
    XDWorkOrderStatusCustomerServiceTakeOrder,
    /** 客服拒绝接单 */
    XDWorkOrderStatusCustomerServiceUnTakeOrder,
    /** 客服强制关闭 */
    XDWorkOrderStatusCustomerServiceForceClose,
    /** 已派单 */
    XDWorkOrderStatusSendOrders,
    /** 拒单重派 */
    XDWorkOrderStatusUnTakeOrderReSendOrders,
    /** 强制关闭 */
    XDWorkOrderStatusForceClose,
    /** 客服介入 */
    XDWorkOrderStatusCustomerServiceIntervene,
    /** 检视工单 */
    XDWorkOrderStatusViewWorkOrder,
    /** 到场查看 */
    XDWorkOrderStatusOnSiteChecking,
    /** 接单 */
    XDWorkOrderStatusTakeOrder,
    /** 发送费用 */
    XDWorkOrderStatusSendExpenses,
    /** 拒接工单 */
    XDWorkOrderStatusUnTakeOrder,
    /** 询价 */
    XDWorkOrderStatusEnquiry,
    /** 客户接受报价 */
    XDWorkOrderStatusClientAcceptPrice,
    /** 客户不接受报价 */
    XDWorkOrderStatusClientUnAcceptPrice,
    /** 已完成 */
    XDWorkOrderStatusCompleted,
    /** 用户确认完成 */
    XDWorkOrderStatusClientConfirmCompleted,
    /** 付费完成 */
    XDWorkOrderStatusCompletionPayment,
    /** 已评价 */
    XDWorkOrderStatusEvaluate,
    /** 已回访 */
    XDWorkOrderStatusBackView,
    /** 职能主管拒绝工单 */
    XDWorkOrderStatusRegulatorUnTakeOrder,
    /** 客服委派职能主管 */
    XDWorkOrderStatusBranchLeaderTakeOrder
};

@interface XDWarrantyDetailNetDataModel : NSObject

//用户信息
@property (strong , nonatomic)XDUserinfoNetModel *UserInfo;//

//关闭的描述
@property (copy , nonatomic)NSString *closeDesc;//
//关闭的时间
@property (copy , nonatomic)NSString *closeTime;//
//关闭的类型
@property (copy , nonatomic)NSString *closeType;//

/***评论***/
//评论的内容
@property (copy , nonatomic)NSString *commentContent;//
//评论的星星等级
@property (copy , nonatomic)NSString *commentLevel;//
/***评论***/

/***业主报修内容***/
@property (copy , nonatomic)NSString *title;//
/***地址***/
@property (copy , nonatomic)NSString *address;//
//报修的图片
@property (strong , nonatomic)NSArray *piclist;//
//报修时间
@property (copy , nonatomic)NSString *repairsDateTime;//
//报修id
@property (assign , nonatomic)NSInteger repairsId;//
//报修状态
@property (copy , nonatomic)NSString *repairsStatus;//
//报修详情
@property (copy , nonatomic)NSString *repairsDes;

/***业主报修内容***/

/****员工反馈情况****/
//现场描述
@property (copy , nonatomic)NSString *liveContentDesc;//
//现场时间
@property (copy , nonatomic)NSString *livedate;//
//员工现场检视的图片
@property (strong , nonatomic)NSArray *newpiclist;//
/****员工反馈情况****/


//完成的时间
@property (copy , nonatomic)NSString *completeTime;//

@property (copy , nonatomic)NSString *customPerson;//


@property (strong , nonatomic)NSArray *empRejectedPic;//

@property (copy , nonatomic)NSString *empRejectedReason;//

@property (copy , nonatomic)NSString *empRejectedTime;//

//员工处理后的图片
@property (strong , nonatomic)NSArray *handerpiclist;//

@property (copy , nonatomic)NSString *handerresourcekey;//

/*******费用的一些参数*******/
//费用发送的时间 用于判断是否显示费用
@property (copy , nonatomic)NSString *sendFeeDate;
//人工费用
@property (assign , nonatomic)NSInteger manualCost;//
//材料费用
@property (assign , nonatomic)NSInteger materialCost;//
//总计费用
@property (assign , nonatomic)NSInteger totalCost;//
//报修类型
@property (copy , nonatomic)NSString *repairsType;//
//处理人
@property (copy , nonatomic)NSString *disposePerson;//
//处理人的描述
@property (copy , nonatomic)NSString *disposeDes;//
//处理的时间
@property (copy , nonatomic)NSString *disposeTime;//

@property (assign , nonatomic)NSInteger ownerid;//

//房间id
@property (copy , nonatomic)NSString *roomid;//

@property (copy , nonatomic)NSString *plandate;//

@property (copy , nonatomic)NSString *rejectedReason;//


@property (copy, nonatomic) NSString *repairsStatusId;
/** 工单状态<##> */
@property (assign, nonatomic) XDWorkOrderStatus workOrderStatus;

@end



















