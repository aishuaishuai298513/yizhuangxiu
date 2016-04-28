//
//  UIFont+Extension.h
//  zhaiyi
//
//  Created by ass on 16/4/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Extension)
+(UIFont*)systemFontSizeWithScreen:(CGFloat)fontSize;

+(UIFont*)systemFontSizeWithScreen:(CGFloat)fontSize addSizeNumber:(CGFloat)addNum;
@end
