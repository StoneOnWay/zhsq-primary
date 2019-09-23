//
//  XDComplainDetailCell.m
//  XD业主
//
//  Created by zc on 2017/6/22.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDComplainDetailCell.h"


@implementation XDComplainDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"XDComplainDetailCell";
    XDComplainDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[XDComplainDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = backColor;
        // 添加子控件
        [self setUpChildView];
        
    }
    return self;
}
//添加子控件
- (void)setUpChildView {

    // title
    UILabel *titlesLabel = [[UILabel alloc] init];
    [self addSubview:titlesLabel];
    titlesLabel.textColor = RGB(74, 74, 74);
    titlesLabel.font = titleFont;
    self.titlesLabel = titlesLabel;
    
    // 完成状态
    UILabel *finishLabel = [[UILabel alloc] init];
    finishLabel.font = titleFont;
    finishLabel.textColor = RGB(69, 145, 107);
    [self addSubview:finishLabel];
    self.finishLabel = finishLabel;
    
    // 正文
    UILabel *textsLabel = [[UILabel alloc] init];
    textsLabel.font = textFont;
    textsLabel.textColor = RGB(74, 74, 74);
    //换行
    textsLabel.numberOfLines = 0;
    [self addSubview:textsLabel];
    self.textsLabel = textsLabel;
    
    
    // 时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = timeFont;
    timeLabel.textColor = RGB(155, 155, 155);
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;

    // 图片
    // 创建一个流水布局photosView(默认为流水布局)
    PYPhotosView *flowPhotosView = [PYPhotosView photosView];
    // 设置分页指示类型
    flowPhotosView.pageType = PYPhotosViewPageTypeLabel;
    flowPhotosView.py_centerX = self.py_centerX;
    flowPhotosView.py_y = 20 + 64;
    flowPhotosView.photoWidth = cellPhotosW;
    flowPhotosView.photoHeight = cellPhotosH ;
    flowPhotosView.photoMargin = cellPhotosMargin;
    [self addSubview:flowPhotosView];
    self.photosView = flowPhotosView;
    self.photosView.backgroundColor = [UIColor clearColor];

}
- (void)setComplainFrames:(XDComplainDetailModelFrame *)complainFrames {
    _complainFrames = complainFrames;
    
    [self setSubViewsData];
    [self setSubViewsFrame];

    if (self.complainFrames.complainModel.photos.count != 0) {
        
        NSMutableArray *photos = [NSMutableArray array];
        //设置默认显示三张图片
        for (int i = 0; i<self.complainFrames.complainModel.photos.count; i++) {
            NSString *urlString = self.complainFrames.complainModel.photos[i][@"url"];
            
            urlString = [NSString stringWithFormat:@"%@/%@",K_BASE_URL,urlString];
            [photos addObject:urlString];
            
        }

        self.photosView.hidden = NO;
        // 设置图片缩略图数组
        self.photosView.thumbnailUrls = photos ;
        // 设置图片原图地址
        self.photosView.originalUrls = photos ;
        
        
        self.photosView.frame =self.complainFrames.photoViewFrame;

    }else {
    
        self.photosView.hidden = YES;
    }
    
    
}

-(void)setSubViewsData{
    
    self.titlesLabel.text = self.complainFrames.complainModel.title;
    self.textsLabel.text = self.complainFrames.complainModel.text;
    self.finishLabel.text = self.complainFrames.complainModel.finishText;
    self.timeLabel.text = self.complainFrames.complainModel.time;
    
    
}

-(void)setSubViewsFrame{
    self.titlesLabel.frame = self.complainFrames.titleFrame;
    self.textsLabel.frame = self.complainFrames.textFrame;
    self.finishLabel.frame = self.complainFrames.finishFrame;
    self.timeLabel.frame = self.complainFrames.timeFrame;
    
}


@end
