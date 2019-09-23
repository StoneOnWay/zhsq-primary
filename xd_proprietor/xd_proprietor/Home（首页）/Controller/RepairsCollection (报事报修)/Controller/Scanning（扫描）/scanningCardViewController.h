//
//  scanningWatchViewController.h
//  SmallTadpole
//
//  Created by FOX on 16/9/14.
//  Copyright © 2016年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnInformBlock)(NSString *watchInform);

@interface scanningCardViewController : UIViewController

@property (nonatomic,strong) returnInformBlock returnTextBlock;

- (void) returnInform: (returnInformBlock) block;

@end
