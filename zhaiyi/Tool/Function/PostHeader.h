//
//  PostHeader.h
//  zhaiyi
//
//  Created by cajan on 16/1/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#ifndef PostHeader_h
#define PostHeader_h

//屏幕 rect
#define SCREEN_RECT ([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//返回
#define pop [self.navigationController popViewControllerAnimated:YES];

//设置工人
#define SetUserDefaultsGR [[NSUserDefaults standardUserDefaults]setObject:@"78" forKey:@"shenfentype"];
//设置雇主
#define SetUserDefaultsGZ [[NSUserDefaults standardUserDefaults]setObject:@"79" forKey:@"shenfentype"];
//判断是否是工人
#define GetUserDefaultsGR [[[NSUserDefaults standardUserDefaults]objectForKey:@"shenfentype"]isEqualToString:@"78"]
//判断是否是雇主
#define GetUserDefaultsGZ [[[NSUserDefaults standardUserDefaults]objectForKey:@"shenfentype"]isEqualToString:@"79"]
//判断是否登陆
#define IfUserLogin [[NSUserDefaults standardUserDefaults]objectForKey:@"shenfentype"]
//推出登陆
#define LogOut [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"shenfentype"];


#define MJCodingImplementation \
- (id)initWithCoder:(NSCoder *)decoder \
{ \
if (self = [super init]) { \
[self mj_decode:decoder]; \
} \
return self; \
} \
\
- (void)encodeWithCoder:(NSCoder *)encoder \
{ \
[self mj_encode:encoder]; \
}

//主题红
#define THEME_COLOR [UIColor colorWithRed:211/255.0 green:42/255.0 blue:65/255.0 alpha:1]

//获取工种列表
#define POST_GONGZHONG_LIST @"/api/personal/work_sort"
//雇主端修改资料
#define POST_GUZHU_DETAIL_URL @"/api/personal/edit_employee"
 //工人端修改资料
#define POST_GONGREN_DETAIL_URL @"/api/personal/save_user"
//添加银行卡
#define POST_ADD_BANKCARD @"/api/personal/add_bank_card"
//银行卡列表
#define POST_BANK_LIST @"/api/personal/my_bank_card"

//提现
#define POST_GET_CASH @"/api/personal/user_cash_money"
//用户交易
#define POST_USER_TRADE @"/api/personal/user_trade"

//用户交易详情
#define POST_USER_TRADE_DETAIL @"/api/personal/user_trade_details"

//版本更新
#define POST_UPDATE_VERSION @"/api/index/edition_upgrade"
//获取验证码
#define POST_MESSAGE_CODE @"/api/user/SendTemplateSMS"
//忘记密码
#define POST_NEW_PASSWORD @"/api/user/back_password"

//分享的页面
#define SHARE_URL @"/share/index.html"

//关于小木匠
#define POST_ABOUT_XMJ @"/api/index/about_our"

//基本地址
#define XMJ_BASE_URL @"http://zhaiyi.bjqttd.com"

//工人钱包
#define POST_GONGREN_POCKET_URL @"/api/personal/my_money"

//雇主钱包
#define POST_GUZHU_POCKET_URL @"/api/personal/my_employee_money"

//获取余额
#define POST_REMAIN_MONEY @"/api/personal/my_balance"
//修改工人端头像
#define POST_GONGREN_PHOTO @"/api/personal/save_image"
//修改雇主端头像
#define POST_GUZHU_PHOTO @"/api/personal/save_em_image"




//#define  WX_APP_ID          @"wx2863d9247c321b5c"               //APPID
#define  WX_APP_ID          @"wx05c7d1017ae4ebdb"

//#define  WX_APP_SECRET      @"e5cf3a3ed66f1090275eb2bb997b2076" //appsecret
#define  WX_APP_SECRET      @"f1bfd3a7eb4465fcb3dc151e8656b359"
//商户号，填写商户对应参数
#define WX_MCH_ID          @"1303015401"
//商户API密钥，填写相应参数
#define  WX_PARTNER_ID      @"f25b123351f463f43a8d93bc49143b54"

/****     ***/

//支付结果回调页面
#define  WX_NOTIFY_URL      @"zhaiyi.bjqttd.com/api/recharge/wechat_alipay"

//获取服务器端支付数据地址（商户自定义）
#define  WX_SP_URL   @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"


//当前版本号
#define CURRENT_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

const static NSString *APIKey = @"6f4c9c980d94f3a2aed5c81756720275";

const static NSString *TableID = @"";


#endif /* PostHeader_h */
