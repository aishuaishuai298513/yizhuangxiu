//
//  FriendPrompt.h
//  zhaiyi
//
//  Created by ass on 16/3/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendPrompt : UIView

+(instancetype)FirendLoadView;

- (void)NoBtnAddTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)YesBtnAddTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
