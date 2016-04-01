//
//  UIBarButtonItem+Extension.m
//  adan微博
//
//  Created by exe on 15/11/20.
//  Copyright (c) 2015年 adan. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
@implementation UIBarButtonItem (Extension)
+(UIBarButtonItem *)itemWithImage:(NSString *)imageName selectedImage:(NSString *)selectedImageName target:(id)target action:(SEL)action
{
    //1.设置按钮
    UIButton *button = [[UIButton alloc]init];
    //2.设置左边按钮普通状态和选中状态下的图片
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateHighlighted];
    //3.设置按钮的尺寸为背景图片的尺寸
    button.size = button.currentBackgroundImage.size;
    //4.监听按钮的点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //5.返回一个创建好的UIBarButtonItem
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}
@end
