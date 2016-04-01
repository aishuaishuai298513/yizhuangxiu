//
//  UILabel+labelStart.h
//  HuYing
//
//  Created by mac on 15/11/17.
//  Copyright © 2015年 Quhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (labelStart)
//设置String类型颜色
+(instancetype)setLabelWithColorString:(NSString *)colorString TextSize:(CGFloat)textSize TextAlignment:(NSTextAlignment)textAlignment FatherView:(UIView *)fatherView;
//设置系统颜色
+(instancetype)setLabelWithColor:(UIColor*)color TextSize:(CGFloat)textSize TextAlignment:(NSTextAlignment)textAlignment FatherView:(UIView *)fatherView;
//带边框
+(instancetype)setLabelWithText:(NSString *)text TextColor:(UIColor*)color TextSize:(CGFloat)textSize  BorderWidth:(CGFloat)borderWidth BorderColor:(UIColor *)borderColor FatherView:(UIView *)fatherView;
//根据文字大小调整UI
-(void)setLabelText:(NSString *)textString NumberOfLines:(NSInteger)lines textX:(CGFloat)X textY:(CGFloat)Y TextWidth:(CGFloat)textWidth;
@end
