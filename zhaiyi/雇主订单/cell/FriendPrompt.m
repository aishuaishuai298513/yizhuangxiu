//
//  FriendPrompt.m
//  zhaiyi
//
//  Created by ass on 16/3/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FriendPrompt.h"

@interface FriendPrompt()
@property (weak, nonatomic) IBOutlet UIButton *NoBtn;

@property (weak, nonatomic) IBOutlet UIButton *YesBtn;
@end

@implementation FriendPrompt

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)FirendLoadView
{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"FriendPrompt" owner:nil options:nil]lastObject];
}

- (void)NoBtnAddTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.NoBtn addTarget:target action:action forControlEvents:controlEvents];
}

- (void)YesBtnAddTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.YesBtn addTarget:target action:action forControlEvents:controlEvents];
}

@end
