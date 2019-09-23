//
//  XDWarrantyDetailFootView.h
//  XD业主
//
//  Created by zc on 2017/6/22.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDWarrantyDetailFootView : UITableViewHeaderFooterView

/*********接受费用**********/
@property (weak, nonatomic) IBOutlet UIButton *acceptPriceBtn;

@property (weak, nonatomic) IBOutlet UIButton *refusePriceBtn;


/**********评价*********/
@property (weak, nonatomic) IBOutlet UIButton *evaluateBtn;



@property(nonatomic, copy)void (^warrantyDetailBtnClicked)(NSInteger index);

+ (instancetype)footerViewWithTableView:(UITableView *)tableView withType:(NSString *)type;


@end
