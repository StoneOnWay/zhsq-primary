//
//  XDEvaluateCommonCell.m
//  XD业主
//
//  Created by zc on 2017/6/23.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDEvaluateCommonCell.h"
#import "XDEvaluateStarView.h"

@interface XDEvaluateCommonCell()

@property (weak, nonatomic) IBOutlet UIView *starBackView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evaluteLabelH;

@property (weak, nonatomic) IBOutlet UILabel *evaluteLabel;

@property (nonatomic, strong) XDEvaluateStarView *starView;

@end
@implementation XDEvaluateCommonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = backColor;
    [self setUpEvaluteChildView];

}

- (void)setEvaluteString:(NSString *)evaluteString {

    _evaluteString = evaluteString;
    
    self.evaluteLabel.text = evaluteString;
    CGFloat Width = kScreenWidth - WMargin * 2;
    CGSize evaluteLabelSize = [evaluteString boundingRectWithSize:CGSizeMake(Width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttributes context:nil].size;
    CGFloat evaluteLabelSizeH = evaluteLabelSize.height;
    self.evaluteLabelH.constant = evaluteLabelSizeH +1;
    
    

}


- (void)setCurrentScore:(CGFloat)currentScore {

    _currentScore = currentScore;
    
    _starView.currentScore = currentScore;
    
    
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"XDEvaluateCommonCell";
    XDEvaluateCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDEvaluateCommonCell" owner:nil options:nil]lastObject];
    }
    return cell;
    
}

- (void)setUpEvaluteChildView {

    _starView = [[XDEvaluateStarView alloc] initWithFrame:CGRectMake(0, 0, 120, 20) numberOfStars:5 isTouchable:YES index:100];
    _starView.userInteractionEnabled = NO;
    _starView.currentScore = 2;
    _starView.totalScore = 5;
    _starView.isFullStarLimited = YES;
    [self.starBackView addSubview:_starView];

}
@end
