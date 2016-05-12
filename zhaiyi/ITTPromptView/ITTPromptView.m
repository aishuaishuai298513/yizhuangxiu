//
//  ITTPromptView.m
//  YiXin
//
//  Created by qiuyan on 15-2-2.
//  Copyright (c) 2015年 com.yixin. All rights reserved.
//

#import "ITTPromptView.h"
#import "UIView+ITTAdditions.h"

@implementation ITTPromptView

@synthesize message = _message;


+(ITTPromptView *)showMessage:(NSString *)message
{
    ITTPromptView *view = [super viewFromNib];
    [view show];
    view.frametop -= 50;
    view.message.text = message;
    return view;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self makeCornerRadius:5.0f];
    [self performSelector:@selector(cancel) withObject:nil afterDelay:2];
}
@end
