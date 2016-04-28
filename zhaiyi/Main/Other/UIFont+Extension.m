//
//  UIFont+Extension.m
//  zhaiyi
//
//  Created by ass on 16/4/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIFont+Extension.h"

@implementation UIFont (Extension)

//根据屏幕宽度返回不同比例字体
+(UIFont *)systemFontSizeWithScreen:(CGFloat)fontSize
{
   CGFloat size = [UIScreen mainScreen].bounds.size.width/320*fontSize;
    return [UIFont systemFontOfSize:size];
}

+(UIFont *)systemFontSizeWithScreen:(CGFloat)fontSize addSizeNumber:(CGFloat)addNum
{
    CGFloat size = [UIScreen mainScreen].bounds.size.width/320*fontSize +addNum;
    return [UIFont systemFontOfSize:size];
}


@end
