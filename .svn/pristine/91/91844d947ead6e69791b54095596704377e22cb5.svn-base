//
//  UIButton+btnStart.m
//  HuYing
//
//  Created by mac on 15/11/17.
//  Copyright © 2015年 Quhao. All rights reserved.
//

#import "UIButton+btnStart.h"
#import "UIColor+MyColor.h"
@implementation UIButton (btnStart)
#pragma mark 按照image名字返回设置普通和selected状态的button
+(instancetype)setButtonImgWithTitle:(NSString*)setTitleString TitleLabelSize:(CGFloat)titleSize setTitleColor:(NSString *)titleColor NormalImage:(NSString *)imageNormal selectedImage:(NSString *)imageSelected target:(id)target action:(SEL)action setFatherView:(UIView *)fatherView{
    UIButton *button = [[UIButton alloc]init];
        [button setTitle:setTitleString forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:titleSize];
        [button setTitleColor:[UIColor myColorWithString:titleColor] forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed:imageNormal] forState:UIControlStateNormal];
    
    if (imageSelected !=nil) {
        [button setImage:[UIImage imageNamed:imageSelected] forState:UIControlStateSelected];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [fatherView addSubview:button];
    
    return button;
}

#pragma mark 按照backroundn img名字返回设置普通和selected状态的带文字button
+(instancetype)setButtonBackgroudImgWithTitle:(NSString*)setTitleString TitleLabelSize:(CGFloat)titleSize setTitleColor:(NSString *)titleColor NormalBackground:(NSString *)imageNormal selectedBackground:(NSString *)imageSelected target:(id)target action:(SEL)action setFatherView:(UIView *)fatherView{
    UIButton *button = [[UIButton alloc]init];
    
        [button setTitle:setTitleString forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:titleSize];
        [button setTitleColor:[UIColor myColorWithString:titleColor] forState:UIControlStateNormal];

    [button setBackgroundImage:[UIImage imageNamed:imageNormal] forState:UIControlStateNormal];
    
    if (imageSelected !=nil) {
        [button setBackgroundImage:[UIImage imageNamed:imageSelected] forState:UIControlStateSelected];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [fatherView addSubview:button];
    return button;
}

#pragma mark 按照backroundn img名字返回设置普通和selected状态的带文字button
+(instancetype)setButtonBackgroudColorWithTitle:(NSString*)setTitleString TitleLabelSize:(CGFloat)titleSize setTitleColor:(UIColor *)titleColor BackgroundString:(NSString *)colorString BackgroundColor:(UIColor *)colorName target:(id)target action:(SEL)action setFatherView:(UIView *)fatherView{
    UIButton *button = [[UIButton alloc]init];
    
    [button setTitle:setTitleString forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:titleSize];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    if (colorString !=nil ) {
        [button setBackgroundColor:[UIColor myColorWithString:colorString]];
    }else if(colorName !=nil)
    {
        [button setBackgroundColor:colorName];
    }else
    {
        [button setBackgroundColor:[UIColor whiteColor]];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [fatherView addSubview:button];
    return button;
}

#pragma mark 按照image名字返回设置普通和selected状态的button
+(instancetype)setButtonImgWithWithNormalImage:(NSString *)imageNormal selectedImage:(NSString *)imageSelected target:(id)target action:(SEL)action setFatherView:(UIView *)fatherView{
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:imageNormal] forState:UIControlStateNormal];
    if (imageSelected !=nil) {
        [button setImage:[UIImage imageNamed:imageSelected] forState:UIControlStateSelected];
    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [fatherView addSubview:button];
    
    return button;
}

//设置没有图片的btn
+(instancetype)setButtonNoImgWithTitle:(NSString*)setTitleString TitleLabelSize:(CGFloat)titleSize TitleColor:(UIColor *)color target:(id)target action:(SEL)action setFatherView:(UIView *)fatherView{
    
    UIButton *button = [[UIButton alloc]init];
    
    [button setTitle:setTitleString forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:titleSize];
    
    if (color !=nil) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }else
    {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [fatherView addSubview:button];
    
    return button;    
}

@end
