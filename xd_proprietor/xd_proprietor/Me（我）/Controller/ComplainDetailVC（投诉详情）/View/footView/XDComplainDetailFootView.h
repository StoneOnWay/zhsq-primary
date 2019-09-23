//
//  XDComplainDetailFootView.h
//  XD业主
//
//  Created by zc on 2017/6/22.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDComplainDetailFootView : UITableViewHeaderFooterView

/*********接受方案的**********/
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;

@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;

/*********是否满意的**********/
@property (weak, nonatomic) IBOutlet UIButton *notGoodBtn;

@property (weak, nonatomic) IBOutlet UIButton *greatBtn;

/**********评价*********/
@property (weak, nonatomic) IBOutlet UIButton *evaluateBtn;


/**********接受整改的*********/
@property (weak, nonatomic) IBOutlet UIButton *repulseBtn;

@property (weak, nonatomic) IBOutlet UIButton *receivedBtn;


@property(nonatomic, copy)void (^compDetailBtnClicked)(NSInteger index);

+ (instancetype)footerViewWithTableView:(UITableView *)tableView withType:(NSString *)type;




@end
