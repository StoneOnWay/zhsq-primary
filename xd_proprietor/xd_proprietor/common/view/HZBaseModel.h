//
//  HZBaseModel.h
//  Pods
//
//  Created by mason on 2017/7/31.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HZBaseType) {
    /** < 纯文本*/
    HZBaseTypeText,
    /** < 图片滑动*/
    HZBaseTypeImage,
    /** < 文本输入*/
    HZBaseTypeTextView,
    /** < TextField文本输入*/
    HZBaseTypeTextField,
    /** < 点击弹选择框*/
    HZBaseTypeTextWithArrow,
    /** < 右边带拨打电话和发送短信*/
    HZBaseTypeOperation,
    /** < 图片添加*/
    HZBaseTypeAddImage,
    /** < 单选框*/
    HZBaseTypeSingle,
    /** < 单选展开*/
    HZBaseTypeSingleExpand,
    /** < 文本，含按钮*/
    HZBaseTypeTextWithButton,
    /** < 标签*/
    HZBaseTypeTag,
    /** < 评价*/
    HZBaseTypeEvaluate
};

@interface HZBaseModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subTitle;
@property (strong, nonatomic) id value;
/** 图片数组 */
@property (strong, nonatomic) NSArray *imageArray;

@property (assign, nonatomic) HZBaseType baseType;

/** 颜色，主要在筛选控件中会用到 */
@property (strong, nonatomic) UIColor *valueTextColor;

@end











