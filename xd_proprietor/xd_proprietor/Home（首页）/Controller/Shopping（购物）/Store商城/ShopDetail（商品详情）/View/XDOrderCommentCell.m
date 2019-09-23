//
//  XDOrderCommentCell.m
//  XD业主
//
//  Created by zc on 2018/3/22.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDOrderCommentCell.h"
#import "XDEvaluateStarView.h"


@interface XDOrderCommentCell()
//除去内容的label高度 其余的和为62 
@property (nonatomic, strong) XDEvaluateStarView *starView;
@property (weak, nonatomic) IBOutlet UIView *starBackView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstriant;
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;

@end

@implementation XDOrderCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.moreLabel.layer.borderColor = [RGB(201, 170, 103) CGColor];
    self.moreLabel.layer.cornerRadius = 5;
    self.moreLabel.layer.borderWidth = 1.0;
    self.moreLabel.layer.masksToBounds = YES;
    [self setUpEvaluteChildView];
}

+ (instancetype)cellWithTableView1:(UITableView *)tableView {
    
    static NSString *ID = @"XDOrderCommentCell1";
    XDOrderCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDOrderCommentCell1" owner:nil options:nil]lastObject];
    }
    cell.backgroundColor = backColor;
    return cell;
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"XDOrderCommentCell";
    XDOrderCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XDOrderCommentCell" owner:nil options:nil]lastObject];
    }
    cell.backgroundColor = backColor;
    return cell;
    
}

- (void)setCommentModel:(XDOrderCommentModel *)commentModel {
    _commentModel = commentModel;
    self.timeLabel.text = commentModel.commentdatetime;
    
    NSString *nameString = [commentModel.owners.name substringToIndex:1];
    self.nameLabel.text = [NSString stringWithFormat:@"%@**",nameString];
    _starView.currentScore = commentModel.stargrade;
    self.contentLabel.text = commentModel.content;
    switch (commentModel.commentgrade) {
        case 0:
            self.levelLabel.text = @"差评";
            break;
        case 1:
            self.levelLabel.text = @"中评";
            break;
        case 2:
            self.levelLabel.text = @"好评";
            break;
            
        default:
            break;
    }
    
}

- (void)setUpEvaluteChildView {
    
    _starView = [[XDEvaluateStarView alloc] initWithFrame:CGRectMake(0, 0, 80, 20) numberOfStars:5 isTouchable:YES index:100];
    _starView.userInteractionEnabled = NO;
    _starView.currentScore = 2;
    _starView.totalScore = 5;
    _starView.isFullStarLimited = YES;
    [self.starBackView addSubview:_starView];
    
}

- (void)setIsCommentList:(BOOL)isCommentList {
    _isCommentList = isCommentList;
    self.topConstriant.constant = 10;
}
@end
