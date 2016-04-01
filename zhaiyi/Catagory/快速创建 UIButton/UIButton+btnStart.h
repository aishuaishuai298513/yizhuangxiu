//
//  UIButton+btnStart.h
//  HuYing
//
//  Created by mac on 15/11/17.
//  Copyright © 2015年 Quhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (btnStart)
//设置有图片的button
+(instancetype)setButtonImgWithTitle:(NSString*)setTitleString TitleLabelSize:(CGFloat)titleSize setTitleColor:(NSString *)titleColor NormalImage:(NSString *)imageNormal selectedImage:(NSString *)imageSelected target:(id)target action:(SEL)action setFatherView:(UIView *)fatherView;
//设置带背景图片的button
+(instancetype)setButtonBackgroudImgWithTitle:(NSString*)setTitleString TitleLabelSize:(CGFloat)titleSize setTitleColor:(NSString *)titleColor NormalBackground:(NSString *)imageNormal selectedBackground:(NSString *)imageSelected target:(id)target action:(SEL)action setFatherView:(UIView *)fatherView;
//设置带背景颜色的button
+(instancetype)setButtonBackgroudColorWithTitle:(NSString*)setTitleString TitleLabelSize:(CGFloat)titleSize setTitleColor:(NSString *)titleColor BackgroundString:(NSString *)colorString BackgroundColor:(UIColor *)colorName target:(id)target action:(SEL)action setFatherView:(UIView *)fatherView;
//设置没有文字的button
+(instancetype)setButtonImgWithWithNormalImage:(NSString *)imageNormal selectedImage:(NSString *)imageSelected target:(id)target action:(SEL)action setFatherView:(UIView *)fatherView;
//设置没有图片的button
+(instancetype)setButtonNoImgWithTitle:(NSString*)setTitleString TitleLabelSize:(CGFloat)titleSize TitleColor:(UIColor *)color target:(id)target action:(SEL)action setFatherView:(UIView *)fatherView;
@end
