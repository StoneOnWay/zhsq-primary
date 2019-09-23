//
//  XDJsInteraction.h
//  xd_proprietor
//
//  Created by cfsc on 2019/7/13.
//  Copyright © 2019年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol XDJsInteractionProtocal <JSExport>

- (void)testIOSInteraction:(NSString *)str;

@end


NS_ASSUME_NONNULL_BEGIN

@interface XDJsInteraction : NSObject <XDJsInteractionProtocal>

@end

NS_ASSUME_NONNULL_END
