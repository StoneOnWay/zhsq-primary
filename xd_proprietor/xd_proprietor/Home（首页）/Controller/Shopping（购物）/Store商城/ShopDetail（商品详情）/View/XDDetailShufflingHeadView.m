//
//  XDDetailShufflingHeadView.m
//  XD业主
//
//  Created by zc on 2018/3/14.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDDetailShufflingHeadView.h"
#import "SDCycleScrollView.h"
#import "XDResourceListModel.h"

@interface XDDetailShufflingHeadView ()<SDCycleScrollViewDelegate>

/* 轮播图 */
@property (strong , nonatomic)SDCycleScrollView *cycleScrollView;

@end

@implementation XDDetailShufflingHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, self.height) delegate:self placeholderImage:nil];
    _cycleScrollView.autoScroll = NO; // 不自动滚动
    
    [self addSubview:_cycleScrollView];
}

#pragma mark - 点击图片Bannar跳转
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"点击了%zd轮播图",index);
}

#pragma mark - Setter Getter Methods
- (void)setShufflingArray:(NSArray *)shufflingArray
{
    _shufflingArray = shufflingArray;
    
    XDResourceListModel *resourceModel = shufflingArray.firstObject;
    NSArray *urlArray = [resourceModel.url componentsSeparatedByString:@","]; //从字符,中分隔成2个元素的数组
    NSMutableArray *urlRealArray = [NSMutableArray array];
    for (NSString *urlString in urlArray) {
        
        NSString *urlStrings = [NSString stringWithFormat:@"%@/%@",K_BASE_URL,urlString];
        NSString *imgUrl = [urlStrings  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [urlRealArray addObject:imgUrl];
    }
    _cycleScrollView.imageURLStringsGroup = urlRealArray;
    
}


@end
