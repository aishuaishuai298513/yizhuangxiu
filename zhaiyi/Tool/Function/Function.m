//
//  Function.m
//  zhaiyi
//
//  Created by cajan on 16/1/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Function.h"

#import "My_Login_In_ViewController.h"

#import "tuiChuTixing.h"

#define  BLUE_COLOR [UIColor colorWithRed:80/255.0 green:210/255.0 blue:194/255.0 alpha:1]
@interface Function ()

{
    tuiChuTixing *tixing ;
    UIView *backView;
}
@end

@implementation Function

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(void)customAlertWithMessage:(NSString *)str{
UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:str delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
[alert show];
[UIView animateWithDuration:2 animations:^{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}];
}

-(void)customRightButton{
    
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton setBackgroundImage:[UIImage imageNamed:@"右上角按钮"] forState:UIControlStateNormal];
//    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
//    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    [rightButton addTarget:self action:@selector(clickFinish) forControlEvents:UIControlEventTouchUpInside];
//    rightButton.frame = CGRectMake(0, 0, 84, 30);
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = rightItem;
}










//判断手机号
+(BOOL)isMobileNumber:(NSString *)mobileNum{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     * 联通：130,131,132,152,155,156,185,186,1709
     * 电信：133,1349,153,180,189,1700
     */
    //    NSString * MOBILE = @"^1((3//d|5[0-35-9]|8[025-9])//d|70[059])\\d{7}$";//总况
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186,1709
     17         */
    NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,1700
     22         */
    NSString * CT = @"^1((33|53|8[09])\\d|349|700)\\d{7}$";
    
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
     NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    
    if (([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestphs evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        if ([mobileNum isEqualToString:@""]) {
            
        } else {
//            [self customAlertWithMessage:@"请输入合法手机号"];
            [ITTPromptView showMessage:@"请输入合法手机号"];
        }
        return NO;
    }
}

//设置同一段文字不同颜色
+(void)fuwenbenLabel:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    labell.attributedText = str;

}

//创建一个底部弹出View
+(instancetype)createBackView:(nullable id)Target  action:(SEL)action
{
    //底部大的透明View
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    
     UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:Target action:action];
    [bgView addGestureRecognizer:tap];
    
    return bgView;
    
}

//设置星级
+(void)xingji:(UIView *)view xingji:(int)xingji startTag:(int)starTag
{
    
    for (int i = starTag; i<starTag+5; i++) {
        UIView *imageV = (UIView *)[view viewWithTag:i];
        
        if ([imageV isKindOfClass:[UIImageView class]]) {
            
            UIImageView *image = (UIImageView *)imageV;
            
             image.image = [UIImage imageNamed:@"xing3"];
        }
        
        if ([imageV isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)imageV;
            //[btn setBackgroundImage:[UIImage imageNamed:@"xing3"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"xing3"] forState:UIControlStateNormal];
        }
        
    }
    
    for (int i = starTag; i<starTag+xingji; i++) {
        
        UIView *imageV = (UIView *)[view viewWithTag:i];
        
        if ([imageV isKindOfClass:[UIImageView class]]) {
            
            UIImageView *image = (UIImageView *)imageV;
            
            image.image = [UIImage imageNamed:@"xing"];
        }
        
        if ([imageV isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)imageV;
            //[btn setBackgroundImage:[UIImage imageNamed:@"xing"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"xing3"] forState:UIControlStateNormal];
        }
    }
}


//退出登陆
+(void)tuichuLogin
{
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"tuichu" object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}

//保存找工人通知数
+(void)SaveFaBuZhaoGongRen:(NSString *)num
{
//    [[NSUserDefaults standardUserDefaults]objectForKey:@"fadanTongZhi"];
    
    if ( ! [[NSUserDefaults standardUserDefaults]objectForKey:@"fadanTongZhi"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"fadanTongZhi"];
    }else
    {
      NSString *num = [[NSUserDefaults standardUserDefaults]objectForKey:@"fadanTongZhi"];
        NSString *newNum = [NSString stringWithFormat:@"%ld",[num integerValue]+1];
        
        [[NSUserDefaults standardUserDefaults]setObject:newNum forKey:@"fadanTongZhi"];
        
    }
}
//保存工人订单通知
+(void)SaveDingDanChangge_gongren:(NSString *)num
{
//    [[NSUserDefaults standardUserDefaults]objectForKey:@"gongrendingdan"];
    
    if ( ! [[NSUserDefaults standardUserDefaults]objectForKey:@"gongrendingdan"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"gongrendingdan"];
    }else
    {
        NSString *num = [[NSUserDefaults standardUserDefaults]objectForKey:@"gongrendingdan"];
        NSString *newNum = [NSString stringWithFormat:@"%ld",[num integerValue]+1];
        
        [[NSUserDefaults standardUserDefaults]setObject:newNum forKey:@"gongrendingdan"];
        
    }
    
    
}
// 保存雇主订单通知
+(void)SaveDingDanChangge_guzhu:(NSString *)num
{
//    [[NSUserDefaults standardUserDefaults]objectForKey:@"guzhudingdan"];
    
    if ( ! [[NSUserDefaults standardUserDefaults]objectForKey:@"guzhudingdan"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"guzhudingdan"];
    }else
    {
        NSString *num = [[NSUserDefaults standardUserDefaults]objectForKey:@"guzhudingdan"];
        NSString *newNum = [NSString stringWithFormat:@"%ld",[num integerValue]+1];
        
        [[NSUserDefaults standardUserDefaults]setObject:newNum forKey:@"guzhudingdan"];
        
    }
    
    
}
+(void)qingLingDiangDan_gongRen
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"gongrendingdan"]) {
    
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"gongrendingdan"];
        }
}

+(void)qingLingDiangDan_guZhu
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"guzhudingdan"]) {
        
          [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"guzhudingdan"];
    }
    

}
+(void)qingLingQiangDan_gongRen
{
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"fadanTongZhi"])
        {
           [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"fadanTongZhi"];
        }

}

+(int)getbageValue
{
    if ( [[NSUserDefaults standardUserDefaults]objectForKey:@"guzhudingdan"]) {
        
      int num =  [[[NSUserDefaults standardUserDefaults]objectForKey:@"guzhudingdan"] intValue];
        return num;
    }else
    {
        return 0;
    }
}
@end

