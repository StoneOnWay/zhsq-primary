//
//  ZHYJError.h
//  ZHYJSDK
//
//  Created by shilei on 17/6/12.
//
//

#ifndef ZHYJError_h
#define ZHYJError_h
/* ZHYJSDK的错误定义 */
typedef NS_ENUM(NSInteger, ZHYJErrorCode) {
    /**
     *  接口 错误码(SDK本地错误)
     */
    ZHYJ_SDK_NOT_INIT = 1,                              //SDK未初始化
    ZHYJ_SDK_USERNAME_OR_PASSWORD_EMPTY = 2,            //用户名或密码为空
    ZHYJ_SDK_USERNAME_FORMAT_ERROR = 3,                 //用户格式错误
    ZHYJ_SDK_HTTPS_ERROR = 4,                           //连接服务器失败或者超时
    ZHYJ_SDK_DEVICE_NO_CALL = 5,                        //设备无呼叫
    ZHYJ_SDK_DEVICE_CALL_BUSY = 6,                      //设备通话中
    ZHYJ_SDK_STOP_VOICE_TALK_FAILED = 7,                //挂断时，关闭对讲失败
    ZHYJ_SDK_IS_NOT_CALLING_INFO = 8,                   //接听接口入参，ZHYJCallStatus不是呼叫消息
    ZHYJ_SDK_NOT_LOGIN = 9,                             //未登录
    ZHYJ_SDK_SERVER_DATA_ERROR = 10,                    //服务器返回数据错误
    ZHYJ_SDK_VOICE_TALK_STOP = 11,                      //通话已终止
    ZHYJ_SDK_THIRD_DATA_ERROR = 12                      //其他数据错误
};

#endif /* ZHYJError_h */
