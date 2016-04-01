//
//  Function.h
//  zhaiyi
//
//  Created by cajan on 16/1/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Function : UIView

/**
 *  自定义弹出
 */
//+(void)customAlertWithMessage:(NSString *)str;

/**
 *  判断手机号
 */
+(BOOL)isMobileNumber:(NSString *)mobileNum;

+(void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
;

+(instancetype)createBackView:(nullable id)Target  action:(SEL)action;

@end