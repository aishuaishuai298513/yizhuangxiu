//
//  ADTextView.m
//  zhaiyi
//
//  Created by exe on 15/12/6.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ADTextView.h"
#import "UIView+Extension.h"
@interface ADTextView()
@property(nonatomic,weak)UILabel *placehoderLabel;
@end
@implementation ADTextView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //添加一个显示文字的label
        UILabel *placehoderLabel = [[UILabel alloc]init];
        placehoderLabel.backgroundColor = [UIColor clearColor];
        //添加到ADTextView上
        [self addSubview:placehoderLabel];
        self.placehoderLabel = placehoderLabel;
        //设置默认占位文字颜色
        self.placeholderColor = [UIColor lightGrayColor];
        //设置默认字体
        self.font = [UIFont systemFontOfSize:15];
        //监听文本框的文字改变（用通知）
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}
//移除监听
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
//文本框文字改变
-(void)textDidChange
{
    //如果文本框文字不为0，占位文字就隐藏
    self.placehoderLabel.hidden = (self.text.length!=0);
}
//1.重写placeholder的setter方法是为了能知道外界改了什么文字
-(void)setPlaceholder:(NSString *)placeholder
{
    //1.如果是遵循了copy协议，最好在保存的时候用copy修饰
    _placeholder = [placeholder copy];
    //2.设置文字
    self.placehoderLabel.text = placeholder;
    //3.重新计算子控件的frame
    //    [self setNeedsLayout];
}
//2.重写占位文字的setter方法
-(void)setPlaceholderColor:(UIColor *)placeholderColor
{
    //外界传进来的颜色赋值给ADTextView的属性
    _placeholderColor = placeholderColor;
    self.placehoderLabel.textColor = placeholderColor;
    
}
//3.设置placehoderLabel的frame

-(void)layoutSubviews
{
    self.placehoderLabel.x = 8;
    self.placehoderLabel.y = 8;
    self.placehoderLabel.width = self.width - 2*self.placehoderLabel.x;
    //根据文字计算label的高度
    CGSize maxSize = CGSizeMake(self.placehoderLabel.width, MAXFLOAT);
    CGSize placehoderSize = [self.placeholder sizeWithFont:self.placehoderLabel.font constrainedToSize:maxSize];
    self.placehoderLabel.height = placehoderSize.height;
}
//重写设置文字大小的setter方法
-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placehoderLabel.font = font;
}


@end
