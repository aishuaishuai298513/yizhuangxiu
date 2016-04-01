//
//  UILabel+labelStart.m
//  HuYing
//
//  Created by mac on 15/11/17.
//  Copyright © 2015年 Quhao. All rights reserved.
//

#import "UILabel+labelStart.h"
#import "UIColor+MyColor.h"
#import <QuartzCore/QuartzCore.h>
@implementation UILabel (labelStart)
//设置String类型颜色
+(instancetype)setLabelWithColorString:(NSString *)colorString TextSize:(CGFloat)textSize TextAlignment:(NSTextAlignment)textAlignment FatherView:(UIView *)fatherView{
    UILabel * lab=[[UILabel alloc]init];
    if (colorString !=nil) {
        lab.textColor =[UIColor myColorWithString:colorString];
    }
    lab.font=[UIFont systemFontOfSize:textSize];
    
    lab.textAlignment=textAlignment;
    
    [fatherView addSubview:lab];
    
    return lab;
}
//设置系统颜色
+(instancetype)setLabelWithColor:(UIColor*)color TextSize:(CGFloat)textSize TextAlignment:(NSTextAlignment)textAlignment FatherView:(UIView *)fatherView{
    UILabel * lab=[[UILabel alloc]init];
    lab.textColor =color;
    
    lab.font=[UIFont systemFontOfSize:textSize];
    
    lab.textAlignment=textAlignment;
    
    [fatherView addSubview:lab];
    return lab;
}
+(instancetype)setLabelWithText:(NSString *)text TextColor:(UIColor*)color TextSize:(CGFloat)textSize  BorderWidth:(CGFloat)borderWidth BorderColor:(UIColor *)borderColor FatherView:(UIView *)fatherView{
    UILabel * lab=[[UILabel alloc]init];
    
    lab.text=text;
    lab.textColor=color;
    
    lab.font=[UIFont systemFontOfSize:textSize];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.layer.borderColor=[borderColor CGColor];
    lab.layer.borderWidth=borderWidth;
    
    return lab;
}

//根据文字大小调整UI
-(void)setLabelText:(NSString *)textString NumberOfLines:(NSInteger)lines textX:(CGFloat)X textY:(CGFloat)Y TextWidth:(CGFloat)textWidth
{
    self.lineBreakMode=NSLineBreakByWordWrapping;
    self.numberOfLines = lines;
    CGSize size = [self sizeThatFits:CGSizeMake(kU-20, MAXFLOAT)];
    self.frame=CGRectMake(X,Y,textWidth,size.height);
}
@end
