//
//  XDComplainDetailNetModel.h
//  XD业主
//
//  Created by zc on 2017/6/28.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDUserinfoNetModel.h"

typedef NS_ENUM(NSInteger, XDComplainStatusStatus) {
    /** 未受理 */
    XDComplainStatusUnAccept = 1,
    /** 已受理 */
    XDComplainStatusAccept = 2,
    /** 已核实，分发投诉 */
    XDComplainStatusVerify = 3,
    /** 到场处理 */
    XDComplainStatusAttendanceHandle = 4,
    /** 待业主确认投诉确认方案 */
    XDComplainStatusConfirmProject = 5,
    /** 用户不接受整改措施，无上级领导处理，关闭投诉 */
    XDComplainStatusUnAcceptRectificationMeasuresClose = 8,
    /** 解决方案实施中 */
    XDComplainStatusProject = 9,
    /** 员工完成解决方案 */
    XDComplainStatusEmployeeCompleteProject = 10,
    /** 整改措施已完成 */
    XDComplainStatusRectificationMeasuresComplete = 11,
    /** 整改重派 */
    XDComplainStatusRectificationReSendOrders = 12,
    /** 投诉处理满意 */
    XDComplainStatusSatisfaction = 13,
    /** 投诉处理不满意 */
    XDComplainStatusUnSatisfaction = 14,
    /** 投诉处理已评价 */
    XDComplainStatusEvaluate = 15,
    /** 用户不满意需整改 */
    XDComplainStatusUnSatisfactionRectification = 16,
    /** 整改措施问询中 */
    XDComplainStatusRectificationConsult = 17,
    /** 用户不接受整改措施 */
    XDComplainStatusAcceptRectificationMeasures = 18,
    /** 用户不接受整改措施 */
    XDComplainStatusUnAcceptRectificationMeasures = 19,
    /** 客服已回访 */
    XDComplainStatusBackView = 20
};



@interface XDComplainDetailNetModel : NSObject

//用户信息1
@property (strong , nonatomic)XDUserinfoNetModel *UserInfo;

//*****投诉时间2
@property (copy , nonatomic)NSString *complainDateTime;


//现场查询情况3
@property (copy , nonatomic)NSString *checkContent;


/***评论***/
//评论的内容4
@property (copy , nonatomic)NSString *commentContent;
//评论的星星等级5
@property (copy , nonatomic)NSString *commentLevel;
/***评论***/



//投诉id6
@property (copy , nonatomic)NSString *complainId;
//投诉图片地址7
@property (strong , nonatomic)NSArray *complainImageUrlList;
//投诉类型8
@property (copy , nonatomic)NSString *complainType;
////投诉状态 9
@property (copy , nonatomic)NSString *complainStatus;
//投诉描述10
@property (copy , nonatomic)NSString *complainDes;



////客服接单时间11
@property (copy , nonatomic)NSString *csAcceptTime;
////客服处理人
@property (copy , nonatomic)NSString *csAcceptor;
//部门主管13
@property (strong , nonatomic)NSArray *deparmentLeader;



////部门处理时间14
@property (copy , nonatomic)NSString *deparmenthandertime;
////处理员工15
@property (copy , nonatomic)NSString *empHandler;




//16
@property (strong , nonatomic)NSArray *empSolutionPic;
////员工完成投诉时间17
@property (copy , nonatomic)NSString *empSolutionDate;
//18
@property (copy , nonatomic)NSString *empSolutionContent;

////主管现场照片19
@property (strong , nonatomic)NSArray *managercheckpic;
////投诉完结类型 1 正常完结 2 无上级处理完结20
@property (copy , nonatomic)NSString *finishType;
//措施内容21
@property (copy , nonatomic)NSString *measureContent;
//
@property (copy , nonatomic)NSString *measureDate;
////是否投诉完结 0未 1是
@property (copy , nonatomic)NSString *isfinish;
//23
@property (copy , nonatomic)NSString *resourcekey;
//24
@property (assign , nonatomic)NSInteger roomId;

//解决方案内容25
@property (copy , nonatomic)NSString *solutionContent;
////主管解决方案时间26
@property (copy , nonatomic)NSString *solutionDate;
//投诉用户判定是否解决27
@property (copy , nonatomic)NSString *solveType;

//用户id 28
@property (assign , nonatomic)NSInteger ownerid;

/** <##> */
@property (copy, nonatomic) NSString *complainStatusId;
/** <##> */
@property (assign, nonatomic) XDComplainStatusStatus complainStatusStatus;

@end
