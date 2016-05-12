//
//  Function.h
//  zhaiyi
//
//  Created by cajan on 16/1/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Function : UIView<UIAlertViewDelegate>

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


//通过tag值设置星级
+(void)xingji:(UIView *)view xingji:(int)xingji startTag:(int)starTag;

//退出登陆
+(void)tuichuLogin;

//保存通知数量
+(void)SaveFaBuZhaoGongRen:(NSString *)num;

+(void)SaveDingDanChangge_gongren:(NSString *)num;
// 保存雇主订单通知
+(void)SaveDingDanChangge_guzhu:(NSString *)num;

+(void)qingLingDiangDan_gongRen;

+(void)qingLingDiangDan_guZhu;

+(void)qingLingQiangDan_gongRen;

+(int)getbageValue;

@end
